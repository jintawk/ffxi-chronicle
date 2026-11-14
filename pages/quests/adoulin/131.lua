-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Saved_by_the_Bell). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Saved by the Bell',
    title = 'Saved by the Bell',
    source = 'https://www.bg-wiki.com/ffxi/Saved_by_the_Bell',
    images = {},
    meta_order = {'Name', 'Required Fame', 'Level Restriction', 'Starting NPC', 'Pack', 'Title', 'Repeatable', 'Description', 'Previous Quest', 'Next Quest', 'Requirements', 'Rewards'},
    meta = {
        ['Name'] = 'Saved by the Bell',
        ['Required Fame'] = '{p:Adoulin|Category:Adoulin Quests} Fame Level: __Unknown__',
        ['Level Restriction'] = 'None',
        ['Starting NPC'] = '{n:Nhili Uvolep}, {z:Eastern Adoulin} (I-7)',
        ['Pack'] = 'Seekers of Adoulin',
        ['Title'] = 'None',
        ['Repeatable'] = '__No__',
        ['Description'] = 'A fable recited by Nhili tells of a fearsome struggle that took place in the wilds many centuries past. Are the rumors true, and what do they have to do with the bell you found?',
        ['Previous Quest'] = '{q:The Communion|The Communion|The Communion}',
        ['Next Quest'] = 'None',
        ['Requirements'] = 'All {p:Coalitions|Coalition} Legend Rank or higher{br} {@i:Ghastly Stone|3954} {i:Ghastly Stone|Ghastly Stone|3954} x200{br} {@i:Verdigris St.|4033} {i:Verdigris Stone|Verdigris Stone|4033} x200{br} {@i:Wailing Stone|3951} {i:Wailing Stone|Wailing Stone|3951} x200{br} {@i:H-P Bayld|8798} {i:H-P Bayld|H-P Bayld|8798} x13,099{br} {@i:P. Yggrete Crystal|8797} {i:P. Yggrete Crystal|P. Yggrete Crystal|8797} x1{br} {@i:Gabbrath Meat|6068} {i:Gabbrath Meat|Gabbrath Meat|6068} x1{br} {@i:Rockfin Tooth|3979} {i:Rockfin Tooth|Rockfin Tooth|3979} x1{br} {@i:Bztavian Stinger|3980} {i:Bztavian Stinger|Bztavian Stinger|3980} x1{br} {@i:Yggdreant Bole|4014} {i:Yggdreant Bole|Yggdreant Bole|4014} x1{br} {@i:Waktza Crest|4013} {i:Waktza Crest|Waktza Crest|4013} x1{br} {@i:Cehuetzi Pelt|8754} {i:Cehuetzi Pelt|Cehuetzi Pelt|8754} x1',
        ['Rewards'] = '{@i:File:Idris (Level 119) icon.png|21070}{i:Idris|Idris (Level 119)|21070}'
    },
    body = [=[
=2 Walkthrough
This quest has several parts and is rather involved.
* Speak with {n:Nhili Uvolep} and she will ask you to go to {z:Dho Gates} to investigate "forces of darkness".
** **Note**: You can start this quest as any job, even though Idris can only be equipped by Geomancer.
** **Note**: If you are working towards an Epeolatry, you will need to complete or quit that weapon to begin working on {i:Idris|Idris (Level 119)|21070}. You will lose all materials deposited if you quit, but you will keep your {k:Broken rapier hilt} key item, and can restart it immediately.
*** **__However, after completing any part after completing part 1, before trading your {p:Nodal Wand} to {n:Runje Desaali} to begin the next part, any part of {q:Quiescence|Quiescence|Quiescence} may be started and finished without having to restart either quest from the beginning.**__
* Travel to (F-12) in {z:Dho Gates} (Map 1) and examine the **Inlet of Whispers** to receive a {k:Rusted handbell} key item.
** The Inlet of Whispers is surrounded by Apex mobs that agro sound.
** Waypoint #4 {z:Foret de Hennetiel} or HP is near the entrance to {z:Dho Gates}.
* Return to {n:Nhili Uvolep}.
* Speak with {n:Runje Desaali} (J-11) in {z:Eastern Adoulin}.

=4 Part 1
* Trade 100 High-purity Bayld to {n:Geosuke} the cute little {m:Leafkin} in {z:Eastern Adoulin} at (J-10).
** This can be done cumulatively.
* You will receive the {k:Emblazoned handbell} key item.
* Speak with {n:Nhili Uvolep} again.
** You may need to talk twice or until she talks about the bell.
* With your main job set to GEO, examine the "**Water of Whispers**" in {z:Dho Gates} at (H-7) to enter a battlefield.
** {z:Foret de Hennetiel} Home Point is close to the {z:Dho Gates} entrance.
** This is a one on one against the {m:Bygone Geomancer}. Subjob and trusts are not available. There is a 15 minute time limit. No key item is consumed if you lose. The BCNM may be entered again immediately.
** The only way to damage the Bygone Geomancer is to destroy the summoned Luopans. Each Luopan destroyed lowers the Geomancer's health by 4%.
** After destroying 25 Luopans, the Geomancer will be at 1 HP, and you can finish the fight with either a spell or physical attack.
*** This means you have to destroy 25 Luopans in 15 minutes.
** Highly recommend MP and HP restoration items and refresh drinks along with use of all abilities available to GEO. She will start casting higher tier spells (single target III-IV and -ra II) as her health gets lower.
*** You can buy {i:Coalition Ether|Coalition Ether|5987} and {i:Coalition Potion|Coalition Potion|5986} for 2500 bayld each from {n:Ujlei Zelekko} in the {p:Peacekeepers' Coalition}, which restore 150 MP and 200 HP instantly with no delay between uses like other medicines. Very useful for undergeared players or if you just feel like spamming -ra.
**** Macro '/item "Coalition Ether" <me>'.
** Use your knowledge of the {p:elemental wheel|Elemental wheel} to quickly kill Luopans. They resist all elements except the element strong against their element and darkness.
*** For example, a {p:Geo-Slow} Luopan will take severely reduced magic damage from all elements except wind and darkness, as Indi/Geo-Slow is earth aligned and earth is weak to wind.
** As most Luopans do not take diminished magic damage from darkness element, using a staff and {p:Cataclysm} whenever possible can one shot all of the luopans at once (except Geo-Languor.) For Geo-Languor, cast {s:Aero}, {p:Fire}, or {s:Thunder}.
** Another strategy is to set up a {p:Geo-Regen} bubble and use {p:Indi-Acumen} to mitigate the damage from the Geomancer and maximize damage to Luopans. {p:Geo-Regen} is enough to fully mitigate/regain damage dealt by the {m:Bygone Geomancer}'s infrequent spells.
** Spamming tier I spells of the appropriate element and avoiding -ra spells unless they will deal full damage to 2+ Luopans will allow you to finish the BCNM in time and not require any MP restoration items.
* After the fight, return to {n:Nhili Uvolep} to receive your base weapon, {p:Nodal Wand I}.
* The quest is technically "completed" at this point, as the quest is moved to the completed section of your Quests log.

=4 Part 2
* Trade {p:Nodal Wand I} to {n:Runje Desaali} to initiate the next process.
* Trade the following to {n:Geosuke}:
** 200 {i:Ghastly Stones|Ghastly Stone|3954}
*** **{c=red:Note:}** {i:Ghastly Stone +1s|Ghastly Stone +1|3955}/{i:+2s|Ghastly Stone +2|3956} do not work for this quest. You can, however, trade them to {n:Ornery Dhole} for **Obsidian Fragments**. In return, you can buy NQ {i:Ghastly Stones|Ghastly Stone|3954} for 50 **Obsidian Fragments** each.
*** You can turn in {i:Copper Voucher|Copper Voucher|8711} for **Obsidian Fragments**.
** 500 {i:High-Purity Bayld}
** 1 {i:Gabbrath Meat|Gabbrath Meat|6068}
** 1 {i:Rockfin Tooth|Rockfin Tooth|3979}
** 1 {i:Bztavian Stinger|Bztavian Stinger|3980}
*** You can talk to Runje and peruse the option "View materials. (GEO)" to check your current turn-in progress.
* You will receive a {k:Ripple Prominence concretion} upon turning in all the items.
* Trade your {p:Nodal Wand I} to the {p:Ergon Locus} at (E-10) in {z:Dho Gates} to upgrade it to the {p:Nodal Wand II} (-2% {p:luopan|Luopan} damage).
** {z:Marjami Ravine} Frontier Station Waypoint is near the entrance closest to the {p:Ergon Locus}.
*** There are two cliffs to scale that require {k:Climbing} KI, or you can wipe/tractor/raise up both.

=4 Part 3
* Trade {p:Nodal Wand II} to {n:Runje Desaali} to initiate the next process.
* Trade the following to {n:Geosuke}:
** 200 {i:Verdigris Stones|Verdigris Stone|4033}
*** **{c=red:Note:}** {i:Verdigris Stone +1s|Verdigris Stone +1|4034}/{i:+2s|Verdigris Stone +2|4035} do not work for this quest. You can, however, trade them to {n:Ornery Dhole} for **Obsidian Fragments**. In return, you can buy NQ {i:Verdigris Stones|Verdigris Stone|4033} for 100 **Obsidian Fragments** each.
*** You can turn in {i:Copper Voucher|Copper Voucher|8711} for **Obsidian Fragments**.
** 2,500 {i:High-Purity Bayld}
** 1 {i:Yggdreant Bole|Yggdreant Bole|4014}
** 1 {i:Waktza Crest|Waktza Crest|4013}
** 1 {i:Cehuetzi Pelt|Cehuetzi Pelt|8754}
*** You can talk to Runje and peruse the option "View materials. (GEO)" to check your current turn-in progress.
* You will receive an {k:Inferno concretion} upon turning in all the items.
* Trade your {p:Nodal Wand II} to the {p:Ergon Locus} at K-10 in {z:Moh Gates} to upgrade it to the {p:Nodal Wand III} ({p:Magic Accuracy} +5, {p:Magic Atk. Bonus} +5, -3% {p:luopan|Luopan} damage).
** You do not have to be on GEO main to trade the {p:Nodal Wand II}
** {z:Yahse Hunting Grounds} Waypoint #1 > (H-5) is close to the {z:Moh Gates} destination.
*** There is a cliff to scale that requires {k:Climbing} KI, or you can wipe/tractor/raise up it.

=4 Part 4
* Trade {p:Nodal Wand III} to {n:Runje Desaali} to initiate the next process.
* Trade the following to {n:Geosuke}:
** 200 {i:Wailing Stones|Wailing Stone|3951}
*** **{c=red:Note:}** {i:Wailing Stone +1s|Wailing Stone +1|3952}/{i:+2s|Wailing Stone +2|3953} do not work for this quest. You can, however, trade them to {n:Ornery Dhole} for **Obsidian Fragments**. In return, you can buy NQ {i:Wailing Stones|Wailing Stone|3951} for 200 **Obsidian Fragments** each.
*** You can turn in {i:Copper Voucher|Copper Voucher|8711} for **Obsidian Fragments**.
** 9,999 {i:High-Purity Bayld}
** {i:Pristine Yggrete Crystal|Pristine Yggrete Crystal|8797}
*** You can talk to Runje and peruse the option "View materials. (GEO)" to check your current turn-in progress.
* You will receive a {k:Cyclone concretion} upon turning in all the items.
* Trade your {p:Nodal Wand III} to the {p:Ergon Locus} at K-11 in {z:Sih Gates} to obtain your new shiny {i:Idris|Idris (Level 119)|21070}.
** You require the {k:Watercrafting} KI to reach the Ergon Locus, or you can wipe/tractor/raise across the water.
*** {z:Foret de Hennetiel} Frontier Station Waypoint is near the entrance closest to the Ergon Locus.

=4 Dropped Item
If you have dropped any stage **Nodal Wand**, you can re-aquire it at the stage that you are at by doing the following:
* Talk to {n:Geosuke}. You might need to talk to him multiple times. Eventually, {n:Runje Desaali} will ask you if you accidentally dropped the weapon.
* Answer Yes
* Trade __(information needed)__1,000,000 Gil to {n:Runje Desaali} and she will craft you a new **Nodal Wand** at the stage you were at. (Done with {p:Lexeme Blade II}, don't know if all versions cost the same amount of gil).

]=],
}
