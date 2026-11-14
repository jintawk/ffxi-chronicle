-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Seagull_Grounded). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Seagull Grounded',
    title = 'Seagull Grounded',
    source = 'https://www.bg-wiki.com/ffxi/Seagull_Grounded',
    images = {'Periqia.jpg', 'Image-SeagullGroundedMap.jpg'},
    meta_order = {'Name', 'Staging Point', 'Starting NPC', 'Assault Rank', 'Objective', 'Mission Orders', 'Time Limit', 'Recommended Lv.', 'Assault Points'},
    meta = {
        ['Name'] = 'Seagull Grounded',
        ['Staging Point'] = '{p:Periqia}',
        ['Starting NPC'] = '{n:Lageegee} in {z:Aht Urhgan Whitegate} (L-9/L-10)',
        ['Assault Rank'] = '{p:Private Second Class}',
        ['Objective'] = 'The Immortals have captured a member of the Seagull Phratrie, a rebel organization. You are to escort the prisoner safely to a holding area.',
        ['Mission Orders'] = 'Escort the prisoner',
        ['Time Limit'] = '30 minutes',
        ['Recommended Lv.'] = 'Lvl. 70',
        ['Assault Points'] = '1 Member: __1100{br}__2 Members: __1100{br}__3 Members: __1100{br}__4 Members: __990{br}__5 Members: __880{br}__6 Members: __770__'
    },
    body = [=[
!Periqia.jpg|right|Periqia
=2 Enemies
|^Level|Name|Zone|Aggro|Link|Drops|Steal|Spawns
|DC|{m:Arrapago Crab}|{p:Periqia}|Yes|No||None|9
|T|{m:Debaucher}|{p:Periqia}|Yes|No||None|3
|T|{m:Periqia Pugil}|{p:Lebros Cavern}|Yes|Yes||None|9

=2 Walkthrough
The objective to this mission is to escort the prisoner {n:Excaliace} to where the {p:Rune of Release} spawns at (F-12).
* {n:Excaliace} will move automatically when a party member is a few yards behind him.
** Excaliace will stop at certain points if party members are crowding him and remark, "Someone's been eating too much garlic..."
** If no party members are close to Excaliace, he try to escape by running away, "Now's my chance!" If he is successful, the mission is a failure.
** If Excaliace encounters a monster, he will run away.
* Excaliace will investigate one room labeled 'A', one room labeled 'B', and one room labeled 'C' on the map below.
** If the room contains {m:Arrapago Crabs|Arrapago Crab}, you must defeat the crabs before he enters the room.
* At the junction in (H-8), Excaliace will choose to go towards the label 'D' or the label 'E'. In either case, the path ahead of him will contain 2 or 3 {m:Periqia Pugils|Periqia Pugil} and possibly a {m:Debaucher} which need to be cleared.
* In (G-10) there is a {m:Debaucher} which needs to be taken care of. It is possible to pull the Debaucher to the side so that Excaliace can pass by while the party deals with the monster.
* In the final room there is a {m:Debaucher}. It can be pulled away so that Excaliace does not see it.
* The {p:Rune of Release} spawns in the northwest corner of the room, where Excaliace completes his patrol.

=2 Drops
|^Ancient Lockbox
|{i:Hi-Ether Tank|Hi-Ether Tank|13689}
|{i:Hi-Potion +3|Hi-Potion +3|4119}
|{i:Hi-Potion Tank|Hi-Potion Tank|13688}
|{i:Hi-Reraiser|Hi-Reraiser|4173}

|^??? Box
|{i:Bld. Bolt Quiver|Bld. Bolt Quiver|5339}
|{i:Bone Chip|Bone Chip|880}
|{i:Cleaning Tool Set|Cleaning Tool Set|113}
|{i:Igneous Rock|Igneous Rock|1654}
|{i:Rainbow Thread|Rainbow Thread|821}
|{i:Rotten Quiver|Rotten Quiver|4196}
|{i:Wild Onion|Wild Onion|4387}

|^??? Gloves
|{i:Bronze Mittens +1|Bronze Mittens +1|12695}
|{i:Cotton Gloves|Cotton Gloves|12721}
|{i:Cuffs|Cuffs|12728}
|{i:Leather Gloves|Leather Gloves|12696}
|**{i:Storm Manopolas|Storm Manopolas|14936}**

|^??? Polearm
|{p:Spark Spear}

|^??? Sword
|{i:Gust Claymore|Gust Claymore|18366}
|**{p:Kosetsusamonji}**
|{p:Uchigatana +1}

=2 Map
!Image-SeagullGroundedMap.jpg|right|Assault Map
]=],
}
