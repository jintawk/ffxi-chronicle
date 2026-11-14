-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Operation:_Snake_Eyes). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Operation: Snake Eyes',
    title = 'Operation: Snake Eyes',
    source = 'https://www.bg-wiki.com/ffxi/Operation:_Snake_Eyes',
    images = {'Periqia.jpg', 'OperationSnakeEyes.jpg'},
    meta_order = {'Name', 'Staging Point', 'Starting NPC', 'Assault Rank', 'Objective', 'Mission Orders', 'Time Limit', 'Recommended Lv.', 'Assault Points'},
    meta = {
        ['Name'] = 'Operation: Snake Eyes',
        ['Staging Point'] = '{p:Periqia}',
        ['Starting NPC'] = '{n:Lageegee} in {z:Aht Urhgan Whitegate} (L-9/L-10)',
        ['Assault Rank'] = '{p:Chief Sergeant}',
        ['Objective'] = 'Generals Karazahm and Umarid of the Imperial Army\'s Arrapago division have disappeared from camp headquarters while on a mission on Sharug Isle. There is a high possibility that the two have been kidnapped by members of the Undead Swarm.',
        ['Mission Orders'] = 'Locate the generals',
        ['Time Limit'] = '30 minutes',
        ['Recommended Lv.'] = 'Lvl. 70',
        ['Assault Points'] = '1 Member: __1333{br}__2 Members: __1333{br}__3 Members: __1333{br}__4 Members: __1200{br}__5 Members: __1066{br}__6 Members: __933__'
    },
    body = [=[
!Periqia.jpg|right|Periqia
=2 Enemies
|^Level|Name|Zone|Aggro|Link|Drops|Steal|Spawns
|DC|{p:Qutrub}|{p:Periqia}|Yes|No||None|5
||{m:Merrow No 16}|{p:Periqia}|Yes|Yes||None|
||{m:Lamia No 14}|{p:Periqia}|Yes|Yes||None|
||{m:Lamia No 17}|{p:Periqia}|Yes|Yes||None|
||{m:Merrow Shadowdancer}|{p:Periqia}|Yes|Yes||None|5

=3 Notes
* {m:Merrow Shadowdancer} can be avoided with {p:Invisible (Status)}.

=2 Walkthrough
This assault is composed of several tasks which must all be completed to unlock the {p:Rune of Release}. {br} {br} **Task 1: Kill the Qutrub**
* Scattered about the start location (I-9) are 5 Qutrub. Defeat these to unlock the doors to the north.

>**Task 2: Kill Merrow No.16**
* In one of the 6 rooms to the north, {m:Merrow No 16} will be fighting general {n:Karazahm}. Defeat Merrow No.16 and do not let the general die.
* {m:Merrow No 16} and the general do not show up on wide scan, so you will need to check each room quickly to find them.

>**Task 3: Kill Lamia No.14**
* In (I-6), {m:Lamia No 14} must be defeated to unlock the door to the north.
* Beware of Belly Dance, a sight-based AoE charm. Everyone should face away from the NM when she uses this ability to avoid being charmed.

(Another strategy for #14 is for the entire party to get charmed, #14 then will proceed to take the whole party through the gate and drop you right near general {n:Umarid}. You may/may not have to kill #14 depending on how your party uncharms. If you choose to fight her at the general then make sure everyone faces her and keep bio/poison on in case the party gets charmed because she will regen when unclaimed. (She seems to use belly dance a lot less when fought near the general))
>**Task 4: Kill Lamia No.17**
* In (H-6), you will find general {n:Umarid}. Upon approaching him, he will attack. Damage him to <50% HP and {m:Lamia No 17} will appear.
* The general has approximately 5300 HP.
** **Do not kill the general**
** **General has less than 4463 HP with single person entry at 119. 1 {s:Subduction} did kill them.**
** **If you end up killing the general, the assault will end abruptly and boot you outside the assault as a fail. Prior to a patch, item level 119 players would end up with a dead general (i.e. killed too fast) and not be able to complete the assault, thus being stuck in the assault instance until timer expires.**
* Once Lamia No.17 appears, defeat her to unlock the {p:Rune of Release} at (I-5).

=2 Drops
|^Ancient Lockbox
|{i:Hi-Potion +3|Hi-Potion +3|4119}
|{i:Hi-Potion Tank|Hi-Potion Tank|13688}
|{i:Hi-Reraiser|Hi-Reraiser|4173}

|^??? Box
|{i:Bronze Bolt Quiver|Bronze Bolt Quiver|4227}
|{i:Bld. Bolt Quiver|Bld. Bolt Quiver|5339}
|{i:Cleaning Tool Set|Cleaning Tool Set|113}
|{i:Igneous Rock|Igneous Rock|1654}
|{i:Qiqirn Sandbag|Qiqirn Sandbag|2153}
|{i:Qutrub Gorget|Qutrub Gorget|2165}
|{i:Apple Mint|Apple Mint|1523}

|^??? Necklace
|{i:Feather Collar|Feather Collar|13075}
|{i:Gorget +1|Gorget +1|13065}
|**{i:Chi Necklace|Chi Necklace|15535}**

|^??? Ring
|{i:Brass Ring|Brass Ring|13465}
|{i:Copper Ring|Copper Ring|13454}
|**{i:Pi Ring|Pi Ring|15797}**

=2 Map
!OperationSnakeEyes.jpg|right|Visual Guide, click to enlarge.
]=],
}
