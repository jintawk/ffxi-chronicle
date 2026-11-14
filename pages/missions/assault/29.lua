-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Operation:_Black_Pearl). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Operation: Black Pearl',
    title = 'Operation: Black Pearl',
    source = 'https://www.bg-wiki.com/ffxi/Operation:_Black_Pearl',
    images = {'Lebros Cavern.jpg', 'Lebros CavernT1T9.jpg'},
    meta_order = {'Name', 'Staging Point', 'Starting NPC', 'Assault Rank', 'Objective', 'Mission Orders', 'Time Limit', 'Recommended Lv.', 'Assault Points'},
    meta = {
        ['Name'] = 'Operation: Black Pearl',
        ['Staging Point'] = '{p:Lebros Cavern}',
        ['Starting NPC'] = '{n:Famad} in {z:Aht Urhgan Whitegate} (L-9/L-10)',
        ['Assault Rank'] = '{p:Second Lieutenant}',
        ['Objective'] = 'A ship carrying Princess Kadjaya of the Imperial family back from a diplomatic mission to the West has run aground near the Lebros Cavern. You are to find the survivors and escort them to safety.',
        ['Mission Orders'] = 'Rescue Princess Kadjaya',
        ['Time Limit'] = '30 minutes',
        ['Recommended Lv.'] = 'Lvl. 70',
        ['Assault Points'] = '1 Member: __####{br}__2 Members: __####{br}__3 Members: __####{br}__4 Members: __####{br}__5 Members: __####{br}__6 Members: __####__'
    },
    body = [=[
!Lebros Cavern.jpg|right|Lebros Cavern
=2 Enemies
|^Level|Name|Zone|Aggro|Link|Drops|Steal|Spawns
|Easy Prey|{m:Crimson Eruca}|{p:Lebros Cavern}|Yes|Yes|None|None|20
|Tough|{m:Jorporbor the Hellraker} ({p:DRK})|{p:Lebros Cavern}|Yes|Yes|None|None|1
|Even Match|{m:Troll Combatant} ({p:MNK})|{p:Lebros Cavern}|Yes|Yes|None|None|4
|Easy Prey|Vulcanian Bomb|{p:Lebros Cavern}|Yes|Yes|None|None|20
|Easy Prey|{p:Wamouracampa}|{p:Lebros Cavern}|Yes|Yes|None|None|20

=3 Notes
* Except for the Trolls (around 4-5k HP), the monsters in this assault have extremely low HP (~300) and can be killed using AoE weaponskills.
* The Vulcanian Bombs can cast {s:Flare}.
* The Troll Combatants are sleepable, and the next wave will not spawn until it is defeated. It is possible to keep one slept and then only have to deal with one wave at a time.

=2 Walkthrough
The objective of this assault is to prevent the NPCs {n:Princess Kadjaya|Kadjaya} and her escort, {n:Whyjham}, from taking even a single hit before the Troll NM {m:Jorporbor the Hellraker} is defeated.
* If Princess Kadjaya is attacked, the mission automatically fails.

* Two waves of monsters will slowly approach the center from the three tunnels leading from the center area.
** The pattern of monsters is the same for each wave: {p:Wamouracampa} x5, followed by {m:Crimson Eruca} x5, followed by Vulcanian Bomb x5, followed by {m:Troll Combatant} x1.
** At the end of each wave of monsters is a single even-match {m:Troll Combatant}. The Troll has higher HP and is more dangerous than the other monsters.
** It is possible for both waves of monsters to approach from the same tunnel.
*** Monsters that would normally link with each other will not if they are part of different waves in the same tunnel.

* When a {m:Troll Combatant} is killed, a new wave will immediately spawn.
* An easy way to win solo is to kill all of the enemies of the first wave except for the troll, which you will kite around. You can then go snipe the troll of each single wave (clearing the whole wave) until the NM pops.

* The three tunnels leading to the center where Princess Kadjaya stands are guarded by NPCs: {n:Yanshaal}, {n:Djahama}, and {n:Kudjreel}.
** The NPCs guarding the tunnel entrances will warn you of monsters approaching from their respective tunnels.
** If monsters reach the guard, he will be defeated in a single hit, and can no longer warn of approaching monsters in his tunnel.
** The number of remaining guards at the end of the assault affects the amount of AP awarded.

* Jorporbor the Hellraker will remain hidden until several sets of waves of monsters have been defeated.
** Waves of other monsters will continue to approach Princess Kadjaya after Jorporbor the Hellraker has attacked.

The mission is won once Jorporbor the Hellraker is defeated. Any remaining monsters will disappear and the {p:Rune of Release} will appear at Princess Kadjaya.
=2 Drops
|^Ancient Lockbox
|{i:Hi-Ether Tank|Hi-Ether Tank|13689}
|{i:Hi-Potion +3|Hi-Potion +3|4119}
|{i:Hi-Potion Tank|Hi-Potion Tank|13688}
|{i:Hi-Ether Tank|Hi-Ether Tank|13689}

|^??? Box
|{i:Copper Ore|Copper Ore|640}

|^??? Earring
|**{i:Epsilon Earring|Epsilon Earring|15987}**
|{i:Beetle Earring|Beetle Earring|13323}
|{i:Shell Earring|Shell Earring|13313}

|^??? Sash
|**{i:Lambda Sash|Lambda Sash|15902}**
|{i:Lugworm Belt|Lugworm Belt|15453}
|{i:Silver Obi +1|Silver Obi +1|13224}
|{i:Talisman Obi|Talisman Obi|15881}

=2 Map
!Lebros CavernT1T9.jpg|right|Assault Map
]=],
}
