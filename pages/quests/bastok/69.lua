-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/The_Walls_of_Your_Mind). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'The Walls of Your Mind',
    title = 'The Walls of Your Mind',
    source = 'https://www.bg-wiki.com/ffxi/The_Walls_of_Your_Mind',
    images = {'Bostaunieux Oubliette-map3.jpg', 'Broken Latent.png'},
    meta_order = {'Name', 'Required Fame', 'Level Restriction', 'Starting NPC', 'Pack', 'Title', 'Repeatable', 'Description', 'Previous Quest', 'Next Quest', 'Requirements', 'Rewards'},
    meta = {
        ['Name'] = 'The Walls of Your Mind',
        ['Required Fame'] = '{p:Bastok|Category:Bastok Quests} Fame Level: NA',
        ['Level Restriction'] = 'Level 71',
        ['Starting NPC'] = '{p:Oggbi} - {z:Port Bastok} (E-6)',
        ['Pack'] = 'Rise of the Zilart',
        ['Title'] = 'None',
        ['Repeatable'] = '__No__',
        ['Description'] = 'Use the cesti granted to you by Master Oggbi to break the barriers that cloud your mind. When you feel the weapon can assist you no further, return to the master for instructions.',
        ['Previous Quest'] = 'None',
        ['Next Quest'] = 'None',
        ['Requirements'] = '{p:Hand-to-Hand} skill 250+, {p:Monk} or {p:Puppetmaster} level 71',
        ['Rewards'] = '{p:Asuran Fists} weapon skill'
    },
    body = [=[
=2 Walkthrough
* You cannot start this quest if you have another {q:Weapon Skill Quest|WSNM|Weapon Skill Quest} active. You must return to the person that gave said quest and quit it to start another.

!Bostaunieux Oubliette-map3.jpg||Bostaunieux Oubliette Map 3
* Speaking with {p:Oggbi} will grant you the key item {k:Weapon training guide} as well as the {p:Knuckles of Trials}. You will need to break the latent on the {p:Knuckles of Trials} before completing the rest of the quest.

:* Breaking the Latent

::* With the {p:Knuckles of Trials} equipped in your Main hand, fight experience-yielding mobs ("Incredibly Easy Prey" or higher) and perform {p:Weapon Skills|Category:Weapon Skills} or close {p:Skillchains|Category:Skillchain} to accumulate 300 "Trial Points".

|^Skillchain Level|Points
|No Skillchain|5
|Level 1|7
|Level 2|9
|Level 3|11

::* You know you have enough points when the latent breaks. You will know it is done when the weapon's elemental resistances disappear from your active resistances (colored dots below the gear grid, but above the selected item description). **The item's description text will never change**.

!Broken Latent.png||
* Trade the {p:Knuckles of Trials} back to {p:Oggbi}. This will give you the key item {k:Map to the Annals of Truth}. You will be instructed to travel to the {z:Bostaunieux Oubliette}.

* Unity NPC warp 122 is available to get you close within {z:Bostaunieux Oubliette} well after the drop. Head East and go through connection B to (I-8) where the ??? is located.
** Otherwise take {i:Silent Oil|Silent Oil|4165} with you and head to the {z:Chateau d'Oraguille}. In the entry hall, take the eastern door and follow the path north to {z:Bostaunieux Oubliette}.
** Once inside the Oubliette, head south to (H-7/8) and then west. Continue west to (E-7/8) and drop down. After you drop, head south again and then turn west. Go west until you have to turn south; repeat this until you come to (F-9) and then turn east.
** Follow this path until you come to (I-8), where you will find the ??? to spawn the NM.

* This fight is against {m:Bodach}, a skeleton. It is weak to {p:Fire} and {p:Light} attacks. Once you kill it, re-examine the ??? to receive the key item {k:Annals of Truth}.

* Go back and speak with {p:Oggbi} to receive your reward.

]=],
}
