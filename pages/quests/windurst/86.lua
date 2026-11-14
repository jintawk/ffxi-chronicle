-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Orastery_Woes). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Orastery Woes',
    title = 'Orastery Woes',
    source = 'https://www.bg-wiki.com/ffxi/Orastery_Woes',
    images = {'Broken Latent.png'},
    meta_order = {'Name', 'Required Fame', 'Level Restriction', 'Starting NPC', 'Pack', 'Title', 'Repeatable', 'Description', 'Previous Quest', 'Next Quest', 'Rewards'},
    meta = {
        ['Name'] = 'Orastery Woes',
        ['Required Fame'] = '{p:Windurst|Category:Windurst Quests} Fame Level: __Unknown__',
        ['Level Restriction'] = 'Level {p:Club} skill 230+, Level 71, Must be on WAR/MNK/WHM/BLM/PLD/SMN/BLU/SCH/GEO to flag quest',
        ['Starting NPC'] = '{n:Kuroido-Moido} - {z:Port Windurst} (E-7)',
        ['Pack'] = 'Rise of the Zilart',
        ['Title'] = 'None',
        ['Repeatable'] = '__No__',
        ['Description'] = 'The Operations Division of the Orastery has asked you to assist them in their plan to deliver the ministry from misery. Use the magical club that you have been given to record combat information for the Orastery.',
        ['Previous Quest'] = 'None',
        ['Next Quest'] = 'None',
        ['Rewards'] = '{p:Black Halo} weapon skill'
    },
    body = [=[
=2 Walkthrough
* You cannot start this quest if you have another {q:Weapon Skill Quest|WSNM|Weapon Skill Quest} active. You must return to the person that gave said quest and quit it to start another.
* Speaking with {n:Kuroido-Moido} will grant you the key item {k:Weapons Training Guide|Weapon training guide} as well as the {p:Club of Trials}. You will need to break the latent on the {p:Club of Trials} before completing the rest of the quest.

:* Breaking the Latent

::* With the {p:Club of Trials} equipped in your Main hand, fight experience-yielding mobs ("Incredibly Easy Prey" or higher) and perform {p:Weapon Skills|Category:Weapon Skills} or close {p:Skillchains|Category:Skillchain} to accumulate 300 "Trial Points".

|^Skillchain Level|Points
|No Skillchain|5
|Level 1|7
|Level 2|9
|Level 3|11

::* You know you have enough points when the latent breaks. You will know it is done when the weapon's elemental resistances disappear from your active resistances (colored dots below the gear grid, but above the selected item description). **The item's description text will never change**.

!Broken Latent.png||
* Trade the {p:Club of Trials} back to {n:Kuroido-Moido}. This will give you the key item {k:Map to the Annals of Truth}. You will be instructed to travel to {z:Ro'Maeve}.

* Take {i:Silent Oil|Silent Oil|4165} and head to {z:Ro'Maeve}.

* Inside {z:Ro'Maeve}, go down the northeastern stairs and turn immediately east. Go through the hallway to the right. Turn left, drop down the ledge and go through the door to the northeast. Turn left, head up the stairs to the north at (K-8). Follow the path northwest until you come to a northeast path through an open doorway at (J-8).
** Alternatively, if you have the {p:Survival Guide} warp or are starting from the Hall of the Gods zone just run down the long stairs to the south east.

* Through the door, turn right and follow the long hallway southeast to (M-8), past the Moongate. This is where the ??? is to spawn the NM, on the ground in front of an inaccessible tunnel entrance.

* This fight is against {m:Eldhrimnir}, a magic pot. Once you kill it, re-examine the ??? to receive the key item {k:Annals of Truth}.

* Go back and speak with {n:Kuroido-Moido} to receive your reward.

]=],
}
