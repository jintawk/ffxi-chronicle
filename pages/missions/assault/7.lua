-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Azure_Experiments). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Azure Experiments',
    title = 'Azure Experiments',
    source = 'https://www.bg-wiki.com/ffxi/Azure_Experiments',
    images = {'Leujaoam Sanctum.jpg', 'AzureExperimentsMap.jpg'},
    meta_order = {'Name', 'Staging Point', 'Starting NPC', 'Assault Rank', 'Objective', 'Mission Orders', 'Time Limit', 'Recommended Lv.', 'Assault Points'},
    meta = {
        ['Name'] = 'Azure Experiments',
        ['Staging Point'] = '{p:Leujaoam Sanctum}',
        ['Starting NPC'] = '{n:Yahsra} in {z:Aht Urhgan Whitegate} (L-9/L-10)',
        ['Assault Rank'] = '{p:Sergeant Major}',
        ['Objective'] = 'The Imperial alchemists have developed various tissues to graft onto and strengthen the bodies of the Immortals, but they need test subjects for clinical experiments. Go lend your assistance.',
        ['Mission Orders'] = 'Become a test subject',
        ['Time Limit'] = '30 minutes',
        ['Recommended Lv.'] = 'Lvl. 70',
        ['Assault Points'] = '1 Member: __1000{br}__2 Members: __1000{br}__3 Members: __1000{br}__4 Members: __900{br}__5 Members: __800{br}__6 Members: __700__'
    },
    body = [=[
!Leujaoam Sanctum.jpg|right|Leujaoam Sanctum
=2 Enemies
|^Level|Name|Zone|Aggro|Link|Drops|Steal|Spawns
|?|{m:Lamia Bowyer}|{p:Leujaoam Sanctum}|Yes|Yes|{i:Water Crystal|Water Crystal|4101}|None|2-4
|?|{m:Lamia Prosector}|{p:Leujaoam Sanctum}|Yes|Yes|{i:Water Crystal|Water Crystal|4101}|None|4
|?|{m:Lamia Sharper}|{p:Leujaoam Sanctum}|Yes|Yes|{i:Water Crystal|Water Crystal|4101}|None|2-4

=3 Notes
* The Lamiae will pop in groups of 2-3, they link and track by sight, meaning they can be separated by pulling with {p:Hide} or {p:Carbuncle}.
* The Prosectors (BLM) are immune to sleep, so if you link on a pull you should probably fight them first.
* The Sharpers are immune to slow.
* The Prosectors will self-buff without being aggroed, and are likely to have {s:Ice Spikes} up when you pull them.
* The Lamiae are highly evasive.
* Each group will always have a BLM.

=2 Walkthrough
* Speak to {n:Nareema} to receive a random graft. This spawns a group of {m:Lamiae|Lamia} in one of four spots (two to the west, one to the south, and one to the east.) The grafts are:
** Dragonfly Optical Tissue:+Acc/Racc -Atk/Ratk
** Goobbue Muscle Tissue:+100% atk, +100% slow
** Opo-opo Cerebral Tissue:MP -50%, Fast Cast
** Raptor Tissue: Movement Speed +100%, HP -50%
* After defeating each group of Lamiae, talk to Nareema again for another graft to spawn the next group.
* After all four groups are defeated, the Rune of Release will spawn back at the starting point at (G-7).
** Since the eastern spawn point is down a one-way drop that requires you to walk in a loop to get back to the start, ranged pulling is recommended.

=2 Drops
|^Ancient Lockbox
|{i:Hi-Ether Tank|Hi-Ether Tank|13689}
|{i:Hi-Potion +3|Hi-Potion +3|4119}
|{i:Hi-Potion Tank|Hi-Potion Tank|13688}
|{i:Hi-Reraiser|Hi-Reraiser|4173}

|^??? Box
|{i:Glass Sheet|Glass Sheet|1887}
|{i:Horn Quiver|Horn Quiver|4222}
|{i:Demon Quiver|Demon Quiver|4224}
|{i:Ice Crystal|Ice Crystal|4097}
|{i:Merrow Scale|Merrow Scale|2146}
|{i:Phalaenopsis|Phalaenopsis|1411}
|{i:Tsurara|Tsurara|1164}
|{i:White Rock|White Rock|776}

|^??? Footwear
|{i:Ash Clogs|Ash Clogs|12984}
|**{i:Ataractic Solea|Ataractic Solea|15705}**
|{i:Bronze Leggings +1|Bronze Leggings +1|12951}
|{i:Evoker's Boots|Evoker's Boots|15325} __(verification needed)__
|{i:Leather Highboots|Leather Highboots|12952}

|^??? Ring
|{i:Brass Ring|Brass Ring|13465}
|{i:Copper Ring|Copper Ring|13454}
|**{i:Divisor Ring|Divisor Ring|15786}**
|{i:Orichalcum Ring|Orichalcum Ring|13466}

|^??? Sword
|{p:Macuahuitl +1}

=2 Map
!AzureExperimentsMap.jpg|right|Assault Map
]=],
}
