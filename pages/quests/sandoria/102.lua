-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Old_Wounds). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Old Wounds',
    title = 'Old Wounds',
    source = 'https://www.bg-wiki.com/ffxi/Old_Wounds',
    images = {'Broken Latent.png'},
    meta_order = {'Name', 'Required Fame', 'Level Restriction', 'Starting NPC', 'Pack', 'Title', 'Repeatable', 'Description', 'Previous Quest', 'Next Quest', 'Requirements', 'Rewards'},
    meta = {
        ['Name'] = 'Old Wounds',
        ['Required Fame'] = '{p:San d\'Oria|Category:San d\'Oria Quests} Fame Level: __Unknown__',
        ['Level Restriction'] = 'None',
        ['Starting NPC'] = '{p:Curilla} - {z:Chateau d\'Oraguille} (I-9)',
        ['Pack'] = 'Rise of the Zilart',
        ['Title'] = 'None',
        ['Repeatable'] = '__No__',
        ['Description'] = 'Curilla has agreed to help you polish your single-handed sword skills for the upcoming tourneys.',
        ['Previous Quest'] = 'None',
        ['Next Quest'] = 'None',
        ['Requirements'] = '{p:Sword} skill 240+{br} Level 71{br} Main Job: WAR, RDM, PLD, DRK, BLU, COR, RUN',
        ['Rewards'] = '{p:Savage Blade} Weaponskill'
    },
    body = [=[
\**{c=red:Note:}** You cannot start this quest if you have another {q:Weapon Skill Quest|WSNM|Weapon Skill Quest} active. You must return to the person that gave said quest and quit to start another.
=2 Walkthrough
* Speaking with {p:Curilla} will grant you the {@k} {k:Weapon training guide} as well as the {@i:Sapara of Trials|17654} {p:Sapara of Trials}. You will need to break the latent on the {p:Sapara of Trials} before completing the rest of the Quest.

=3 Breaking the Latent
::* With the {p:Sapara of Trials} equipped in your Main hand, fight experience-yielding mobs ("Incredibly Easy Prey" or higher) and perform {p:Weapon Skills|Category:Weapon Skills} or close {p:Skillchains|Category:Skillchain} to accumulate 300 "Trial Points".

|^Skillchain Level|Points
|No Skillchain|5
|Level 1|7
|Level 2|9
|Level 3|11

::* You know you have enough points when the latent breaks. You will know it is done when the weapon's elemental resistances disappear from your active resistances (colored dots below the gear grid, but above the selected item description). **The item's description text will never change**.

!Broken Latent.png||
* The {m:Bight Uragnite} at (K-8) in {z:Ceizak Battlegrounds} are a great enemy to break the latent with if you are lv 99+.

----
* Trade the {p:Sapara of Trials} back to {p:Curilla}. This will give you the {@k} {k:Map to the Annals of Truth}.
* You will be instructed to travel to {z:Quicksand Caves}.
** Before you go, you will need to speak to {n:Lokpix} in {z:Eastern Altepa Desert} at (G-7) and complete the Quest {q:Open Sesame|Open Sesame|Open Sesame} to acquire the {@k} {k:Loadstone}. This allows you to use the weight-activated switches without needing multiple people.
* Take {@i:Echo Drops|4151} {i:Echo Drops|Echo Drops|4151} and {@i:Silent Oil|4165} {i:Silent Oil|Silent Oil|4165} with you.
* Head to {z:Western Altepa Desert}. You will now need to open the {q:Altepa Gate|Altepa Gate|Altepa Gate}.
** See the {q:Altepa Gate|Altepa Gate|Altepa Gate} page for instructions on opening it.
** Once you open the {q:Altepa Gate|Altepa Gate|Altepa Gate}, it will remain open for 15-30 minutes. It is advisable to either get help lowering the colored columns or have a mule behind the gate.
* Once you are behind the {q:Altepa Gate|Altepa Gate|Altepa Gate}, follow the path to the intersection and go north into the large room. You may need to clear this room of the {m:Antica} that live in it. The **???** to spawn the {p:NM} is at the northern tip of this room at (I-6).
* This fight is against {m:Girtablulu}, a scorpion. It is weak to {p:Ice} and {p:Light} attacks.
* Once you kill it, re-examine the **???** to receive the {@k} {k:Annals of Truth}.
* Go back and speak with {p:Curilla} to receive your reward.

]=],
}
