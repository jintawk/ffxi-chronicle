-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Demolition_Duty). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Demolition Duty',
    title = 'Demolition Duty',
    source = 'https://www.bg-wiki.com/ffxi/Demolition_Duty',
    images = {'Ilrusi Atoll.jpg', 'DemolitionDuty.png'},
    meta_order = {'Name', 'Staging Point', 'Starting NPC', 'Assault Rank', 'Objective', 'Mission Orders', 'Time Limit', 'Recommended Lv.', 'Assault Points'},
    meta = {
        ['Name'] = 'Demolition Duty',
        ['Staging Point'] = '{p:Ilrusi Atoll}',
        ['Starting NPC'] = '{n:Bhoy Yhupplo} in {z:Aht Urhgan Whitegate} (L-9/L-10)',
        ['Assault Rank'] = '{p:Lance Corporal}',
        ['Objective'] = 'A confidential report states that corsairs are secretly collecting the remains of shipwrecks on the Ilrusi Atoll. Use the automaton issued to you by the on-site engineer to demolish these shipwrecks.',
        ['Mission Orders'] = 'Demolish the shipwrecks',
        ['Time Limit'] = '30 minutes',
        ['Recommended Lv.'] = 'Lvl. 50',
        ['Assault Points'] = '1 Member: __1000{br}__2 Members: __1000{br}__3 Members: __1000{br}__4 Members: __900{br}__5 Members: __800{br}__6 Members: __700__'
    },
    body = [=[
!Ilrusi Atoll.jpg|right|Ilrusi Atoll
=2 Enemies
|^Level|Name|Zone|Aggro|Link|Drops|Steal|Spawns
|?|{m:Carrion Crab}|{p:Ilrusi Atoll}|Sound|No||None|
|T|{p:Imp}|{p:Ilrusi Atoll}|Yes|No|None|None|10

=3 Notes
* Crabs will always have hate on the automaton.

=2 Walkthrough
The goal of this assault is to use an Automaton to destroy shipwrecks scattered about the area.
* There are five ship wrecks. See the map for more details.
* To be assigned an automaton, talk to the starting NPC.
** The party can only have one automaton.
** The person who talks to the starting NPC will be designated the automaton's master.
* The automaton will follow its master around until it finds wreckage to demolish.
* Only the automaton can attack the wreckage. However, you can use AoE abilities and spells on targets near adjacent wreckage to cause damage to the wreckage.
* Each time the automaton uses a weaponskill on a wreckage, a {m:Carrion Crab} will spawn and attack the automaton.
** The crab cannot be distracted from the automaton. However, the automaton can be cured and crabs only have about 2000 hp.
* If the automaton is killed or despawns due to its master dying, a new one can be obtained by talking to the start NPC again.
* If the automaton is damaged, the party can opt to repair the automaton at the start NPC.
* After the wreckages are demolished, talk to the starting NPC to spawn the {p:Rune of Release}

* Fastest way to complete is to just pull imps and do AOE damage such as -ga or -ja spells. Don't even need the automation alive but you do need to talk to the starter NPC first to start the assault which gives you a free one anyway.

=2 Drops
|^Ancient Lockbox
|{i:Hi-Potion +3|Hi-Potion +3|4119}
|{i:Remedy|Remedy|4155}

|^??? Box
|{i:Betta|Betta|5139}
|{i:Distilled Water|Distilled Water|4509}
|{i:Rusty Bucket|Rusty Bucket|90}
|{i:Qutrub Gorget|Qutrub Gorget|2165}
|{i:Willow Fishing Rod|Willow Fish. Rod|17391}

|^??? Sash
|{i:Czar's Belt|Czar's Belt|15868}
|{i:Lugworm Belt|Lugworm Belt|15453}
|{i:Silver Obi +1|Silver Obi +1|13224}
|**{i:Storm Sash|Storm Sash|15883}**
|{i:Sultan's Belt|Sultan's Belt|15867}
|{i:Talisman Obi|Talisman Obi|15881}

=2 Map
!DemolitionDuty.png|right|Assault Map
]=],
}
