-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Breaking_Morale). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Breaking Morale',
    title = 'Breaking Morale',
    source = 'https://www.bg-wiki.com/ffxi/Breaking_Morale',
    images = {'Mamool Ja Training Grounds.jpg', 'Breakingmorale.gif'},
    meta_order = {'Name', 'Staging Point', 'Starting NPC', 'Assault Rank', 'Objective', 'Mission Orders', 'Time Limit', 'Recommended Lv.', 'Assault Points'},
    meta = {
        ['Name'] = 'Breaking Morale',
        ['Staging Point'] = '{p:Mamool Ja Training Grounds}',
        ['Starting NPC'] = '{n:Isdebaaq} in {z:Aht Urhgan Whitegate} (L-9/L-10)',
        ['Assault Rank'] = '{p:Lance Corporal}',
        ['Objective'] = 'Scouts report that the new Mamool Ja soldiers have recieved supplies from their families. Destroy Mamool Ja morale by stealing these supplies while being careful to remain undetected.',
        ['Mission Orders'] = 'Steal the supplies',
        ['Time Limit'] = '15 minutes',
        ['Recommended Lv.'] = 'Lvl. 60',
        ['Assault Points'] = '1 Member: __1333{br}__2 Members: __1333{br}__3 Members: __1333{br}__4 Members: __1200{br}__5 Members: __1066{br}__6 Members: __933__'
    },
    body = [=[
!Mamool Ja Training Grounds.jpg|right|Mamool Ja Training Grounds
=2 Enemies
|^Level|Name|Zone|Aggro|Link|Drops|Steal|Spawns
|?|{m:Mamool Ja Recruit}|{p:Mamool Ja Training Grounds}|Yes|Yes||None|?
|?|{m:Mamool Ja Trainer}|{p:Mamool Ja Training Grounds}|Yes|Yes||None|?

=3 Notes
* The Mamool Ja move around very frequently, making it difficult to avoid aggro.
* If a Mamool Ja Trainer spots a player, the player will be instantly warped to the dead-end at I-8. Any supplies he was carrying will be confiscated and returned to their original coffer.
* If a Mamool Ja Recruit spots a player, they will attack the player. They can be slept and lose aggro very quickly. They are {p:Thief} and occasionally {p:Triple Attack}.
* Mamool Ja link and detect by sight. Thus, if you have a Recruit slept and a Trainer sees it, the player will instantly be spotted, even if the Trainer cannot see the player directly.
* One-shotting Mamool Ja does not allow them to detect you and it is very easy to cut a path with high-tier nukes.

=2 Walkthrough
Quick Completion: Exit the tunnel, turn left and go up the ramp. Grab the 1st chest at I-7 and return to the NPC to turn in. Talk to NPC again to "give up" and the Rune of Release will spawn.
The object of this assault is to collect treasure from coffers scattered about the map and return them to the start NPC {n:Quhaaja} without being detected by the roaming Mamool Ja.
* There are 8 total coffers containing supplies; only one must be successfully retrieved to win the assault.
* Bringing more supplies to the start NPC increases the point reward.
* In the main area of the assault there are many Trainers (blue mages) and Recruits (orange melees) Mamool Ja that must be avoided.
* Refer to the map for the locations of the treasure coffers.
* It is possible to carry more than one supply at a time. However, if captured, all supplies will be returned to their original coffers.

When the party is satisfied with the number of supplies retrieved, talk to the NPC and confirm to spawn the {p:Rune of Release}.
* Once the {p:Rune of Release} is spawned, the NPC will not accept any more supplies.
* It takes about 5 seconds for the Rune of Release to spawn, so make sure not to leave the confirmation process too late.

The base AP rewarded for this assault is 800 plus 66 points per supply retrieved, for a maximum of 1333 with all 8 coffers retrieved.
=2 Drops
|^Ancient Lockbox
|{i:Hi-Potion +2|Hi-Potion +2|4118}
|{i:Hi-Potion Tank|Hi-Potion Tank|13688}
|{i:Reraiser|Reraiser|4172}

|^??? Box
|{i:Date|Date|5566}
|{i:Eggplant|Eggplant|4388}
|{i:Imperial Tea Leaves|Im. Tea Leaves|2156}
|{i:Lamian Armlet|Lamian Armlet|2167}
|{i:Mamool Ja Collar|Mamool Ja Collar|2227}
|{i:Sage|Sage|638}
|{i:Toolbag (Kawahori-Ogi)|Toolbag (Kawa)|5310}
|{i:Toolbag (Mizu-Deppo)|Toolbag (Mizu)|5313}
|{i:Sage|Sage|638}
|{i:Wamoura Cloth|Wamoura Cloth|2289}
|{i:Wild Onion|Wild Onion|4387}

|^??? Polearm
|{p:Spark Spear}

|^??? Sword
|{i:Gust Claymore|Gust Claymore|18366}
|{p:Kagiroi}
|{i:Pealing Anelace|Pealing Anelace|17703}
|**{p:Storm Scimitar}**
|{p:Uchigatana +1}

=2 Map
!Breakingmorale.gif|right|Assault Map
]=],
}
