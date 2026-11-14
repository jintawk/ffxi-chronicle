-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Legacies_Lost_and_Found). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Legacies Lost and Found',
    title = 'Legacies Lost and Found',
    source = 'https://www.bg-wiki.com/ffxi/Legacies_Lost_and_Found',
    images = {},
    meta_order = {'Name', 'Required Fame', 'Level Restriction', 'Starting NPC', 'Pack', 'Title', 'Repeatable', 'Description', 'Previous Quest', 'Next Quest', 'Rewards'},
    meta = {
        ['Name'] = 'Legacies Lost and Found',
        ['Required Fame'] = '{p:Adoulin|Category:Adoulin Quests} Fame Level: __Unknown__',
        ['Level Restriction'] = 'None',
        ['Starting NPC'] = '{n:Octavien}, {z:Eastern Adoulin} (I-8)',
        ['Pack'] = 'None',
        ['Title'] = 'None',
        ['Repeatable'] = '__No__',
        ['Description'] = 'Certain contraptions that create weapons imbued with the power of runes are supposedly scattered throughout the Middle Lands. Help the Federation of Windurst\'s Ohruru by investigating the issue.',
        ['Previous Quest'] = '{q:Forging New Bonds|Forging New Bonds|Forging New Bonds}',
        ['Next Quest'] = '{q:Destiny\'s Device|Destiny\'s Device|Destiny\'s Device}',
        ['Rewards'] = '{@i:Runeist Trousers|28207} {i:Runeist Trousers|Runeist Trousers|28207}{br} 6,000 ~ 22,000 {p:Bayld} (2,000 per Stone key item obtained)'
    },
    body = [=[
=2 Walkthrough
* **{z:Eastern Adoulin} **(I-8)
** Speak to {n:Octavien} while your main job is set to {p:Rune Fencer} for the key item {k:Letter from Octavien} (you must zone after completing the previous quest for this quest to be triggered).
* **{z:Port Windurst} **(E-7)
** Speak to {n:Ohruru} inside the Orastery in the back, use {p:Ignis}, then speak to {n:Ohruru} again 2 times for a cutscene.
* Travel to **at least three** of the following __eight__ Strange Apparatuses to receive key items.{br}**Note**: Invisible walls may or may not exist, and the apparatuses are located behind them. Please be aware of your surroundings as this is some incredibly complicated stuff.
** __{z:Dangruf Wadi} __(E-11)
*** Use {p:Unda} 3 times, then examine the **Hazy Rune** to receive a {k:Stone of Unda}.
** __{z:Gusgen Mines} Map 2 __(J-5)
*** Use {p:Flabra} 3 times, then examine the **Hazy Rune** to receive a {k:Stone of Flabra}.
** __{z:Crawlers' Nest} Map 3 __(K-8)
*** Use {p:Sulpor} 3 times, then examine the **Hazy Rune** to receive a {k:Stone of Sulpor}.
** __{z:Ordelle's Caves} __(E-12)
*** Use {p:Gelus} 3 times, then examine the **Hazy Rune** to receive a {k:Stone of Gelus}.
** __{z:The Eldieme Necropolis} Map 2 __(K-13) (make sure to fall in the correct hole; it's NOT the center one. The Correct hole is the westernmost square in the room marked D on Map 1 (G-9))
*** Use {p:Ignis} 3 times, then examine the **Hazy Rune** to receive a {k:Stone of Ignis}.
** __{z:Outer Horutoto Ruins} Map 5 __(E-6) (enter from the northern tower in {z:West Sarutabaruta}. The Voidwatch Warp for {z:Outer Horutoto Ruins} will take you to the right tower.)
*** Use {p:Tellus} 3 times, then examine the **Hazy Rune** to receive a {k:Stone of Tellus}.
** __{z:Garlaige Citadel} Map 3 __(K-8) (behind Banishing Gate #2)
*** Use {p:Tenebrae} 3 times, then examine the **Hazy Rune** to receive a {k:Stone of Tenebrae}.
** __{z:Maze of Shakhrami} Map 2 __(L-10) (make sure to enter from {z:Buburimu Peninsula}, not {z:Tahrongi Canyon}, Unity Warp drops you off right at the entrance.)
*** Use {p:Lux} 3 times, then examine the **Hazy Rune** to receive a {k:Stone of Lux}.
* __Optional:__ The remaining Strange Apparatuses are not affiliated with a single element, but you will obtain a {k:Stone of unknown runic origins} upon using three runes which differ at each location. **NOTE: You must obtain three of the eight above for the quest to continue.**
** __{z:Fei'Yin} Map 1 __(G-6) (must travel down through the basement map 2 and back up in the northwest corner near the Shadow NMs)
*** Use {p:Ignis}, {p:Tellus}, and {p:Tenebrae}, (In that order) then examine the **Hazy Rune**.
** __{z:Ranguemont Pass} __(E-4)
*** Use {p:Flabra}, {p:Ignis}, and {p:Lux}, (In that order) then examine the **Hazy Rune**.
** __{z:King Ranperre's Tomb} Map 2 __(E-7)
*** Use {p:Gelus}, {p:Sulpor}, and {p:Unda}, (In that order) then examine the **Hazy Rune**.
* **{z:Port Windurst} **(E-7)
** Speak to {n:Ohruru} and answer questions
*** Her questions are about {p:Rune Fencer} abilities
*** She either asks questions about elemental resistance, ward effects, or the number of the question you're answering (The answer list varies based on the type of question)
*** Below are her possible questions, with the answers. Use the tables to find the question, and replace the variable in <Brackets> with the random element/ailment she asks to find the answer.

|^~c2~__Your opponentaru is a virtuoso with__ <Spell Name>
|^<Spell Name>|Answer
|{@g:Element: Fire|Fire}|{p:Unda}
|{@g:Element: Earth|Earth}|{p:Flabra}
|{@g:Element: Water|Water}|{p:Sulpor}
|{@g:Element: Wind|Wind}|{p:Gelus}
|{@g:Element: Ice|Ice}|{p:Ignis}
|{@g:Element: Thunder|Thunder}|{p:Tellus}
|{@g:Element: Light|Light}|{p:Tenebrae}
|{@g:Element: Dark|Darkness}|{p:Lux}

|^~c2~__Your opponent is a sadistaru of the highest degree{br} and roves inflicting__ <Status Ailment>
|^<Status Ailment>|Answer
|{s:Paralyze}, {s:Stun}, {s:Frost}|{p:Ignis}
|{p:Silence}, {s:Gravity}, {s:Choke}|{p:Gelus}
|{s:Slow}, {p:Petrify}, {s:Rasp}|{p:Flabra}
|{s:Stun}, {s:Shock}|{p:Tellus}
|{s:Poison}, {s:Drown}|{p:Sulpor}
|{s:Addle}, {p:Amnesia}, {p:Plague}, {p:Disease}, {s:Burn}|{p:Unda}
|{p:Bane}, {s:Blind}, {s:Bio}, {s:Sleep}, {p:Drain}|{p:Lux}
|{s:Dia}, {s:Sleep}, {p:Charm}, {s:Holy}|{p:Tenebrae}

|^~c2~__Your opponent cannot stomach__ <Element> __damage__
|^<Element>|Answer
|{@g:Element: Fire|Fire}|{p:Ignis}
|{@g:Element: Earth|Earth}|{p:Tellus}
|{@g:Element: Water|Water}|{p:Unda}
|{@g:Element: Wind|Wind}|{p:Flabra}
|{@g:Element: Ice|Ice}|{p:Gelus}
|{@g:Element: Thunder|Thunder}|{p:Sulpor}
|{@g:Element: Light|Light}|{p:Lux}
|{@g:Element: Dark|Darkness}|{p:Tenebrae}

|^~c2~__Which ward should you use when you want to__ <Effect Description>
|^<Effect Description>|Answer
|Reduce elemental damage|{p:Vallation}
|Reduce elemental damage for party members|{p:Valiance}
|Absorb elemental damage|{p:Liement}
|Enhance resistance|{p:Pflug}

|^__Do you happen to know what number question this is?__
|Keep track yourself

\**{c=red:Note:}** She can ask the same question multiple times.
* After this cutscene, the player receives the {@k} {k:"Secrets of Runic Enhancement"}. Finish the quest with the following few steps.
* **{z:Eastern Adoulin} **(I-8)
** Speak to {n:Octavien}.
* **{z:Western Adoulin} **(I-4)
** Examine the **Inconspicuous Barrel** at (I-4) near the Adoulin Waterfront waypoint. You will hand over the {k:"Secrets of Runic Enhancement"}.
** Wait until the next game day and examine the **Inconspicuous Barrel** once more to complete the quest.

]=],
}
