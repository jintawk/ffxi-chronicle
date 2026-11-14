-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Defuse_the_Threat). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Defuse the Threat',
    title = 'Defuse the Threat',
    source = 'https://www.bg-wiki.com/ffxi/Defuse_the_Threat',
    images = {'Periqia.jpg', 'Periqia-T7.jpg'},
    meta_order = {'Name', 'Staging Point', 'Starting NPC', 'Assault Rank', 'Objective', 'Mission Orders', 'Time Limit', 'Recommended Lv.', 'Assault Points'},
    meta = {
        ['Name'] = 'Defuse the Threat',
        ['Staging Point'] = '{p:Periqia}',
        ['Starting NPC'] = '{n:Lageegee} in {z:Aht Urhgan Whitegate} (L-9/L-10)',
        ['Assault Rank'] = '{p:Sergeant Major}',
        ['Objective'] = 'The Lamiae have hired Qiqirn demolition experts to set land mines in Periqia. You must eliminate this hazard for the soldiers.',
        ['Mission Orders'] = 'Clear the mine fields',
        ['Time Limit'] = '30 minutes',
        ['Recommended Lv.'] = 'Lvl. 60',
        ['Assault Points'] = '1 Member: __1600{br}__2 Members: __1600{br}__3 Members: __1600{br}__4 Members: __1440{br}__5 Members: __1280{br}__6 Members: __1120__'
    },
    body = [=[
!Periqia.jpg|right|Periqia
=2 Enemies
|^Level|Name|Zone|Aggro|Link|Drops|Steal|Spawns
|EP|{m:Qiqirn Miner}|{p:Periqia}|Yes|Yes||None|

=3 Notes
* {m:Qiqirn Miner} can be avoided with {p:Invisible (Status)}.

=2 Walkthrough
The object of this assault is to clear all 15 hidden Qiqirn Mines. The more mines successfully defused, the higher the AP reward.
* Mines are invisible and do not show up on {p:Widescan}.
* When a player approaches a mine, it will trigger a timer. The player then has 30 seconds to locate the mine.

:* Every 5 seconds, or when you cross a boundary, the bomb will emit a message indicating how close the player is to the bomb. The possible messages are:

"Kachink........." indicates the mine is about 15~20' away (further than the initial triggering distance)
"Kachink......" indicates the mine is 8~15' away
"Kachink..." indicates the mine is 3-8' away
"Kachink!" indicates the player is <3' away, and spawns the mine while you are within range.
:* When the mine spawns, it will appear and the player can click on the mine to defuse it.
:* If the mine despawns (or seems to refuse your click and despawns), it is because you moved out of range (before you clicked).
:* Mines also spawn when the timer runs out, but you cannot defuse them then.

* If the player fails to defuse the mine in time, it explodes for minor damage.
* If you are interested in maximizing AP, do not run near walls because it is possible to trigger mine timers from the other side of thin walls.

When all 15 mines have been dealt with, either defused or detonated, the {p:Rune of Release} spawns at H-9.
Blowing up all the mines fails the assault, you have to defuse at least one mine.
=2 Drops
|^Ancient Lockbox
|{i:Hi-Potion +2|Hi-Potion +2|4118}
|{i:Hi-Potion Tank|Hi-Potion Tank|13688}
|{i:Reraiser|Reraiser|4172}

|^??? Box
|{i:Bone Chip|Bone Chip|880}
|{i:Cleaning Tool Set|Cleaning Tool Set|113}
|{i:Igneous Rock|Igneous Rock|1654}
|{i:Qiqirn Sandbag|Qiqirn Sandbag|2153}
|{i:Rotten Quiver|Rotten Quiver|4196}
|{i:Venom Bolt Quiver|Venom Bolt Quiver|5338}

|^??? Gloves
|{i:Beak Gloves +1|Beak Gloves +1|13960}
|**{i:Ice Gauntlets|Ice Gauntlets|14952}**

|^??? Necklace
|{i:Feather Collar|Feather Collar|13075}
|{i:Gorget +1|Gorget +1|13065}
|{i:Philomath Stole|Philomath Stole|13176}
|**{i:Sniper's Collar|Sniper's Collar|15517}**

|^??? Polearm
|{i:Jadagna -1|Jadagna -1|18409}

=2 Map
!Periqia-T7.jpg|right|Assault Map
]=],
}
