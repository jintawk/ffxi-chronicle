-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Inside_the_Belly). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Inside the Belly',
    title = 'Inside the Belly',
    source = 'https://www.bg-wiki.com/ffxi/Inside_the_Belly',
    images = {},
    meta_order = {'Name', 'Required Fame', 'Level Restriction', 'Starting NPC', 'Pack', 'Title', 'Repeatable', 'Description', 'Previous Quest', 'Next Quest', 'Requirements', 'Rewards'},
    meta = {
        ['Name'] = 'Inside the Belly',
        ['Required Fame'] = '{p:Other|Category:Other Quests} Fame Level: __Unknown__',
        ['Level Restriction'] = 'None',
        ['Starting NPC'] = '{n:Zaldon}, {z:Selbina} - (H-9)',
        ['Pack'] = 'None',
        ['Title'] = 'Multiple, see table below.',
        ['Repeatable'] = '__Yes__',
        ['Description'] = 'Some fish in Vana\'diel like to eat shiny objects. If you catch one, let Zaldon cut it open for you.',
        ['Previous Quest'] = '{q:The Real Gift|The Real Gift|The Real Gift}',
        ['Next Quest'] = '{q:Brigand\'s Chart|Brigand\'s Chart (Quest)|Brigand\'s Chart}',
        ['Requirements'] = 'Level 30+ {p:Fishing} skill. {br}You can use {p:gear|Category:Fishing} and {n:Advanced Synthesis Image Support} to help hit level 30.{br} Varies (see below)',
        ['Rewards'] = '{p:Gil}, see the tables below.{br} Potentially an item, see the tables below.'
    },
    body = [=[
=2 Walkthrough
* Have 30 fishing skill or greater, including temporary boosts from {p:either gear or image support|Category:Fishing}, and talk to {n:Zaldon}.
** The latent effect of {i:Trainee's spectacles|Trainee's Specs.|11499} has also been confirmed to count toward the 30 skill requirement.
** Once you've flagged the quest by talking to Zaldon with adequate fishing skill and {q:The Real Gift|The Real Gift|The Real Gift} completed, you will be able to complete the quest for the first time even if you're under 30, as well as for subsequent turn-ins.
** Zaldon will change his dialogue dynamically whether or not you have 30+ skill (telling you to talk to {n:Gabwaleid} if you have 29 or lower), but will still accept fish as long as you've flagged the quest.
* Trade {n:Zaldon} certain fish and he will gut them for you.
* He will buy the fish that you trade for a fixed price, as well as give you anything that might be in its stomach.
* As of the {p:November 10th, 2021 Version Update|https://forum.square-enix.com/ffxi/threads/58770}, the chance to receive an item is increased when a bigger fish is traded. Fish size is noted on each fish when looking at it in your inventory.

* **{c=red:Note:}** After completing the quest for the first time, you no longer need to meet the fishing level requirement to repeat the quest.

|^~r2~Fish|~c4~Rewards|~r2~Comment
|^Gil|Item|Probability|Title
|~h~{i:Giant Catfish|Giant Catfish|4469}|50|{@i:Earth Wand|17076} {p:Earth Wand}|**{p:R|Rare (5%)}**|Cordon Bleu Fisher|
|~h~{i:Dark Bass|Dark Bass|4428}|10|{@i:Green Rock|772} {i:Green Rock|Green Rock|772}|**{p:R|Rare (5%)}**||
|~h~{i:Ogre Eel|Ogre Eel|4481}|16|{@i:Turquoise Ring|13480} {i:Turquoise Ring|Turquoise Ring|13480}|**{p:R|Rare (5%)}**|Cordon Bleu Fisher|
|~h~{i:Zafmlug Bass|Zafmlug Bass|4385}|15|{@i:Blue Rock|770} {i:Blue Rock|Blue Rock|770}|**{p:R|Rare (5%)}**||
|~h~{i:Giant Donko|Giant Donko|4306}|96|{@i:Bkn. Halcyon Rod|1833} {i:Broken Halcyon Rod}|**{p:R|Rare (5%)}**||
|~h~{i:Bhefhel Marlin|Bhefhel Marlin|4479}|150|{@i:Pirate's Chart|1874} {i:Pirate's Chart|Pirate's Chart|1874} {br}{@i:Brigand's Chart|1873} {i:Brigand's Chart|Brigand's Chart|1873}|**{p:R|Rare (5%)}** {br}**{p:VR|Very Rare (1%)}**||
|~h~{i:Silver Shark|Silver Shark|4451}|250|{@i:Trident|16837} {p:Trident}|**{p:VR|Very Rare (1%)}**|Ace Angler|
|~h~{i:Jungle Catfish|Jungle Catfish|4307}|300|{@i:Bkn. Hume Rod|1832} {i:Broken Hume Rod}|**{p:R|Rare (5%)}**||
|~h~{i:Emperor Fish|Emperor Fish|4454}|300|{@i:Cuir Highboots|12955} {i:Cuir Highboots|Cuir Highboots|12955}|**{p:VR|Very Rare (1%)}**|Ace Angler|
|~h~{i:Titanictus|Titanictus|4476}|350|{@i:Ancient Sword|16533} {p:Ancient Sword}|**{p:VR|Very Rare (1%)}**|Lu Shang-like Fisher King|
|~h~{i:Takitaro|Takitaro|4463}|350|{@i:Phil. Stone|942} {i:Philosopher's Stone|Philosopher's Stone|942}|**{p:VR|Very Rare (1%)}**||
|~h~{i:Giant Chirai|Giant Chirai|4308}|550|{@i:Twinthread|1278} {i:Twinthread|Twinthread|1278}|**{p:VR|Very Rare (1%)}**||
|~h~{i:Ryugu Titan|Ryugu Titan|4305}|800|{@i:Mercurial Sword|18377} {p:Mercurial Sword}|**{p:VR|Very Rare (1%)}**||
|~h~{i:Tricorn|Tricorn|4319}|810|{@i:Darksteel Ore|645} {i:Darksteel Ore|Darksteel Ore|645}|**{p:R|Rare (5%)}**||
|~h~{i:Sea Zombie|Sea Zombie|4475}|350|{@i:Drill Calamary|17006} {p:Drill Calamary}|**{p:C|Common (15%)}**||Was **{p:U|Uncommon (10%)}** before 6/25/15 update
|~h~{i:Cave Cherax|Cave Cherax|4309}|800|{@i:Dwarf Pugil|17007} {p:Dwarf Pugil}|**{p:C|Common (15%)}**||Was **{p:U|Uncommon (10%)}** before 6/25/15 update
|~h~{i:Lik|Lik|5129}|880|{@i:Opal Silk|1826} {i:Opal Silk|Opal Silk|1826}|**{p:UR|Ultra Rare (0.1%)}**||
|~h~{i:Gugrusaurus|Gugrusaurus|5127}|880|{@i:Saber Shoot|1837} {i:Saber Shoot|Saber Shoot|1837}|**{p:UR|Ultra Rare (0.1%)}**||
|~hc6~Added in the November 11th, 2009 Version Update
|~h~{i:Bladefish|Bladefish|4471}|200|{@i:Robber Rig|17002} {i:Robber Rig|Robber Rig|17002}|**{p:R|Rare (5%)}**||
|~h~{i:Gavial Fish|Gavial Fish|4477}|250|{@i:Drone Earring|13361} {i:Drone Earring|Drone Earring|13361}|**{p:R|Rare (5%)}**||
|~h~{i:Veydal Wrasse|Veydal Wrasse|5141}|225|{@i:Seashell|888} {i:Seashell|Seashell|888} {br}{@i:Nebimonite|4361} {i:Nebimonite|Nebimonite|4361}|**{p:U|Uncommon (10%)}** {br}**{p:U|Uncommon (10%)}**||
|~h~{i:Morinabaligi|Morinabaligi|5462}|300|{@i:Cuir Gloves|12699} {i:Cuir Gloves|Cuir Gloves|12699}|**{p:U|Uncommon (10%)}**||
|~h~{i:Turnabaligi|Turnabaligi|5137}|340|{@i:Water Ore|1260} {i:Water Ore|Water Ore|1260} {br}{@i:Dark Ore|1262} {i:Dark Ore|Dark Ore|1262} {br}{@i:Ice Ore|1256} {i:Ice Ore|Ice Ore|1256}|**{p:VR|Very Rare (1%)}** {br}**{p:VR|Very Rare (1%)}** {br}**{p:VR|Very Rare (1%)}**||
|~h~{i:Kalkanbaligi|Kalkanbaligi|5140}|390|{@i:Flat Shield|16184} {i:Flat Shield|Flat Shield|16184}|**{p:R|Rare (5%)}**||
|~h~{i:Pterygotus|Pterygotus|5133}|390|{@i:Lapis Lazuli|795} {i:Lapis Lazuli|Lapis Lazuli|795}|**{p:R|Rare (5%)}**||
|~h~{i:Gerrothorax|Gerrothorax|5471}|423|{@i:Risky Patch|11492} {i:Risky Patch|Risky Patch|11492}|**{p:VR|Very Rare (1%)}**||
|~h~{i:Pirarucu|Pirarucu|5470}|516|{@i:Wyvern Skin|1122} {i:Wyvern Skin|Wyvern Skin|1122} {br}{@i:Peiste Skin|2523} {i:Peiste Skin|Peiste Skin|2523} {br}{@i:Wivre Horn|2426} {i:Wivre Horn|Wivre Horn|2426}|**{p:R|Rare (5%)}** {br}**{p:R|Rare (5%)}** {br}**{p:R|Rare (5%)}**||
|~h~{i:Megalodon|Megalodon|5467}|532|{@i:Mithran Fish. Rod|17380} {i:Mithran Fish. Rod|Mithran Fish. Rod|17380} {br}{@i:Bkn. Mithran Rod|483} {i:Broken Mithran Rod}|__(information needed)__ {br}**{p:R|Rare (5%)}**||
|~hc6~Added in the March 23rd, 2010 Version Update
|~h~{i:Yayinbaligi|Yayinbaligi|5463}|50|{@i:Telluric Ring|14649} {i:Telluric Ring|Telluric Ring|14649}|__(information needed)__||
|~h~{i:Lakerda|Lakerda|5450}|51|{@i:Pearl|792} {i:Pearl|Pearl|792} {br}{@i:Black Pearl|793} {p:Black Pearl}|**{p:R|Rare (5%)}** {br}**{p:R|Rare (5%)}**||
|~h~{i:Kilicbaligi|Kilicbaligi|5451}|150| {p:Rusty Greatsword}|**{p:R|Rare (5%)}**||
|~h~{i:Monke-Onke|Monke-Onke|4462}|150|{@i:Poison Dust|943} {i:Poison Dust|Poison Dust|943} x1~6|**{p:R|Rare (5%)}**||
|~h~{i:Ahtapot|Ahtapot|5455}|350|{@i:Mildewy Ingot|2886} {i:Mildewy Ingot|Mildewy Ingot|2886} {br}{@i:Decayed Ingot|2887} {i:Decayed Ingot|Decayed Ingot|2887}|**{p:U|Uncommon (10%)}** {br}**{p:R|Rare (5%)}**||
|~h~{i:Armored Pisces|Armored Pisces|4316}|475|{@i:Stolid Breastplate|13736} {i:Stolid Breastplate|Stolid Breastplate|13736}|**{p:VR|Very Rare (1%)}**||
|~h~{i:Mola Mola|Mola Mola|5134}|487|{@i:Mercurial Spear|16850} {p:Mercurial Spear}|**{p:VR|Very Rare (1%)}**||
|~hc6~Added in the September 9th, 2010 Version Update
|~h~{i:Gugru Tuna|Gugru Tuna|4480}|50|{@i:Tiny Tathlum|19186} {p:Tiny Tathlum}|**{p:R|Rare (5%)}**||
|~h~{i:Istavrit|Istavrit|5136}|50|{@i:Venom Dust|944} {i:Venom Dust|Venom Dust|944} x1~4|**{p:R|Rare (5%)}**||
|~h~{i:Gigant Octopus|Gigant Octopus|5475}|119|{@i:Black Ink|929} {i:Black Ink|Black Ink|929} x1~6|**{p:R|Rare (5%)}**||
|~h~{i:Three-eyed Fish|Three-eyed Fish|4478}|250|{@i:Paralysis Dust|945} {i:Paralysis Dust|Paralysis Dust|945} x1~12|**{p:R|Rare (5%)}**||
|~h~{i:Gigant Squid|Gigant Squid|4474}|300|{@i:Flame Shield|12317} {i:Flame Shield|Flame Shield|12317}|**{p:R|Rare (5%)}**||
|~h~{i:Rhinochimera|Rhinochimera|5135}|300|{@i:Solon Torque|11624} {i:Solon Torque|Solon Torque|11624}|**{p:R|Rare (5%)}**||
|~h~{i:Grimmonite|Grimmonite|4304}|350|{@i:Silver Ring|13456} {i:Silver Ring|Silver Ring|13456} {br}{@i:Mythril Ring|13446} {i:Mythril Ring|Mythril Ring|13446} {br}{@i:Gold Ring|13445} {i:Gold Ring|Gold Ring|13445} {br}{@i:Platinum Ring|13447} {i:Platinum Ring|Platinum Ring|13447}|**{p:R|Rare (5%)}** {br}**{p:R|Rare (5%)}** {br}**{p:R|Rare (5%)}** {br}**{p:R|Rare (5%)}**||
|~h~{i:Titanic Sawfish|Titanic Sawfish|5120}|810|{@i:Aizenkunitoshi|19290} {p:Aizenkunitoshi}|**{p:VR|Very Rare (1%)}**||
|~hc6~Added in the December 7th, 2010 Version Update
|~h~{i:Pelazoea|Pelazoea|5815}|360|{@i:Noddy Ring|11655} {i:Noddy Ring|Noddy Ring|11655}|**{p:R|Rare (5%)}**||
|~h~{i:Dorado Gar|Dorado Gar|5813}|568|{@i:Gold Ingot|745} {i:Gold Ingot|Gold Ingot|745} x1~4|**{p:R|Rare (5%)}**||
|~h~{i:Crocodilos|Crocodilos|5814}|1,763|{@i:Puffin Ring|11654} {i:Puffin Ring|Puffin Ring|11654}|**{p:R|Rare (5%)}**||
|~hc6~Added in the July 24th, 2012 Version Update
|~h~{i:Abaia|Abaia|5476}|960|{@i:Aurora Bass|5818} {i:Aurora Bass|Aurora Bass|5818} x1~3 {br}{@i:Plumb Boots|10372} {i:Plumb Boots|Plumb Boots|10372}|**{p:U|Uncommon (10%)}** {br}**{p:VR|Very Rare (1%)}**||
|~h~{i:Matsya|Matsya|5468}|12,592|{@i:Shaper's Shawl|11009} {i:Shaper's Shawl|Shaper's Shawl|11009}|**{p:VR|Very Rare (1%)}**||
|~hc6~Added in the June 25th, 2015 Version Update
|~h~{i:Kokuryu|Kokuryu|5540}|1,512|{@i:Kokuryu's Liver|9102} {i:Kokuryu's Liver|Kokuryu's Liver|9102}|**{p:C|Common (15%)}**||
|~h~{i:Soryu|Soryu|5537}|1,512|{@i:Soryu's Liver|9099} {i:Soryu's Liver|Soryu's Liver|9099}|**{p:C|Common (15%)}**||
|~h~{i:Hakuryu|Hakuryu|5539}|1,512|{@i:Hakuryu's Liver|9101} {i:Hakuryu's Liver|Hakuryu's Liver|9101}|**{p:C|Common (15%)}**||
|~h~{i:Sekiryu|Sekiryu|5538}|1,512|{@i:Sekiryu's Liver|9100} {i:Sekiryu's Liver|Sekiryu's Liver|9100}|**{p:C|Common (15%)}**||
|~hc6~Added in the November 10th, 2015 Version Update
|~h~{i:Far East Puffer|Far East Puffer|6489}|735|{@i:Stinky Subligar|25864} {i:Stinky Subligar|Stinky Subligar|25864}|**{p:R|Rare (5%)}**||Synthed into {@i:Dashing Subligar|25849} {i:Dashing Subligar|Dashing Subligar|25849}
|~hc6~Added in the November 10th, 2021 Version Update
|~h~{p:Shen|Shen (fish)}|1,280|{@i:Riftcinder|3499} {i:Riftcinder|Riftcinder|3499} {br}{@i:Riftdross|3498} {i:Riftdross|Riftdross|3498} {br}{@i:Pearl|792} {i:Pearl|Pearl|792}|**{p:VR|Very Rare (1%)}** {br}**{p:VR|Very Rare (1%)}** {br}**{p:VR|Very Rare (1%)}**||
|~h~{i:Apkallufa|Apkallufa|5534}|95|{@i:Ice Spikes (Scroll)|4858} {s:Ice Spikes}|||
|~h~{i:Yawning Catfish|Yawning Catfish|5955}|300|{@i:Seabird's Ring|26222} {i:Seabird's Ring|Seabird's Ring|26222}|||
|~h~{i:Malicious Perch|Malicious Perch|5995}|483|{@i:Patissiere's Ring|26223} {i:Patissiere's Ring|Patissiere's Ring|26223} {br}{@i:Venom Dust|944} {i:Venom Dust|Venom Dust|944}|**{p:VR|Very Rare (1%)}**||
|~h~{i:Bloodblotch|Bloodblotch|5951}|165|{@i:Confectioner's Ring|26224} {i:Confectioner's Ring|Confectioner's Ring|26224} {br}{@i:Venom Dust|944} {i:Venom Dust|Venom Dust|944}|**{p:VR|Very Rare (1%)}**||
|~h~{i:Bonefish|Bonefish|6336}|120|{@i:Skeleton Key|1115} {i:Skeleton Key|Skeleton Key|1115} x4|||
|~hc6~Added in the April 4th, 2022 Version Update
|~h~{i:Tiger Shark|Tiger Shark|5817}|285|{@i:Duck Ring|28570} {i:Duck Ring|Duck Ring|28570}|||

]=],
}
