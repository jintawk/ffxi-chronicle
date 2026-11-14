-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Wake_the_Puppet). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Wake the Puppet',
    title = 'Wake the Puppet',
    source = 'https://www.bg-wiki.com/ffxi/Wake_the_Puppet',
    images = {'Periqia.jpg', 'Periqia-T3T5T9.jpg'},
    meta_order = {'Name', 'Staging Point', 'Starting NPC', 'Assault Rank', 'Objective', 'Mission Orders', 'Time Limit', 'Recommended Lv.', 'Assault Points'},
    meta = {
        ['Name'] = 'Wake the Puppet',
        ['Staging Point'] = '{p:Periqia}',
        ['Starting NPC'] = '{n:Lageegee} in {z:Aht Urhgan Whitegate} (L-9/L-10)',
        ['Assault Rank'] = '{p:Second Lieutenant}',
        ['Objective'] = 'During a previous mission to eradicate the Undead Swarm presence from Periqia, the Imperial forces were forced to abandon several Mark-II automatons upon their retreat. You are to infiltrate the area, locate the machines, and aid in their return to Al Zahbi.',
        ['Mission Orders'] = 'Retrieve the Mark-IIs',
        ['Time Limit'] = '30 minutes',
        ['Recommended Lv.'] = 'Lvl. 70',
        ['Assault Points'] = '1 Member: __1200{br}__2 Members: __1200{br}__3 Members: __1200{br}__4 Members: __1080{br}__5 Members: __960{br}__6 Members: __840__'
    },
    body = [=[
!Periqia.jpg|right|Periqia
=2 Enemies
|^Level|Name|Zone|Aggro|Link|Drops|Steal|Spawns
|EP|{m:Wight}|{p:Periqia}|Yes|No||None|

=3 Notes
* {m:Wights|Wight} are too low of level to aggro max-level players, unless players rest nearby.
* {m:Wights|Wight} will aggro puppet NPCs.
* As long as you have the most enmity, you may have the puppets engage on an enemy and run them back to the start for an easy win.

=2 Walkthrough
In order to complete this mission, return at least 4 puppets to the starting NPC, {n:Adeeha}.
* Puppets spawn in the 4 dead end rooms at (H-6), (F-8), (J-8), (H-10).
** 2 puppets will spawn in each of 3 rooms; the 4th room will be empty.
* The area is initially empty of {m:Wights|Wight}; they will only spawn when a puppet is active.
* When a puppet is located, it can be activated by emoting **/salute**, targeting the puppet. The puppet will then treat the player as its master.
** A player may only be master of one puppet at a time.
** A puppet may only have one master at a time.
** Emotes must be performed within **10'** of the puppet. They can be done as motions to reduce chat spam (e.g. "/clap motion").
** After activating a puppet, you don't have to target it for the emote to work.
* By emoting **/clap** while near the puppet, the master can instruct the puppet to move to where the master is standing.
* By emoting **/goodbye**, the puppet will be deactivated and the player is no longer its master.
** If the puppet is deactivated close to the starting NPC, the puppet's name will turn green and the puppet is considered "returned".
* By emoting **/hurray** while near the puppet, the master can instruct the puppet to enter combat mode.
** While in combat mode, the puppet will automatically engage a nearby target.
** While in combat mode, the puppet will ignore all other commands until its target is defeated and it returns to normal operation.
* Occasionally, the puppet will stop responding to all commands and will repeatedly display an emotion. To return the puppet to normal operation, the master must respond with another emote.

\**__Emotion**__ ==> **__Response**__
Blushing ==> /doze
Bowing ==> /kneel
Cheering ==> /psych
Confused ==> /slap
Clapping ==> /angry
Dancing ==> /joy
Happy ==> /smile
Pointing ==> /no
Praising ==> /blush
Saluting => /praise
Shocked ==> /comfort
Waving ==> /welcome
:* The puppet will never enter this mode if it is engaged in combat.
:* A good strategy to beat this assault easily is to let the puppet fight a {m:Wight}. After the puppet engages, pull the Wight to the starting NPC; the puppet will follow quickly without stopping to emote. Defeat the {m:Wight} and quickly /goodbye to capture the puppet.
:** You can use /clap and move your character before the motion plays to cancel the animation lock induced. With a maximum distance of 9.9' from the puppet it is possible, though takes significantly longer, to finish solo without engaging the puppet in combat. Therefore, combat is not a must while solo and only serves to ensure completion with time to spare.

* After 4 puppets are returned to the NPC, the {p:Rune of Release} will spawn.
** Returning additional puppets (up to 6) will increase the points rewarded when the {p:Rune of Release} is activated.

* The full list of automaton names are:
** {n:Maymun 09}
** {n:Maymun 21}
** {n:Maymun 27}
** {n:Maymun 33}
** {n:Maymun 53}
** {n:Maymun 74}

=2 Drops
|^Ancient Lockbox
|{i:Hi-Potion +3|Hi-Potion +3|4119}

|^??? Box
|{i:Bone Chip|Bone Chip|880}
|{i:Karakul Cloth|Karakul Cloth|2288}
|{i:Qiqirn Sandbag|Qiqirn Sandbag|2153}
|{i:Rotten Quiver|Rotten Quiver|4196}
|{i:Scorpion Quiver|Scorpion Quiver|4223}

|^??? Earring
|{i:Beetle Earring|Beetle Earring|13323}
|**{i:Beta Earring|Beta Earring|15988}**
|{i:Silver Earring|Silver Earring|13327}

|^??? Sash
|{i:Silver Obi +1|Silver Obi +1|13224}
|{i:Talisman Obi|Talisman Obi|15881}
|**{i:Zeta Sash|Zeta Sash|15901}**

=2 Map
!Periqia-T3T5T9.jpg|right|Assault Map
]=],
}
