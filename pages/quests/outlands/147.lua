-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Bugi_Soden). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Bugi Soden',
    title = 'Bugi Soden',
    source = 'https://www.bg-wiki.com/ffxi/Bugi_Soden',
    images = {'Broken Latent.png', 'Labyrinth of Onzozo-map.jpg'},
    meta_order = {'Name', 'Required Fame', 'Level Restriction', 'Starting NPC', 'Pack', 'Title', 'Repeatable', 'Description', 'Previous Quest', 'Next Quest', 'Requirements', 'Rewards'},
    meta = {
        ['Name'] = 'Bugi Soden',
        ['Required Fame'] = '{p:Outlands|Category:Outlands Quests} Fame Level: __Unknown__',
        ['Level Restriction'] = 'None',
        ['Starting NPC'] = '{n:Ryoma} - {z:Norg} (H-8)',
        ['Pack'] = 'Rise of the Zilart',
        ['Title'] = 'None',
        ['Repeatable'] = '__No__',
        ['Description'] = 'Wield the katana given to you by Ryoma until it has been drained of its power. Only then will you be ready to inherit the knowledge of the ancient ninja masters.',
        ['Previous Quest'] = 'None',
        ['Next Quest'] = 'None',
        ['Requirements'] = '{p:Katana} skill 250+, Level 71',
        ['Rewards'] = '{p:Blade: Ku} weapon skill'
    },
    body = [=[
=2 Walkthrough
* You cannot start this quest if you have another {q:Weapon Skill Quest|WSNM|Weapon Skill Quest} active. You must return to the person that gave said quest and quit it to start another.
* Speaking with {n:Ryoma} will grant you the key item {k:Weapons Training Guide|Weapon training guide} as well as the {p:Kodachi of Trials}. You will need to break the latent on the {p:Kodachi of Trials} before completing the rest of the quest.

:* Breaking the Latent

::* With the {p:Kodachi of Trials} equipped in your Main hand, fight experience-yielding mobs ("Incredibly Easy Prey" or higher) and perform {p:Weapon Skills|Category:Weapon Skills} or close {p:Skillchains|Category:Skillchain} to accumulate 300 "Trial Points".

|^Skillchain Level|Points
|No Skillchain|5
|Level 1|7
|Level 2|9
|Level 3|11

::* You know you have enough points when the latent breaks. You will know it is done when the weapon's elemental resistances disappear from your active resistances (colored dots below the gear grid, but above the selected item description). **The item's description text will never change**.

!Broken Latent.png||
* Trade the {p:Kodachi of Trials} back to {n:Ryoma}. This will give you the key item {k:Map to the Annals of Truth}. You will be instructed to travel to the {z:Labyrinth of Onzozo}.

* Take {i:Silent Oil|Silent Oil|4165} and {i:Prism Powder|Prism Powder|4164} with you and head to the {z:Labyrinth of Onzozo}. Once inside, follow the path to (H-9) and take the eastern tunnel. Continue northeast through the large room and take the tunnel at (J-8). In the next large room, curve around the eastern wall to the tunnel at (H-7); at the next intersection, head north. Continue north to the border of (I-5)/(I-6), where you will find the ??? to spawn the NM.
** Use the {p:Survival Guide} teleport if available
* This fight is against {m:Megapod Megalops}, a crab. It is weak to {p:Ice} and {p:Lightning} attacks. Once you kill it, re-examine the ??? to receive the key item {k:Annals of Truth}.

!Labyrinth of Onzozo-map.jpg||Labyrinth of Onzozo map
* Go back and speak with {n:Ryoma} to receive your reward.

=2 Notes
This fight can be carefully soloed by a 71NIN, and easily duoed with one support job - BRD, WHM, or RDM. Poses zero threat to a player in 119 gear.
]=],
}
