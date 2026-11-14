-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Bastok_Mission_9-1). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Bastok Mission 9-1',
    title = 'The Salt of the Earth',
    source = 'https://www.bg-wiki.com/ffxi/Bastok_Mission_9-1',
    images = {'Gustav Tunnel-map1.jpg', 'Gustav Tunnel-map2.jpg'},
    meta_order = {'Name', 'Series', 'Starting NPC', 'Title', 'Repeatable', 'Description', 'Previous Mission', 'Next Mission', 'Rewards'},
    meta = {
        ['Name'] = 'The Salt of the Earth',
        ['Series'] = 'Rise of the Zilart',
        ['Starting NPC'] = 'Any Bastok Gate Guard',
        ['Title'] = 'None',
        ['Repeatable'] = '__No__',
        ['Description'] = 'You have been assigned to an investigation in the {p:Vollbow} Region. Speak with senator {n:Alois} for further details.',
        ['Previous Mission'] = '{M:Enter the Talekeeper|Bastok Mission 8-2|Enter the Talekeeper}',
        ['Next Mission'] = '{M:Where Two Paths Converge|Bastok Mission 9-2|Where Two Paths Converge}',
        ['Rewards'] = 'Rank Points'
    },
    body = [=[
=2 Walkthrough
!Gustav Tunnel-map1.jpg|right|Gustav Map 1
!Gustav Tunnel-map2.jpg|right|Gustav Map 2
Trade enough {p:Crystals} to the {p:Conquest NPC} to raise your Rank bar and unlock the Mission, then accept it from the {n:Gate Guard}.
* Visit {n:Alois} in the **President's Office Conference Room** in {z:Metalworks} (J-8).
* Head to {z:Rabao} and speak to {n:Dancing Wolf} in (G-7) for a cutscene.
** You may have to speak to him several times to receive the correct cutscene, make sure he mentions Miraclesalt.
** If he repeats the same text after talking to him several times but does not mention Miraclesalt, zone and return. It has been observed that 3 cycles of talking and zoning has been required.
* Proceed to {z:Gustav Tunnel} (G-6) on Map 2, and reach the **???** located in the pond.
** The {p:Unity Warp} Level 128 to {z:Gustav Tunnel} places you on the correct map, just south of the pond.
** Alternatively, there is a {p:Survival Guide} to Map 1.
** Everything in the area will aggro. If in a party, you could have other players wait at (H-7), as it is safe there from aggro.
* Checking the **???** will spawn {m:Gigaplasm}, a {m:slime|Slime} NM.
** Trivial at 99 with {p:Trusts|Trust}.
** You can {s:Sneak} pull, {s:sleep|Sleep} the NM and run back to camp. The NM will eventually make its way to you.
** {m:Slime} NMs have high melee resistance. Casters will be very important, and {s:sleeping|Sleep} the mobs will be imperative.
** You will start against one {m:Gigaplasm}, defeating it will cause it to divide in 2 {m:Macroplasms|Macroplasm}. Each of those will divide into 2 {m:Microplasms|Microplasm}, and those will divide into 2 {m:Nanoplasms|Nanoplasm}. Try to keep as many mobs asleep as you can. Commence by killing one line of Macroplasms (defeat one, defeat its Microplasms, and then its Nanoplasms), and then the second. Sleep repeatedly. The HP of the mobs gets progressively lower, to the point where a decently equipped BLM should be able to one-shot a Nanoplasm with a single {s:Thunder III}. The key to this fight is keeping everything asleep.
** Avoid giving the mobs too much TP, as they can use the typical nasty slime TP attacks, like Fluid Spread.
* Defeat all of them and {s:Sneak} everyone to the **???**. Check it to receive the {@k} {k:Miraclesalt}.
* Return to {z:Rabao} and speak to {n:Dancing Wolf} for a cutscene.
* Head back to {n:Alois} to finish the Mission.

=2 Notes
* Although this Mission may prove difficult for some, it can be easily completed by two RDM/BLM, who gravity the {m:Gigaplasm}, drag it back up to the first map, and take it to the zone line. Proceed to nuke and sleep at a distance. If you are standing far enough away, you will not have aggro on the plasm divisions.
* One possible strategy from here is to have one player sleep one of the divisions, while the other casts gravity and zones the second split, causing it to deaggro and eventually depop. If done properly and repeated each time the plasm splits, this mission becomes drastically easier. You will still receive credit for completing the mission so long as one {m:Nanoplasm} is defeated.

]=],
}
