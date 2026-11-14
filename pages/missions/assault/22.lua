-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Lebros_Supplies). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Lebros Supplies',
    title = 'Lebros Supplies',
    source = 'https://www.bg-wiki.com/ffxi/Lebros_Supplies',
    images = {'Lebros Cavern.jpg', '460px-LebrosSuppliesMap.jpg'},
    meta_order = {'Name', 'Staging Point', 'Starting NPC', 'Assault Rank', 'Objective', 'Mission Orders', 'Time Limit', 'Recommended Lv.', 'Assault Points'},
    meta = {
        ['Name'] = 'Lebros Supplies',
        ['Staging Point'] = '{p:Lebros Cavern}',
        ['Starting NPC'] = '{n:Famad} in {z:Aht Urhgan Whitegate} (L-9/L-10)',
        ['Assault Rank'] = '{p:Private First Class}',
        ['Objective'] = 'An advance unit sent into Lebros Cavern has met heavy resistance and is in need of reprovisioning. Your mission is to deliver rations to each member of the advance unit.',
        ['Mission Orders'] = 'Deliver the provisions',
        ['Time Limit'] = '30 minutes',
        ['Recommended Lv.'] = 'Lvl. 60',
        ['Assault Points'] = '1 Member: __1200{br}__2 Members: __1200{br}__3 Members: __1200{br}__4 Members: __1080{br}__5 Members: __960{br}__6 Members: __840__'
    },
    body = [=[
!Lebros Cavern.jpg|right|Lebros Cavern
=2 Enemies
|^Level|Name|Zone|Aggro|Link|Drops|Steal|Spawns
|?|{m:Crimson Eruca}|{p:Lebros Cavern}|Yes|Yes||None|9

=3 Notes
* This assault appears to have been ninja-nerfed, as it now takes fewer points to fully feed an NPC.
* Crimson Erucas aggro {@a:True Sound|Detects by True Sound} true sound from a distance of around 8', and will detect through {s:Sneak}(Status).
* Crimson Erucas are susceptible to {p:Bind|Bind (Status)}, {p:Weight} and {p:Sleep|Sleep (Status)}.
* Due to the many circular obstacles scattered around the maps (i.e. lava pools), it is fairly easy to continue delivering provisions with several crawlers on you if you have some form of movement speed+.
* Crimson Erucas seem to never deaggro.
* When passive, Crimson Erucas move back to their home areas at an extremely slow pace.

=2 Walkthrough
Feed all 12 of the soldiers.
* {n:Yazuhma} will keep you supplied with tasty treats for those hard working soldiers. She will only give one supply out every few seconds, so at the beginning you will have to wait as she hands things to you one by one.
* Yazuhma will report to you how many soldiers are still hungry with the following messages:

:* 7-12 remaining: "There are still brave soldiers starving out there."
:* 4-6 remaining: "It looks like about half of the advance unit has recieved their rations."
:* 2-3 remaining: "Not many hungry soldiers left, I'd wager!"
:* 1 remaining: "There must be somebody out there still waiting for you."

* Yazuhma will give you one of five foods. It is generally accepted that these foods have different values.

:* {@i:Seafood Stewpot|5238} {i:Seafood Stewpot|Seafood Stewpot|5238}: 7 Points + AoE effect that covers the entire group the soldier is part of.
:* {@i:Bison Steak|5142} {i:Bison Steak|Bison Steak|5142}: 5 Points.
:* {@i:Coeurl Sub|5166} {i:Coeurl Sub|Coeurl Sub|5166}: 4 Points.
:* {@i:Bison Jerky|5207} {i:Bison Jerky|Bison Jerky|5207}: 3 Points.
:* {@i:Pea Soup|4416} {i:Pea Soup|Pea Soup|4416}: 2 Points.
:* {@i:White Bread|4356} {i:White Bread|White Bread|4356}: 1 Point.

* Each soldier needs 7 points to be full.
** This may have been nerfed, Bison Steak+White Bread= 6 points, but filled the last soldier and unlocked the rune of release.
* Talking to a {n:Imperial Stormer} soldier NPC with food in your possession will automatically feed it to them.
* You can tell if a soldier is full or not by talking to him with no food in your inventory.

:* A hungry soldier will ask you "Have you brought the provisions?"
:* A satiated soldier will say "There's nothing like a full belly...".

* When you feed a soldier they will give you a different message based on whether they were full already or not:

:* If the soldier was hungry before you fed it you will recieve the message "Thank Zahak you're here. I was about to start eating my boots."
:* If the soldier was full before you fed it you will recieve the message "You brought more supplies? Well, you can never have too much..."

* The soldiers within a particular area all have different types of shields, which are useful for telling them apart. The shields are as follows:

:* {@i:Spiked Buckler|12347} {i:Spiked Buckler|Spiked Buckler|12347}
:* {@i:Balance Buckler|12349} {i:Balance Buckler|Balance Buckler|12349}
:* {@i:Gold Buckler|12303} {i:Gold Buckler|Gold Buckler|12303}

* There are 2 soldiers in the west-south-west, 2 in south-south-west, 3 in the south-east, 3 in the north-west and 2 at the North.
* The {p:Rune of Release} spawns at {n:Yazuhma}.

=2 Drops
|^Ancient Lockbox
|{i:Hi-Potion +2|Hi-Potion +2|4118}
|{i:Hi-Potion Tank|Hi-Potion Tank|13688}
|{i:Reraiser|Reraiser|4172}

|^??? Box
|{i:Bullet Pouch|Bullet Pouch|5363}
|{i:Flan Meat|Flan Meat|2175}
|{i:Sulfur|Sulfur|1108}

|^??? Cape
|{i:Cotton Cape +1|Cotton Cape +1|13601}
|{i:Dhalmel Mantle +1|Dhalmel Mantle +1|13600}
|{i:Enhancing Mantle|Enhancing Mantle|13624}
|**{i:Storm Cape|Storm Cape|15489}**

=2 Map
!460px-LebrosSuppliesMap.jpg|right|Assault Map
]=],
}
