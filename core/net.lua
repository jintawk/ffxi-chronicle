--[[
    net.lua - minimal non-blocking HTTPS GET for Windower addons (from AutoPricer's net.lua; here
    with a browser User-Agent, which BG-wiki requires, and binary bodies).

    Uses the luasocket + luasec libraries bundled with Windower
    (addons/libs/socket.lua + ssl.lua, plugins/libs/socket + ssl.dll).

    Every call MUST run inside a Windower coroutine: the request yields
    with coroutine.sleep while waiting on the socket, so the game render
    thread never blocks on network I/O.

    net.get(host, path, headers, timeout) -> resp | nil, err[, 'dns' when the host did not resolve]
      A failed lookup is remembered for net.DNS_FAIL_TTL seconds; a reply shorter than its Content-Length is an error.
      The server's certificate must chain to a root in certs/cacert.pem (Mozilla's bundle, from curl.se) and name the host;
      without the bundle nothing is downloaded.
      resp = { status = 200, headers_raw = '...', body = '...',
               location = '/redirect/target' (when the server sent one) }

    Copyright (c) 2026, jintawk
    BSD 3-clause license.
]]

local socket = require('socket')
local ok_ssl, ssl = pcall(require, 'ssl')

local net = {}

net.available = ok_ssl and true or false
net.ua = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0 Safari/537.36'
net.trace = nil     -- optional function(text), called at each request stage

-- Mozilla's root certificates (https://curl.se/docs/caextract.html), shipped with the addon
net.cafile = (windower and windower.addon_path or '') .. 'certs/cacert.pem'

local function trace(fmt, ...)
    if net.trace then
        net.trace(string.format(fmt, ...))
    end
end

local dns_cache = {}
net.DNS_FAIL_TTL = 60   -- seconds a failed lookup is remembered (review CORE-4)
net.clock = os.time     -- tests replace it

-- socket.dns.toip blocks the Lua thread (and so the game) for the resolver's whole timeout when DNS is down. A failure is
-- remembered for DNS_FAIL_TTL seconds, so a page of pictures pays it once, not once a picture (review CORE-4).
local function resolve(host)
    local hit = dns_cache[host]
    local now = net.clock()
    if hit and hit.ip and now - hit.t < 3600 then
        return hit.ip
    end
    if hit and not hit.ip and now - hit.t < net.DNS_FAIL_TTL then
        return nil
    end
    -- blocking, but sub-millisecond once the OS resolver has it cached
    local ip = socket.dns.toip(host)
    dns_cache[host] = { ip = ip, t = now }
    return ip
end

-- does a certificate name match the host? '*' stands for exactly one leftmost label (RFC 6125)
local function name_matches(name, host)
    name, host = name:lower(), host:lower()
    if name == host then return true end
    local rest = name:match('^%*(%..+%..+)$')
    if not rest then return false end
    local hrest = host:match('^[^.]+(%..+)$')
    return hrest == rest
end
net.name_matches = name_matches

-- the names the server's certificate is for: its subjectAltName DNS entries, or its common name when it has none
local function cert_names(cert)
    local names = {}
    local ok, ext = pcall(cert.extensions, cert)
    local san = ok and type(ext) == 'table' and ext['2.5.29.17']
    if type(san) == 'table' and type(san.dNSName) == 'table' then
        for _, n in ipairs(san.dNSName) do names[#names + 1] = n end
    end
    if #names == 0 then
        local okc, subject = pcall(cert.subject, cert)
        for _, e in ipairs(okc and subject or {}) do
            if e.name == 'commonName' or e.oid == '2.5.4.3' then names[#names + 1] = e.value end
        end
    end
    return names
end

local function host_checked(client, host)
    local okv, verified, why = pcall(client.getpeerverification, client)
    if not okv or not verified then
        local reasons = {}
        for _, r in pairs(type(why) == 'table' and why or {}) do
            reasons[#reasons + 1] = type(r) == 'table' and table.concat(r, ', ') or tostring(r)
        end
        return false, 'certificate not trusted' .. (#reasons > 0 and (': ' .. table.concat(reasons, '; ')) or '')
    end
    local okp, cert = pcall(client.getpeercertificate, client)
    if not okp or not cert then return false, 'no certificate' end
    local names = cert_names(cert)
    for _, n in ipairs(names) do
        if name_matches(n, host) then return true end
    end
    return false, 'certificate is for ' .. (#names > 0 and table.concat(names, ', ') or 'no name') .. ', not ' .. host
end

local cafile_ok
local function have_cafile()
    if cafile_ok == nil then
        local f = io.open(net.cafile, 'rb')
        cafile_ok = f ~= nil
        if f then f:close() end
    end
    return cafile_ok
end

function net.get(host, path, headers, timeout)
    if not ok_ssl then
        return nil, 'luasec unavailable: ' .. tostring(ssl)
    end
    if not have_cafile() then
        return nil, 'no CA bundle at ' .. net.cafile
    end
    local deadline = os.time() + (timeout or 15)

    local ip = resolve(host)
    if not ip then
        return nil, 'dns lookup failed for ' .. host, 'dns'
    end
    trace('dns %s -> %s', host, ip)

    local tcp = socket.tcp()
    tcp:settimeout(0)
    tcp:connect(ip, 443)                -- non-blocking: 'timeout' immediately
    while true do
        local _, writable = socket.select(nil, { tcp }, 0)
        if writable and writable[1] then
            break
        end
        if os.time() > deadline then
            tcp:close()
            return nil, 'connect timeout'
        end
        coroutine.sleep(0.05)
    end
    trace('tcp connected')

    local client, werr = ssl.wrap(tcp, {
        mode = 'client',
        protocol = 'any',
        options = { 'all', 'no_sslv2', 'no_sslv3' },
        verify = { 'peer', 'fail_if_no_peer_cert' },
        cafile = net.cafile,
    })
    if not client then
        tcp:close()
        return nil, 'ssl wrap: ' .. tostring(werr)
    end
    if client.sni then
        pcall(client.sni, client, host)
    end
    client:settimeout(0)

    while true do
        local done, herr = client:dohandshake()
        if done then
            break
        end
        if herr ~= 'wantread' and herr ~= 'wantwrite' and herr ~= 'timeout' then
            client:close()
            return nil, 'tls handshake: ' .. tostring(herr)
        end
        if os.time() > deadline then
            client:close()
            return nil, 'handshake timeout'
        end
        coroutine.sleep(0.03)
    end
    local trusted, terr = host_checked(client, host)
    if not trusted then
        client:close()
        return nil, 'tls: ' .. terr
    end
    trace('tls handshake ok, certificate checked')

    -- HTTP/1.0 + Connection: close sidesteps chunked transfer encoding:
    -- the body is simply everything until the server closes the socket.
    local req = {
        'GET ' .. path .. ' HTTP/1.0',
        'Host: ' .. host,
        'User-Agent: ' .. net.ua,
        'Accept: */*',
        'Connection: close',
    }
    for k, v in pairs(headers or {}) do
        req[#req + 1] = k .. ': ' .. v
    end
    local blob = table.concat(req, '\r\n') .. '\r\n\r\n'

    local i = 1
    while i <= #blob do
        local sent, serr, last = client:send(blob, i)
        if sent then
            i = sent + 1
        elseif serr == 'wantread' or serr == 'wantwrite' or serr == 'timeout' then
            i = (last or i - 1) + 1
            if os.time() > deadline then
                client:close()
                return nil, 'send timeout'
            end
            coroutine.sleep(0.03)
        else
            client:close()
            return nil, 'send: ' .. tostring(serr)
        end
    end

    trace('request sent: GET %s', path)

    local chunks, total = {}, 0
    while true do
        local data, rerr, partial = client:receive(16384)
        local got = data or partial
        if got and #got > 0 then
            chunks[#chunks + 1] = got
            total = total + #got
        end
        if rerr == 'closed' then
            break
        end
        if data == nil and rerr ~= 'wantread' and rerr ~= 'wantwrite' and rerr ~= 'timeout' then
            client:close()
            return nil, 'receive: ' .. tostring(rerr)
        end
        if total > 8 * 1024 * 1024 then
            client:close()
            return nil, 'response larger than 8 MB'
        end
        if os.time() > deadline then
            client:close()
            return nil, 'receive timeout'
        end
        if data == nil then
            coroutine.sleep(0.03)
        end
    end
    client:close()

    local raw = table.concat(chunks)
    local status = tonumber(raw:match('^HTTP/%d%.%d (%d%d%d)'))
    if not status then
        return nil, 'malformed response'
    end
    trace('response: status %d, %d bytes', status, #raw)
    local head, body = raw:match('^(.-)\r\n\r\n(.*)$')
    -- luasec reports a connection dropped without close_notify as 'closed', the same as a whole reply: a body shorter than
    -- the Content-Length the server sent is a cut download, not a picture (review CORE-3)
    local want = head and tonumber(head:match('[\r\n][Cc]ontent%-[Ll]ength:%s*(%d+)'))
    if want and #(body or '') < want then
        return nil, ('short body: %d of %d bytes'):format(#(body or ''), want)
    end
    return {
        status = status,
        headers_raw = head or '',
        body = body or '',
        location = head and head:match('[\r\n][Ll]ocation:%s*(%S+)'),
    }
end

return net
