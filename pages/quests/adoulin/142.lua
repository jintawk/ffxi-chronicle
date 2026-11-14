-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Treasures_of_the_Earth). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Treasures of the Earth',
    title = 'Treasures of the Earth',
    source = 'https://www.bg-wiki.com/ffxi/Treasures_of_the_Earth',
    images = {},
    meta_order = {'Name', 'Required Fame', 'Level Restriction', 'Starting NPC', 'Pack', 'Title', 'Repeatable', 'Description', 'Previous Quest', 'Next Quest', 'Requirements', 'Rewards'},
    meta = {
        ['Name'] = 'Treasures of the Earth',
        ['Required Fame'] = '{p:Adoulin|Category:Adoulin Quests} Fame Level: __Unknown__',
        ['Level Restriction'] = 'Level 99 Geomancer',
        ['Starting NPC'] = '{p:Sylvie}, {z:Western Adoulin} (I-5)',
        ['Pack'] = 'Seekers of Adoulin',
        ['Title'] = 'Lifecycler (Level 135 fight only)',
        ['Repeatable'] = '__Yes__',
        ['Description'] = 'Sylvie still has lingering doubts about her father. Meet up with her in Morimar Basalt Fields for moral support.',
        ['Previous Quest'] = '{q:Geomancer Relic Armor|Geomancer Relic Armor|Geomancer Relic Armor}',
        ['Next Quest'] = 'None',
        ['Requirements'] = '{@k} {k:"Climbing"}{br} {@k} {k:Holla crystal of gales}{br} {@k} {k:Dem crystal of dunes}{br} {@k} {k:Mea crystal of flames}{br} {@k} {k:Pale azure cloth}{br} {@k} {k:Treatise on azimuth clothcraft}',
        ['Rewards'] = '{@i:Azimuth Coat|26938} {i:Azimuth Coat|Azimuth Coat|26938}{br} 15,000 {p:Experience Points}{br} 10,000 {p:Bayld} (109 Fight) **or{br}** 3 Synthesis Materials (125 Fight) **or{br}** 10 Synthesis Mats and a {@i:Codex of Etchings|6367} {i:Codex of Etchings|Codex of Etchings|6367} (135 Fight)'
    },
    body = [=[
=2 Walkthrough
* Speak to {p:Sylvie} at {z:Western Adoulin} Waterfront (I-5) Waypoint #9 as {p:Geomancer} to begin the quest.
** Turning in the Key Item {@k}{k:Crystallized lifestream essence} to {n:Wescolina} allows for the activation of this quest.
*** Acquiring all of the relic armor pieces is not required.
*** You must complete all other quests in order to flag this quest, trying to skip using {i:Kupon A-AF +3} to flag relic and this quest will not work.
* Go to {z:Morimar Basalt Fields} (J-6) northeast of bivouac #2 and check the **Ergon Locus ???** for a cutscene.
* Go to (G/H-7) and ascend the {k:Scalable Area} near the NW side of the Hot Spring. Go directly east to (H-6/7) and check the ??? (at the base of the cliff overhang, beneath the ergon locus) for a cutscene.
** If you don't have {@k}{k:"Climbing"} it is possible to die, {s:Tractor}, and {p:Raise} twice down from bivouac #5.
* Return to {p:Sylvie}. She will offer you the choice of three challenges.
** Choosing {@k}{k:Holla crystal of gales} corresponds to a level 109 solo fight in {z:La Theine Plateau}.
** Choosing {@k}{k:Dem crystal of dunes} corresponds to a level 125 solo fight in {z:Konschtat Highlands}.
** Choosing the blank option will give you the {@k}{k:Mea crystal of flames}. This corresponds to a level 135 solo Geomancer fight in {z:Tahrongi Canyon}.

=3 La Theine Plateau Option
* Go to the Crag of Holla (K-8) in {z:La Theine Plateau} and check the {p:Ergon Locus} ??? underneath the Telepoint. You will lose your {@k}{k:Holla crystal of gales}.
* This is a solo fight. You do not need to have Geomancer set on main job to participate. Trusts are allowed for the fight, but Fellows are not. Buffs and TP will be reset. Time limit on this fight appears to be 5-10 minutes.
* Your enemy for this fight is Otherworldly Rimester, a Ghost.
** BRD job, casts {s:Victory March}, Magic Finale, Massacre Elegy, {s:Foe Requiem VII}, Horde Lullaby II.
** Uses Dark Sphere, Terror Touch, Fear Touch, Ectosmash.
** Appears particularly weak to {p:Magic Burst} damage.
* Upon defeating Otherworldly Rimester you will earn 10000 bayld and {@k}{k:Pale azure cloth}.

=3 Konschtat Highlands Option
* Go to the Crag of Dem (I-6) in {z:Konschtat Highlands} and check the {p:Ergon Locus} ??? underneath the Telepoint. You will lose your {@k}{k:Dem crystal of dunes}.
** Trusts are allowed in this fight and you do not need to have Geomancer set on main job to participate, but Fellows and other players are not. The time limit for this fight is 3 minutes.
** Buffs and TP will be reset.
** The fight is against Otherworldly Rimester, a Ghost.
* Your reward is a random assortment of 3 of the following items: {i:Fiendish Skin|Fiendish Skin|2189}, {i:Siren's Hair|Siren's Hair|1313}, {i:Arachne Thread|Arachne Thread|1294}, {i:Khroma Ore|Khroma Ore|685} and {i:Star Sapphire|Star Sapphire|2359}.

=3 Tahrongi Canyon Option
* Go to the Crag of Mea (I-6) in {z:Tahrongi Canyon} and check the {p:Ergon Locus} ??? underneath the Telepoint. You will lose your {@k}{k:Mea crystal of flames}.
* This is a solo fight for Geomancers only. Neither Trusts nor Adventuring Fellows are allowed. Buffs and TP will be reset. The time limit for this fight is 3 minutes.
* Your enemy for this fight is the Content Level 135 version of Otherworldly Rimester, a Ghost.
* The Rimester has access to numerous Bard songs, including Horde Lullaby II, {s:Dragonfoe Mambo}, {s:Magic Finale}, Massacre Elegy, {s:Valor Minuet V}, {s:Foe Requiem VII}, {s:Victory March}, and perhaps others.
* Rimester's TP moves are Dark Sphere, Fear Touch, Ectosmash and Terror Touch. Dark Sphere is the most dangerous and the only one that shadows will not absorb.
* The Rimester has a shifting elemental vulnerability, but the pattern behind the shifts is currently unknown. Three to four tier 3+ nukes hitting the weakness should be enough damage. This can be a heavily luck-based fight for less geared players.
** When hitting the weakness, immediately following up with another nuke of the same element will often hit the weakness again before it shifts.
** A well geared GEO can hit the weakness for 8,000+ damage with a Tier 3 nuke, which will kill very quickly.
* Your reward is 1 {i:Codex of Etchings|Codex of Etchings|6367} and a random assortment of 10 of the following items: {i:Fiendish Skin|Fiendish Skin|2189}, {i:Siren's Hair|Siren's Hair|1313}, {i:Arachne Thread|Arachne Thread|1294}, {i:Khroma Ore|Khroma Ore|685} and {i:Star Sapphire|Star Sapphire|2359}.
* If you fail, you must return to {p:Sylvie} for a new {@k}{k:Mea crystal of flames}. You can retry as often as you want until you win.

=3 Finishing Up
* Return to {p:Sylvie}. You will obtain {@k}{k:Treatise on azimuth clothcraft}.
* Talk to {n:Wescolina} (H-7).
* Talk to {n:Helina} (H-9), located inside the **Weaver's Guild** in {z:Selbina}.
* Wait until the next **game day**, then talk to {n:Helina} for your reward: 15000 XP and {i:Azimuth Coat|Azimuth Coat|26938}.
* To repeat the quest fight after successful completion, speak to {p:Sylvie} to receive a new {@k} Key Item once per Conquest Tally.

=2 For the Rest of the Set
* Speak to {n:Helina} in {z:Selbina} to commission additional armor pieces.
* You have the option to either bring certain materials to her, or an amount of {i:H-P Bayld|H-P Bayld|8798}.
** If you have completed Part 1 of {q:Saved by the Bell|Saved by the Bell|Saved by the Bell} (Ergon Weapon Quest), {n:Helina} will only ask for either a single {i:Dragua's Scale|Dragua's Scale|3288} or half as many {i:H-P Bayld|H-P Bayld|8798} (rounded down).
* After turning in the items to her for a piece, you are given a temporary key item order slip. Return the following game day to claim your armor and start your next piece.

|^~c4~**Geomancer Empyrean Armor**
|^Armor|Materials|With Discount|Key Item
|{@i:Azimuth Hood|26780}{br}{i:Azimuth Hood|Azimuth Hood|26780}|{@i:Dragua's Scale|3288} {i:Dragua's Scale|Dragua's Scale|3288}{br} {@i:Siren's Hair|1313} {i:Siren's Hair|Siren's Hair|1313}{br} {@i:Khroma Ore|685} {i:Khroma Ore|Khroma Ore|685}{br}**-Or Trade-{br}** 20 {@i:H-P Bayld|8798} {i:H-P Bayld|H-P Bayld|8798}|{@i:Dragua's Scale|3288} {i:Dragua's Scale|Dragua's Scale|3288}{br} **-Or Trade-** {br} 10 {@i:H-P Bayld|8798} {i:H-P Bayld|H-P Bayld|8798}|{@k} {k:Order slip: azimuth hood}
|{@i:Azimuth Gloves|27092}{br}{i:Azimuth Gloves|Azimuth Gloves|27092}|{@i:Dragua's Scale|3288} {i:Dragua's Scale|Dragua's Scale|3288}{br} {@i:Siren's Hair|1313} {i:Siren's Hair|Siren's Hair|1313}{br} {@i:Fiendish Skin|2189} {i:Fiendish Skin|Fiendish Skin|2189}{br}**-Or Trade-{br}** 15 {@i:H-P Bayld|8798} {i:H-P Bayld|H-P Bayld|8798}|{@i:Dragua's Scale|3288} {i:Dragua's Scale|Dragua's Scale|3288}{br} **-Or Trade-** {br} 7 {@i:H-P Bayld|8798} {i:H-P Bayld|H-P Bayld|8798}|{@k} {k:Order slip: azimuth gloves}
|{@i:Azimuth Tights|27277}{br}{i:Azimuth Tights|Azimuth Tights|27277}|{@i:Dragua's Scale|3288} {i:Dragua's Scale|Dragua's Scale|3288}{br} {@i:Siren's Hair|1313} {i:Siren's Hair|Siren's Hair|1313}{br} {@i:Arachne Thread|1294} {i:Arachne Thread|Arachne Thread|1294}{br}**-Or Trade-{br}** 10 {@i:H-P Bayld|8798} {i:H-P Bayld|H-P Bayld|8798}|{@i:Dragua's Scale|3288} {i:Dragua's Scale|Dragua's Scale|3288}{br} **-Or Trade-** {br} 5 {@i:H-P Bayld|8798} {i:H-P Bayld|H-P Bayld|8798}|{@k} {k:Order slip: azimuth tights}
|{@i:Azimuth Gaiters|27451}{br}{i:Azimuth Gaiters|Azimuth Gaiters|27451}|{@i:Dragua's Scale|3288} {i:Dragua's Scale|Dragua's Scale|3288}{br} {@i:Fiendish Skin|2189} {i:Fiendish Skin|Fiendish Skin|2189}{br} {@i:Arachne Thread|1294} {i:Arachne Thread|Arachne Thread|1294}{br}**-Or Trade-{br}** 25 {@i:H-P Bayld|8798} {i:H-P Bayld|H-P Bayld|8798}|{@i:Dragua's Scale|3288} {i:Dragua's Scale|Dragua's Scale|3288}{br} **-Or Trade-** {br} 12 {@i:H-P Bayld|8798} {i:H-P Bayld|H-P Bayld|8798}|{@k} {k:Order slip: azimuth gaiters}

]=],
}
