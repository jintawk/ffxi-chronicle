-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Lost_and_Found). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Lost and Found',
    title = 'Lost and Found',
    source = 'https://www.bg-wiki.com/ffxi/Lost_and_Found',
    images = {'Ilrusi Atoll.jpg', 'Ilrusi Atoll-T7.jpg'},
    meta_order = {'Name', 'Staging Point', 'Starting NPC', 'Assault Rank', 'Objective', 'Mission Orders', 'Time Limit', 'Recommended Lv.', 'Assault Points'},
    meta = {
        ['Name'] = 'Lost and Found',
        ['Staging Point'] = '{p:Ilrusi Atoll}',
        ['Starting NPC'] = '{n:Bhoy Yhupplo} in {z:Aht Urhgan Whitegate} (L-9/L-10)',
        ['Assault Rank'] = '{p:Sergeant Major}',
        ['Objective'] = 'The Empress\'s uncle Bashalab visited Ilrusi Atoll in secret and lost his ring, the "Eye of Zahak." Escort the royal family\'s hired agent through Ilrusi Atoll and find his lost ring.',
        ['Mission Orders'] = 'Find the ring',
        ['Time Limit'] = '30 minutes',
        ['Recommended Lv.'] = 'Lvl. 60',
        ['Assault Points'] = '1 Member: __1000{br}__2 Members: __1000{br}__3 Members: __1000{br}__4 Members: __900{br}__5 Members: __800{br}__6 Members: __700__'
    },
    body = [=[
!Ilrusi Atoll.jpg|right|Ilrusi Atoll
=2 Enemies
|^Level|Name|Zone|Aggro|Link|Drops|Steal|Spawns
|EP|{m:Kelp Crab}|{p:Ilrusi Atoll}|Yes|No||None|
||{m:Kelp Kulshedra}|{p:Ilrusi Atoll}|Yes|No||None|

=3 Notes
* Kelp Crabs are a possible spawn when a ??? is triggered.

=2 Walkthrough
To win this assault, find the lost ring.
* The best way of doing this is to find the first clue with party members spread out on the map as you try to triangulate the rings position.
* After you find the rings general vicinity by triangulating, you need to have everyone move around in a small radius around the NPC after initiating her check, as it spawns the ??? which you must touch quickly before it disappears. Standing still seemed to not spawn the ??? in many attempts.

Speak with {n:Tian Tian} to get her to follow you.
* Walk around and then speak again with Tian Tian.
** Who, after taking her sweet time will provide you statements about the location of nearby clues.
* Initially, Tian Tian will only inform you about the proximity of the nearest clue.
* When you are close to a clue (~1'), a ??? will spawn.
* Click on the **???** quickly to check the clue. There are 4 possible outcomes:
** A {m:Kelp Crab} will spawn.
** You will find Seaweed, which will cause a {s:Gravity} effect.
** You will find a hint, which will upgrade Tian Tian's mystic powers of divination.
** Nothing happens.
* Upon finding the first hint, Tian Tian will begin informing the party about to the ring.
* At this point, the party can use triangulation to zero in on the ring.
* Further clues will enhance the messages from Tian Tian:
** 0 clues - Tian Tian will say there is either something to be found or nothing to be found near. No hints about the ring position.
** 1 clue - Tian Tian begins saying which party member is closest to the ring.
** 2 clues - Tian Tian begins giving the ring's approximate direction from her current position, regardless of physical obstacles (like impassable walls or water) that may separate the player from the ring.
** 3 clues - Tian Tian beings giving distance numbers in yalms from the ring. Again, she won't take into consideration anything between you and the ring.

* If you are **very close** to the ring, the ??? will spawn. Click on it quickly to retrieve the Eye of Zahak.
* The first two statements given by Tian Tian only refer to any nearby hints, not the location of the ring (unless you have already found the 3 hints). Only use the additional hint info (closest player, approximate location, and distance) to find the ring.

The {p:Rune of Release} will spawn at the start point when the ring is retrieved.
=2 Drops
|^Ancient Lockbox
|{i:Hi-Potion +2|Hi-Potion +2|4118}
|{i:Hi-Reraiser|Hi-Reraiser|4173}
|{i:Hi-Potion Tank|Hi-Potion Tank|13688}

|^??? Box
|{i:Aht Urhgan Brass Ingot|Aht Urhgan Brass Ingot|2418}
|{i:Distilled Water|Distilled Water|4509}
|{i:Lamian Armlet|Lamian Armlet|2167}
|{p:Little Worm}
|{i:Qutrub Gorget|Qutrub Gorget|2165}
|{i:Rusty Bucket|Rusty Bucket|90}
|{i:Willow Fishing Rod|Willow Fishing Rod|17391}

|^??? Gloves
|{i:Cotton Gloves|Cotton Gloves|12721}
|{i:Cuffs|Cuffs|12728}
|{i:Leather Gloves|Leather Gloves|12696}
|**{i:Sadhu Bracelets|Sadhu Bracelets|14953}**
|**{i:Sadhu Cuffs|Sadhu Cuffs|14954}**

=2 Map
!Ilrusi Atoll-T7.jpg|right|Assault Map
]=],
}
