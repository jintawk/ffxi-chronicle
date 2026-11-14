-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Saving_Private_Ryaaf). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Saving Private Ryaaf',
    title = 'Saving Private Ryaaf',
    source = 'https://www.bg-wiki.com/ffxi/Saving_Private_Ryaaf',
    images = {'Periqia.jpg', '460px-SavingPrivateRyaafMap.jpg'},
    meta_order = {'Name', 'Staging Point', 'Starting NPC', 'Assault Rank', 'Objective', 'Mission Orders', 'Time Limit', 'Recommended Lv.', 'Assault Points'},
    meta = {
        ['Name'] = 'Saving Private Ryaaf',
        ['Staging Point'] = '{p:Periqia}',
        ['Starting NPC'] = '{n:Lageegee} in {z:Aht Urhgan Whitegate} (L-9/L-10)',
        ['Assault Rank'] = '{p:Superior Private}',
        ['Objective'] = 'A squad sent in to search for the Seagull Phatrie hideout has failed to report. Find any survivors, especially one Private Ryaaf, a relative of the Galeserpent General.',
        ['Mission Orders'] = 'Find the survivors',
        ['Time Limit'] = '30 minutes',
        ['Recommended Lv.'] = 'Lvl. 70',
        ['Assault Points'] = '1 Member: __1210{br}__2 Members: __1210{br}__3 Members: __1210{br}__4 Members: __1089{br}__5 Members: __968{br}__6 Members: __847__'
    },
    body = [=[
!Periqia.jpg|right|Periqia
=2 Enemies
|^Level|Name|Zone|Aggro|Link|Drops|Steal|Spawns
|Tough-Very Tough|{m:Experimental Undead} ({p:BRD}, {p:THF})|{p:Periqia}|Yes|No||None|?
|Tough-Very Tough|{m:Cursed Chigoe}|{p:Periqia}|Yes|No||None|12

=3 Notes
* Experimental Undead agro to true sound and abilities.
* Cursed Chigoes agro to true sound and true sight.
* Cursed Chigoes have {p:additional effect|Additional effect}: {p:Curse}.
* It is very easy to lose agro on mobs in this assault, especially with movement speed+.
* Cursed Chigoes may be one shot killed with a critical hit, job ability or AoE Weaponskill.

=2 Walkthrough
The mission is a man.
* You begin the assault at (I-7), which is also where the {p:Rune of Release} spawns.
* The goal is to rescue the 3 captured NPCs while avoiding the fomors and chigoes.

:* The NPCs are hidden in the 4 side rooms and the middle. They will be seen as a hunched over figure in a black cloak, which will only turn into an NPC or a fomor when you move up to it. Note that there are other ways to tell the difference between an NPC and a fomor, as shown below.

* Your group should have a way of dealing with the three cursed chigoes in each room. While possible to pull these one by one with care, you will often end up with all three at once. Having a way to sleep these as well as somebody who can easily dispatch with chigoes is recommended for this. You can also sleep the chigoes, check whether the npc is a fomor or an npc and run away while they are still asleep.
* There are only 5 possible position combinations for the hunched over NPC/fomors to appear in.
* You can distinguish between NPCs and Fomors initially by the direction the hunched over figure is facing, except in the East room.

:* Fomors will always be facing **East**.

|^Room:|North|East|South|West|Center
|^NPC Faces:|North|East|West|West|South
|**Pattern #1**|{n:Balarahb}|{n:Rhagmakah}|Fomor|Fomor|{n:Ryaaf}
|**Pattern #2**|{n:Rhagmakah}|Fomor|Fomor|{n:Ryaaf}|{n:Balarahb}
|**Pattern #3**|{n:Ryaaf}|{n:Balarahb}|{n:Rhagmakah}|Fomor|Fomor
|**Pattern #4**|Fomor|Fomor|{n:Ryaaf}|{n:Balarahb}|{n:Rhagmakah}
|**Pattern #5**|Fomor|{n:Ryaaf}|{n:Balarahb}|{n:Rhagmakah}|Fomor

=2 Drops
|^Ancient Lockbox
|{i:Hi-Ether Tank|Hi-Ether Tank|13689}
|{i:Hi-Potion +3|Hi-Potion +3|4119}
|{i:Hi-Potion Tank|Hi-Potion Tank|13688}
|{i:Hi-Reraiser|Hi-Reraiser|4173}

|^??? Box
|{i:Acid Bolt Quiver|Acid Bolt Quiver|5335}
|{i:Apple Mint|Apple Mint|1523}
|{i:Bone Chip|Bone Chip|880}
|{i:Bronze Subligar +1|Bronze Subligar +1|12823}
|{i:Cleaning Tool Set|Cleaning Tool Set|113}
|{i:Gold Ore|Gold Ore|737}
|{i:Igneous Rock|Igneous Rock|1654}
|{i:Leather Trousers|Leather Trousers|12824}
|{i:Qiqirn Sandbag|Qiqirn Sandbag|2153}
|{i:Rotten Quiver|Rotten Quiver|4196}
|{i:Slacks|Slacks|12864}
|{i:Slops|Slops|12856}

|^??? Axe
|{i:Pickaxe|Pickaxe|605}

|^??? Polearm
|{p:Brass Zaghnal}
|{p:Holly Pole +1}
|{p:Spark Spear}
|{p:Willow Wand +1}
|**{i:Yigit Staff|Yigit Staff|18582}**

|^??? Shield
|{i:Lauan Shield|Lauan Shield|12289}
|{i:Mahogany Shield|Mahogany Shield|12292}
|{i:Maple Shield|Maple Shield|12290}
|**{i:Storm Shield|Storm Shield|16165}**

=2 Map
!460px-SavingPrivateRyaafMap.jpg|right|Assault Map
]=],
}
