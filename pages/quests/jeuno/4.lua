-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Chocobo's_Wounds). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Chocobo\'s Wounds',
    title = 'Chocobo\'s Wounds',
    source = 'https://www.bg-wiki.com/ffxi/Chocobo\'s_Wounds',
    images = {},
    meta_order = {'Name', 'Required Fame', 'Level Restriction', 'Starting NPC', 'Pack', 'Title', 'Repeatable', 'Description', 'Previous Quest', 'Next Quest', 'Requirements', 'Rewards'},
    meta = {
        ['Name'] = 'Chocobo\'s Wounds',
        ['Required Fame'] = '{p:Jeuno|Category:Jeuno Quests} Fame Level: 1',
        ['Level Restriction'] = 'Level 20',
        ['Starting NPC'] = '{n:Brutus}, {z:Upper Jeuno} (G-7)',
        ['Pack'] = 'None',
        ['Title'] = 'Chocobo Trainer',
        ['Repeatable'] = '__No__',
        ['Description'] = 'Help nurse the chocobo back to health. It seems to have suffered both mentally and physically. Gausebit wildgrass may do the trick.',
        ['Previous Quest'] = 'None',
        ['Next Quest'] = '{q:Save My Son|Save My Son|Save My Son} {br}{q:Full Speed Ahead!|Full Speed Ahead!|Full Speed Ahead!}',
        ['Requirements'] = '{@i:Gausebit Grass|534} {i:Gausebit Grass|Gausebit Grass|534} x 4',
        ['Rewards'] = '{@k} {k:Chocobo license}'
    },
    body = [=[
\**{c=red:Note}**: This quest along with the quest {p:Chocobo on the Loose!} (The {p:Chocobo Raising} quest) will activate upon speaking to {n:Brutus} for the first time.
=2 Walkthrough
* To begin, speak to {n:Brutus} at (G-7) on any job level 20 or higher, this starts the quest {p:Chocobo on the Loose!}.
* Speak to him two more times to start the correct quest, and choose "Nope, never!".
* Obtain {@i:Gausebit Grass|534} {i:Gausebit Grass|Gausebit Grass|534} x4.
** They can be purchased from the {z:Auction House} under Weapons > Ammo & Misc. > Pet Items
** Can be farmed in {z:Meriphataud Mountains} from {m:Crane Flies|Crane Fly}, or in {z:Dangruf Wadi} from {m:Wadi Hares|Wadi Hare}.
*** The crane flies are on the northern part of the map - by the outpost (and survival guide) or around the entrance to {z:Castle Oztroja}.
*** There isn't a super close {p:Unity Warp} to these locations for initial transit if you have yet to get a nearby {p:Survival Guide}:
**** The best bet might be the 122 {z:Meriphataud Mountains}, though it is near to the zone line with {z:Tahrongi Canyon}. {br}The 125 {z:Sauromugue Champaign} is also significantly more northward than would be ideal.
**** For {z:Dangruf Wadi}, the 75 {z:South Gustaberg} warp is closest if you don't have the Dangruf Wadi survival guide.
** __Do not confuse this with __{@i:Gysahl Greens|4545}__ {i:Gysahl Greens|Gysahl Greens|4545} which are sold from the stables NPC. They do not work.__
* Feed the chocobo standing next to {n:Osker} one {@i:Gausebit Grass|534} {i:Gausebit Grass|Gausebit Grass|534} by trading it to the chocobo.
** It is possible to feed the chocobo once every real life minute.
*** Each "minute" starts at :00 (rather than counting from the last feeding interaction with the chocobo)
** It will take 6 feeding attempts to complete the quest.
*** The first 2 attempts will automatically fail, and will not consume a grass.
** You can use a macro or chat command to speed up the process: /item 'gausebit grass' <t>
*** Tip: Stand closer to the Chocobo than to Osker and use F8 (or the target-closest-NPC button) to re-target the chocobo between attempts, as interaction will cause your target to be de-selected even if it's locked. If you're using the chat directly, press / and then the up arrow to repeat the last command you typed.
* Once the chocobo eats the {@i:Gausebit Grass|534} {i:Gausebit Grass|Gausebit Grass|534} x4, you are presented with a {@k} {k:Chocobo license}.

* You **don't need to zone** before starting the next quest, {q:Full Speed Ahead!|Full Speed Ahead!|Full Speed Ahead!}
** ...but you'll need the {k:Map of the Jeuno area} (available from {n:Rusese} inside M&P Market at H-6 for 600 gil) before {n:Mapitoto} will acknowledge you.

]=],
}
