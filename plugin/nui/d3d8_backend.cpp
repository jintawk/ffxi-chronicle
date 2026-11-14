// d3d8_backend.cpp - see d3d8_backend.hpp
#include "d3d8_backend.hpp"

#include <algorithm>
#include <cstring>
#include <vector>

namespace nui {

bool D3D8Backend::init(IDirect3DDevice8* d) {
    if (d != dev || grey_caps < 0) {
        // the grey stages (grey_on below) need MULTIPLYADD + DOTPRODUCT3 and three blend stages;
        // without them a grey batch is drawn in colour (status().grey_ok says which)
        grey_caps = 0;
        D3DCAPS8 c {};
        if (d && SUCCEEDED(d->GetDeviceCaps(&c)))
            grey_caps = (c.TextureOpCaps & D3DTEXOPCAPS_MULTIPLYADD) && (c.TextureOpCaps & D3DTEXOPCAPS_DOTPRODUCT3) &&
                        c.MaxTextureBlendStages >= 3 && c.MaxSimultaneousTextures >= 3 ? 1 : 0;
    }
    dev = d;
    return dev != nullptr;
}

IDirect3DTexture8* create_texture(IDirect3DDevice8* dev, uint32_t const* argb, int w, int h) {
    if (!dev || !argb || w <= 0 || h <= 0) return nullptr;
    IDirect3DTexture8* t = nullptr;
    // MANAGED, never DEFAULT: we never see the game's Reset, and a DEFAULT resource alive across it
    // makes Reset fail
    if (FAILED(dev->CreateTexture(w, h, 1, 0, D3DFMT_A8R8G8B8, D3DPOOL_MANAGED, &t))) return nullptr;
    D3DLOCKED_RECT lr;
    if (FAILED(t->LockRect(0, &lr, nullptr, 0))) { t->Release(); return nullptr; }
    for (int y = 0; y < h; ++y)
        std::memcpy(static_cast<char*>(lr.pBits) + y * lr.Pitch, argb + size_t(y) * w, size_t(w) * 4);
    t->UnlockRect(0);
    return t;
}

void D3D8Backend::attach(int handle, NcRef const& ref) {
    drop(handle);
    ++tex_gen;
    if (!ref.obj) return;
    Tex t;
    t.t = static_cast<IDirect3DTexture8*>(ref.obj);
    t.w = ref.w;
    t.h = ref.h;
    t.ref = ref;
    tex[handle] = t;
}

namespace {
// a private ref waits for the render thread (flush_pending); a shared one is given back now
void give_back(std::vector<NcRef>& pending, NcRef& ref) {
    if (!ref.obj) return;
#ifndef NUI_FAULT_RELEASE_ON_LUA          // self-test: private textures Released by the caller's thread (before 1.2.5)
    if (ref.entry < 0) {
        try {
            pending.push_back(ref);
            ref = NcRef {nullptr, -1, 0, 0, 0, 0};
            return;
        } catch (...) {           // out of memory: released here, as before 1.2.5
        }
    }
#endif
    nc_release(ref);
}
}  // namespace

void D3D8Backend::drop(int handle) {
    auto it = tex.find(handle);
    if (it == tex.end()) return;
    give_back(pending, it->second.ref);
    tex.erase(it);
    ++tex_gen;
}

void D3D8Backend::flush_pending() {
    for (NcRef& r : pending) nc_release(r);
    pending.clear();
}

namespace {
D3DRENDERSTATETYPE const kRs[] = {
    D3DRS_ALPHABLENDENABLE, D3DRS_SRCBLEND, D3DRS_DESTBLEND, D3DRS_ZENABLE, D3DRS_ZWRITEENABLE,
    D3DRS_LIGHTING, D3DRS_CULLMODE, D3DRS_FOGENABLE, D3DRS_ALPHATESTENABLE, D3DRS_STENCILENABLE,
    D3DRS_SPECULARENABLE, D3DRS_COLORVERTEX, D3DRS_FILLMODE, D3DRS_SHADEMODE, D3DRS_COLORWRITEENABLE,
    D3DRS_BLENDOP, D3DRS_WRAP0};
D3DTEXTURESTAGESTATETYPE const kTss[] = {
    D3DTSS_COLOROP, D3DTSS_COLORARG1, D3DTSS_COLORARG2, D3DTSS_ALPHAOP, D3DTSS_ALPHAARG1, D3DTSS_ALPHAARG2,
    D3DTSS_MINFILTER, D3DTSS_MAGFILTER, D3DTSS_MIPFILTER, D3DTSS_ADDRESSU, D3DTSS_ADDRESSV,
    D3DTSS_TEXCOORDINDEX, D3DTSS_TEXTURETRANSFORMFLAGS};
constexpr int kNRs = sizeof(kRs) / sizeof(kRs[0]), kNTss = sizeof(kTss) / sizeof(kTss[0]);

// Grey (1.1.0). Saved on the frame's first grey batch, restored after the last list; a frame with no
// grey batch makes exactly the calls it made before 1.1.0. Fixed function, three stages:
//   0  MULTIPLYADD  0.5 + 0.5 * tex                      (TFACTOR alpha 128 replicated: the 0.5s)
//   1  DOTPRODUCT3  4 * sum((cur - 0.5) * (tf - 0.5)) = sum(w * tex), with tf = 0.5 + w / 2, w Rec. 601
//   2  MODULATE     luma * diffuse; alpha = tex.a * diffuse.a (stage 2 samples the texture again:
//                   DOTPRODUCT3 writes its sum into the stage's alpha too)
// TFACTOR = A 128, R 166, G 202, B 142 (w = 0.302, 0.584, 0.114).
constexpr DWORD kGreyFactor = 0x80A6CA8Eu;
D3DTEXTURESTAGESTATETYPE const kTssGrey[] = {
    D3DTSS_COLOROP, D3DTSS_COLORARG1, D3DTSS_COLORARG2, D3DTSS_ALPHAOP, D3DTSS_ALPHAARG1, D3DTSS_ALPHAARG2,
    D3DTSS_MINFILTER, D3DTSS_MAGFILTER, D3DTSS_MIPFILTER, D3DTSS_ADDRESSU, D3DTSS_ADDRESSV,
    D3DTSS_TEXCOORDINDEX, D3DTSS_TEXTURETRANSFORMFLAGS};
constexpr int kNTssGrey = sizeof(kTssGrey) / sizeof(kTssGrey[0]);

struct GreySave {
    bool saved = false;
    DWORD tf = 0, arg0 = 0, s1[kNTssGrey] {}, s2[kNTssGrey] {}, s3c = 0, s3a = 0;
    IDirect3DBaseTexture8* t1 = nullptr;
    IDirect3DBaseTexture8* t2 = nullptr;
    void save(IDirect3DDevice8* d) {
        if (saved) return;
        saved = true;
        d->GetRenderState(D3DRS_TEXTUREFACTOR, &tf);
        d->GetTextureStageState(0, D3DTSS_COLORARG0, &arg0);
        for (int i = 0; i < kNTssGrey; ++i) d->GetTextureStageState(1, kTssGrey[i], &s1[i]);
        for (int i = 0; i < kNTssGrey; ++i) d->GetTextureStageState(2, kTssGrey[i], &s2[i]);
        d->GetTextureStageState(3, D3DTSS_COLOROP, &s3c);
        d->GetTextureStageState(3, D3DTSS_ALPHAOP, &s3a);
        d->GetTexture(1, &t1);
        d->GetTexture(2, &t2);
    }
    // before the colour restore, which then puts back stage 1's COLOROP / ALPHAOP over this copy
    void restore(IDirect3DDevice8* d) {
        if (!saved) return;
#ifndef NUI_FAULT_GREY_NO_RESTORE         // self-test: a renderer that leaves its grey stages behind
        d->SetRenderState(D3DRS_TEXTUREFACTOR, tf);
        d->SetTextureStageState(0, D3DTSS_COLORARG0, arg0);
        for (int i = 0; i < kNTssGrey; ++i) d->SetTextureStageState(1, kTssGrey[i], s1[i]);
        for (int i = 0; i < kNTssGrey; ++i) d->SetTextureStageState(2, kTssGrey[i], s2[i]);
        d->SetTextureStageState(3, D3DTSS_COLOROP, s3c);
        d->SetTextureStageState(3, D3DTSS_ALPHAOP, s3a);
        d->SetTexture(1, t1);
        d->SetTexture(2, t2);
#endif
        if (t1) t1->Release();
        if (t2) t2->Release();
        t1 = t2 = nullptr;
        saved = false;
    }
};

// the stages for a grey batch of texture t drawn with filter f (stage 0's texture and filters are the caller's)
void grey_on(IDirect3DDevice8* d, IDirect3DTexture8* t, DWORD f) {
    d->SetRenderState(D3DRS_TEXTUREFACTOR, kGreyFactor);
    d->SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MULTIPLYADD);
    d->SetTextureStageState(0, D3DTSS_COLORARG0, D3DTA_TFACTOR | D3DTA_ALPHAREPLICATE);
    d->SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TFACTOR | D3DTA_ALPHAREPLICATE);
    d->SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_TEXTURE);
    d->SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_SELECTARG1);
    d->SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);
    d->SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_DOTPRODUCT3);
    d->SetTextureStageState(1, D3DTSS_COLORARG1, D3DTA_CURRENT);
    d->SetTextureStageState(1, D3DTSS_COLORARG2, D3DTA_TFACTOR);
    d->SetTextureStageState(1, D3DTSS_ALPHAOP, D3DTOP_SELECTARG1);
    d->SetTextureStageState(1, D3DTSS_ALPHAARG1, D3DTA_CURRENT);
    d->SetTextureStageState(1, D3DTSS_TEXCOORDINDEX, 0);
    d->SetTextureStageState(1, D3DTSS_TEXTURETRANSFORMFLAGS, D3DTTFF_DISABLE);
    d->SetTexture(1, nullptr);
    d->SetTextureStageState(2, D3DTSS_COLOROP, D3DTOP_MODULATE);
    d->SetTextureStageState(2, D3DTSS_COLORARG1, D3DTA_CURRENT);
    d->SetTextureStageState(2, D3DTSS_COLORARG2, D3DTA_DIFFUSE);
    d->SetTextureStageState(2, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
    d->SetTextureStageState(2, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);
    d->SetTextureStageState(2, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE);
    d->SetTextureStageState(2, D3DTSS_MINFILTER, f);
    d->SetTextureStageState(2, D3DTSS_MAGFILTER, f);
    d->SetTextureStageState(2, D3DTSS_MIPFILTER, D3DTEXF_NONE);
    d->SetTextureStageState(2, D3DTSS_ADDRESSU, D3DTADDRESS_CLAMP);
    d->SetTextureStageState(2, D3DTSS_ADDRESSV, D3DTADDRESS_CLAMP);
    d->SetTextureStageState(2, D3DTSS_TEXCOORDINDEX, 0);
    d->SetTextureStageState(2, D3DTSS_TEXTURETRANSFORMFLAGS, D3DTTFF_DISABLE);
    d->SetTexture(2, t);
    d->SetTextureStageState(3, D3DTSS_COLOROP, D3DTOP_DISABLE);
    d->SetTextureStageState(3, D3DTSS_ALPHAOP, D3DTOP_DISABLE);
}
// back to the colour stages draw() set up (stage 1 disabled ends the cascade)
void grey_off(IDirect3DDevice8* d) {
#ifndef NUI_FAULT_GREY_STICKY             // self-test: a colour batch after a grey one stays grey
    d->SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
    d->SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
    d->SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);
    d->SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
    d->SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);
    d->SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_DISABLE);
    d->SetTextureStageState(1, D3DTSS_ALPHAOP, D3DTOP_DISABLE);
    d->SetTexture(2, nullptr);
#else
    (void)d;
#endif
}
}  // namespace

void D3D8Backend::draw(std::vector<DrawList const*> const& lists, std::vector<std::uint64_t> const* keys) {
    last_batches = last_dps = last_verts = 0;
    bool any = false;
    for (DrawList const* dl : lists) any = any || !dl->v.empty();
    if (!dev || !any) return;
    if (keys && keys->size() != lists.size()) keys = nullptr;
    DWORD rs[kNRs], tss[kNTss], t1c, t1a, vs, ps = 0;
    IDirect3DBaseTexture8* old_tex = nullptr;
    D3DVIEWPORT8 old_vp {};
    bool const set_vp = rt_w > 0 && rt_h > 0 && SUCCEEDED(dev->GetViewport(&old_vp));
    for (int i = 0; i < kNRs; ++i) dev->GetRenderState(kRs[i], &rs[i]);
    for (int i = 0; i < kNTss; ++i) dev->GetTextureStageState(0, kTss[i], &tss[i]);
    dev->GetTextureStageState(1, D3DTSS_COLOROP, &t1c);
    dev->GetTextureStageState(1, D3DTSS_ALPHAOP, &t1a);
    dev->GetVertexShader(&vs);
    dev->GetPixelShader(&ps);
    dev->GetTexture(0, &old_tex);
    // review REND-6: DrawPrimitiveUP leaves stream 0 unbound; the game's stream goes back afterwards
    IDirect3DVertexBuffer8* old_vb = nullptr;
    UINT old_stride = 0;
    if (FAILED(dev->GetStreamSource(0, &old_vb, &old_stride))) old_vb = nullptr;
    if (set_vp) {
        D3DVIEWPORT8 vp {0, 0, DWORD(rt_w), DWORD(rt_h), 0.0f, 1.0f};
        dev->SetViewport(&vp);
    }

    dev->SetRenderState(D3DRS_ALPHABLENDENABLE, TRUE);
    dev->SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA);
    dev->SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
    dev->SetRenderState(D3DRS_ZENABLE, D3DZB_FALSE);
    dev->SetRenderState(D3DRS_ZWRITEENABLE, FALSE);
    dev->SetRenderState(D3DRS_LIGHTING, FALSE);
    dev->SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE);
    dev->SetRenderState(D3DRS_FOGENABLE, FALSE);
    dev->SetRenderState(D3DRS_ALPHATESTENABLE, FALSE);
    dev->SetRenderState(D3DRS_STENCILENABLE, FALSE);
    dev->SetRenderState(D3DRS_SPECULARENABLE, FALSE);
    dev->SetRenderState(D3DRS_COLORVERTEX, TRUE);
    dev->SetRenderState(D3DRS_FILLMODE, D3DFILL_SOLID);
    dev->SetRenderState(D3DRS_SHADEMODE, D3DSHADE_GOURAUD);
    dev->SetRenderState(D3DRS_COLORWRITEENABLE, 0xF);
    dev->SetRenderState(D3DRS_BLENDOP, D3DBLENDOP_ADD);
    dev->SetRenderState(D3DRS_WRAP0, 0);
    dev->SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_MODULATE);
    dev->SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
    dev->SetTextureStageState(0, D3DTSS_COLORARG2, D3DTA_DIFFUSE);
    dev->SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
    dev->SetTextureStageState(0, D3DTSS_ALPHAARG1, D3DTA_TEXTURE);
    dev->SetTextureStageState(0, D3DTSS_ALPHAARG2, D3DTA_DIFFUSE);
    dev->SetTextureStageState(0, D3DTSS_MIPFILTER, D3DTEXF_NONE);
    dev->SetTextureStageState(0, D3DTSS_ADDRESSU, D3DTADDRESS_CLAMP);
    dev->SetTextureStageState(0, D3DTSS_ADDRESSV, D3DTADDRESS_CLAMP);
    dev->SetTextureStageState(0, D3DTSS_TEXCOORDINDEX, 0);
    dev->SetTextureStageState(0, D3DTSS_TEXTURETRANSFORMFLAGS, D3DTTFF_DISABLE);
    dev->SetTextureStageState(1, D3DTSS_COLOROP, D3DTOP_DISABLE);
    dev->SetTextureStageState(1, D3DTSS_ALPHAOP, D3DTOP_DISABLE);
    dev->SetVertexShader(D3DFVF_XYZRHW | D3DFVF_DIFFUSE | D3DFVF_TEX1);
    dev->SetPixelShader(0);

    // D3D8 samples pixel centres at integer coordinates: shift by half a pixel so texel (u, v)
    // lands exactly on pixel (x, y) and 1:1 art stays crisp.
    static std::vector<Vtx> buf;
    GreySave grey;
    bool grey_now = false;
    last_failed = false;
    try {                        // 1.2.5: an allocation failing below must not skip the restore (review HOST-1)
    for (Xform& x : xcache) x.used = false;
    for (std::size_t li = 0; li < lists.size(); ++li) {
    DrawList const& dl = *lists[li];
    // the list's vertices as drawn: kept from an earlier draw (keys), or made now
    Xform* xf = nullptr;
    bool fresh = true;
    if (keys) {
        std::uint64_t const k = (*keys)[li];
        for (std::size_t j = 0; j < xcache.size() && !xf; ++j) {
#ifndef NUI_FAULT_VC_NO_KEY              // self-test: a cache that matches lists by position, not content
            if (xcache[j].key == k) xf = &xcache[j];
#else
            if (j == li) xf = &xcache[j];
#endif
        }
        if (!xf) {
            xcache.emplace_back();
            xf = &xcache.back();
            xf->key = k + 1;             // not this list yet: made below
        }
        bool stale = xf->v.size() != dl.v.size();
#ifndef NUI_FAULT_VC_NO_KEY
        stale = stale || xf->key != k;
#endif
#ifndef NUI_FAULT_VC_NO_SCALE            // self-test: a cache that keeps vertices across a scale change
        stale = stale || xf->scale != scale;
#endif
#ifndef NUI_FAULT_VC_NO_TEXGEN           // self-test: a cache that keeps UVs across a texture change
        stale = stale || xf->tex_gen != tex_gen;
#endif
        fresh = stale;
        xf->key = k;
        xf->scale = scale;
        xf->tex_gen = tex_gen;
        xf->used = true;
    }
    std::vector<Vtx>& out = xf ? xf->v : buf;
    if (fresh) {
        ++xform_builds;
        out.assign(dl.v.begin(), dl.v.end());
        if (scale == 1.0f) {
            for (auto& p : out) { p.x -= 0.5f; p.y -= 0.5f; }
        } else {
            for (auto& p : out) { p.x = p.x * scale - 0.5f; p.y = p.y * scale - 0.5f; }
        }
        // texels -> normalised, per batch (the list does not know texture sizes). A batch whose
        // texture is missing is skipped below and stays in texels; tex_gen changes when it arrives.
        for (Batch const& b : dl.batches) {
            auto const it = tex.find(b.tex);
            if (it == tex.end() || !it->second.t) continue;
            float const iw = 1.0f / float(it->second.w), ih = 1.0f / float(it->second.h);
            for (uint32_t i = b.first; i < b.first + b.count; ++i) { out[i].u *= iw; out[i].v *= ih; }
        }
    }
    for (Batch const& b : dl.batches) {
        auto const it = tex.find(b.tex);
        if (it == tex.end() || !it->second.t) continue;     // a texture not uploaded (yet): skip its quads
        dev->SetTexture(0, it->second.t);
        dev->SetRenderState(D3DRS_DESTBLEND, b.blend ? D3DBLEND_ONE : D3DBLEND_INVSRCALPHA);
        DWORD const f = (b.filter & kLinear) ? D3DTEXF_LINEAR : D3DTEXF_POINT;
        dev->SetTextureStageState(0, D3DTSS_MINFILTER, f);
        dev->SetTextureStageState(0, D3DTSS_MAGFILTER, f);
        if ((b.filter & kGrey) && grey_caps > 0) {
            grey.save(dev);
            grey_on(dev, it->second.t, f);
            grey_now = true;
        } else if (grey_now) {
            grey_off(dev);
            grey_now = false;
        }
        ++last_batches;
        last_verts += b.count;
        for (uint32_t done = 0; done < b.count;) {
            uint32_t const n = std::min<uint32_t>(b.count - done, 3 * 20000);
            dev->DrawPrimitiveUP(D3DPT_TRIANGLELIST, n / 3, &out[b.first + done], sizeof(Vtx));
            ++last_dps;
            done += n;
        }
    }
    }
    // lists not drawn this time are forgotten (a layer removed, or rebuilt under a new key)
    if (keys) {
        std::size_t w = 0;
        for (std::size_t j = 0; j < xcache.size(); ++j)
            if (xcache[j].used) {
                if (w != j) xcache[w] = std::move(xcache[j]);
                ++w;
            }
        xcache.resize(w);
    }
    } catch (...) {
        last_failed = true;
        xcache.clear();          // a list may be half made: every list is made again next time
        std::vector<Vtx>().swap(buf);
    }

    // grey first: its stage 1 copy was taken mid-frame (COLOROP / ALPHAOP already ours), so the
    // colour restore below must come after it and put the game's stage 1 ops back
    grey.restore(dev);
    for (int i = 0; i < kNRs; ++i) dev->SetRenderState(kRs[i], rs[i]);
    for (int i = 0; i < kNTss; ++i) dev->SetTextureStageState(0, kTss[i], tss[i]);
    dev->SetTextureStageState(1, D3DTSS_COLOROP, t1c);
    dev->SetTextureStageState(1, D3DTSS_ALPHAOP, t1a);
    dev->SetVertexShader(vs);
    dev->SetPixelShader(ps);
    dev->SetTexture(0, old_tex);
#ifndef NUI_FAULT_NO_STREAM_RESTORE       // self-test: stream 0 left unbound (before 1.2.6)
    dev->SetStreamSource(0, old_vb, old_stride);
#endif
    if (set_vp) dev->SetViewport(&old_vp);
    if (old_tex) old_tex->Release();
    if (old_vb) old_vb->Release();
}

void D3D8Backend::release() {
    for (auto& kv : tex) give_back(pending, kv.second.ref);
    tex.clear();
    ++tex_gen;
    std::vector<Xform>().swap(xcache);
}

}  // namespace nui
