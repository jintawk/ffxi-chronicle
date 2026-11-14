-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Excavation_Duty). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Excavation Duty',
    title = 'Excavation Duty',
    source = 'https://www.bg-wiki.com/ffxi/Excavation_Duty',
    images = {'Lebros Cavern.jpg', '460px-ExcavationDutyMap.jpg'},
    meta_order = {'Name', 'Staging Point', 'Starting NPC', 'Assault Rank', 'Objective', 'Mission Orders', 'Time Limit', 'Recommended Lv.', 'Assault Points'},
    meta = {
        ['Name'] = 'Excavation Duty',
        ['Staging Point'] = '{p:Lebros Cavern}',
        ['Starting NPC'] = '{n:Famad} in {z:Aht Urhgan Whitegate} (L-9/L-10)',
        ['Assault Rank'] = '{p:Private Second Class}',
        ['Objective'] = 'The Imperial Army plans to traverse Lebros Cavern as part of their attack on Halvung, however the tunnels are blocked with rocks. You must remove the obsctructions.',
        ['Mission Orders'] = 'Remove the obstructions',
        ['Time Limit'] = '30 minutes',
        ['Recommended Lv.'] = 'Lvl. 50',
        ['Assault Points'] = '1 Member: __1100{br}__2 Members: __1100{br}__3 Members: __1100{br}__4 Members: __990{br}__5 Members: __880{br}__6 Members: __770__'
    },
    body = [=[
!Lebros Cavern.jpg|right|Lebros Cavern
=2 Enemies
|^Level|Name|Zone|Aggro|Link|Drops|Steal|Spawns
|?|Brittle Rock|{p:Lebros Cavern}|No|No||None|5
|Tough|{m:Qiqirn Ceramist}|{p:Lebros Cavern}|No|Yes||None|5
|Tough|{m:Qiqirn Volcanist}|{p:Lebros Cavern}|No|Yes||None|4
|Tough|{m:Volcanic Bomb}|{p:Lebros Cavern}|Yes|No||None|8

=3 Notes
* Brittle Rocks take drastically reduced damage from all sources except dots, which are a very effective way to damage them.
* Brittle Rocks do not attack or move.
* Brittle Rocks are not in fact brittle.
* Brittle Rocks will not be destroyed by mines if you are not attacking the rock when it explodes, and you will lose the mine.

=2 Walkthrough
Destroy all 5 of the Brittle rocks.
* Brittle Rocks can be destroyed through damage, and damage over time is a very good way to do it. SCH/BLM can cast Bio, three non-overlapping elemental DoTs (e.g. {s:Shock}, {s:Burn}, {s:Choke}), and {p:Helix}. Immune to {s:Poison II}
* Volcanic Bombs aggro sight and can be completely avoided with {p:Invisible (Status)}.
* Qiqirn Volcanists and Ceramists will occasionally drop {i:Qiqirn Mine|Qiqirn Mine|5331} Temporary Items to help destroy the rocks.
** Once you have obtained a mine, engage a Brittle Rock and use the temporary item. Stay engaged until the device detonates and the rock will be destroyed in a single blast.
** At {p:Item Level} 117+, you can kill Qiqirn way faster than the walls, so it's worth trying to get bombs from them. Be sure to only kill one at a time.
* The {p:Rune of Release} will spawn at the dead end room at (F-10) when the last Brittle Rock is defeated.
** In order to save time, a party member can be sent towards the Rune while the last Brittle Rock is being fought.

=2 Drops
|^Ancient Lockbox
|{i:Hi-Potion +3|Hi-Potion +3|4119}
|{i:Remedy|Remedy|4155}

|^??? Box
|{i:Bomb Ash|Bomb Ash|928}
|{i:Bronze Bullet Pouch|Brz. Bull. Pouch|5359}
|{i:Copper Ore|Copper Ore|640}
|{i:Holy Basil|Holy Basil|1590}
|{i:Red Rock|Red Rock|769}
|{i:Spartan Bullet Pouch|Spar. Bul. Pouch|5341}
|{i:Sulfur|Sulfur|1108}
|{i:Troll Pauldron|Troll Pauldron|2160}
|{i:Velvet Cloth|Velvet Cloth|828}

|^??? Earring
|{i:Beetle Earring|Beetle Earring|13323}
|{i:Bone Earring|Bone Earring|13321}
|{i:Reraise Earring|Reraise Earring|14790}
|{i:Shell Earring|Shell Earring|13313}
|{i:Silver Earring|Silver Earring|13327}
|**{i:Storm Loop|Storm Loop|15968}**

=2 Map
!460px-ExcavationDutyMap.jpg|right|Assault Map
]=],
}
