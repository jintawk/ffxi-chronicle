-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Imperial_Agent_Rescue). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Imperial Agent Rescue',
    title = 'Imperial Agent Rescue',
    source = 'https://www.bg-wiki.com/ffxi/Imperial_Agent_Rescue',
    images = {'Mamool Ja Training Grounds.jpg', '460px-ImperialAgentRescueMap.jpg'},
    meta_order = {'Name', 'Staging Point', 'Starting NPC', 'Assault Rank', 'Objective', 'Mission Orders', 'Time Limit', 'Recommended Lv.', 'Assault Points'},
    meta = {
        ['Name'] = 'Imperial Agent Rescue',
        ['Staging Point'] = '{p:Mamool Ja Training Grounds}',
        ['Starting NPC'] = '{n:Isdebaaq} in {z:Aht Urhgan Whitegate} (L-9/L-10)',
        ['Assault Rank'] = '{p:Private Second Class}',
        ['Objective'] = 'An agent sent to spy on the secret training grounds of the Mamool Ja has been captured. Rescue him before he is interrogated for Imperial secrets.',
        ['Mission Orders'] = 'Rescue the Agent',
        ['Time Limit'] = '30 minutes',
        ['Recommended Lv.'] = 'Lvl. 60',
        ['Assault Points'] = '1 Member: __1100{br}__2 Members: __1100{br}__3 Members: __1100{br}__4 Members: __990{br}__5 Members: __880{br}__6 Members: __770__'
    },
    body = [=[
!Mamool Ja Training Grounds.jpg|right|Mamool Ja Training Grounds
=2 Enemies
|^Level|Name|Zone|Aggro|Link|Drops|Steal|Spawns
|?|{m:Mamool Ja Warder}|{p:Mamool Ja Training Grounds}|Yes|Yes||None|?
|?|{m:Mamool Ja Warder}|{p:Mamool Ja Training Grounds}|Yes|Yes||None|?
|?|{m:Mamool Ja Warder}|{p:Mamool Ja Training Grounds}|Yes|Yes||None|?

=3 Notes
There seems to be a bug with pets that prevents the gate from being broken. If you're having trouble getting the gate to break, try dismissing your pet.
=2 Walkthrough
The objective of this assault is to rescue the NPC {n:Brujeel} by tricking the Mamool Ja into breaking the impassable gates.
* There are 3 gates, as marked on the map. The NPC is trapped in a pot beyond one of the 3 gates.
* You may pull Mamool Ja from the surrounding area to attempt to break the gate.

:* The Mamool Ja come in 3 flavors: {p:WHM}, {p:BST}, and {p:NIN}.

* To break the gate, you must trick the Mamool Ja into hitting it.

:* Mamools must be facing the gate.

::* Their moves may miss the gate even when used while facing it.

:* **One** weapon throw (Axe Throw or Staff Toss) that successfully hits the gate will break the gate instantly.

::* Ninja Mamool Ja don't have a weapon-throw technique, and thus are less efficient for breaking down gates.

:* **Four** Firespits will also break it down.

* Once a gate breaks, click on the Pot Hatch to open the cage.

:* If you are lucky, {n:Brujeel} will appear after a moment, and then {p:Warp} to safety. Since __naturally you can only cast {p:Warp} if you are not trapped behind an unlocked pot hatch__.

* If the pot is empty, move on to another gate.

The {p:Rune of Release} will appear in the dead end room at (J-8) after Brujeel is __"rescued"__.
=3 Strategy
This is relatively trivial for a level 99 player to solo granted they may use regen or cure in case they have taken too much damage over the course of being hit.
* Grab a low damage/costume weapon, a few mamools, and face the gate. Don't be fooled by a solid door in the corner; the gate may be seen through.

:* Start with any Ninja mamools as they can not throw a weapon.
:* Critical hits from even 1 DMG weapons will still possibly break the weapon of a Mamool, weakening them first with magic is useful.

* Monsters use their TP moves as soon as they hit 1,000 when they reach 20% HP or less.
* Any magic damage greater than 0 will grant a monster 100 TP (E.g. {s:Dia}).

:* A blue magic spell like {s:Bludgeon} will grant 300 TP, 100 for each hit.

=2 Drops
|^Ancient Lockbox
|{i:Hi-Potion +2|Hi-Potion +2|4118}
|{i:Hi-Potion Tank|Hi-Potion Tank|13688}
|{i:Reraiser|Reraiser|4172}

|^??? Box
|{i:Eggplant|Eggplant|4388}
|{i:Imperial Tea Leaves|Im. Tea Leaves|2156}
|{i:Sage|Sage|638}
|{i:Silk Cloth|Silk Cloth|829}
|{i:Wild Onion|Wild Onion|4387}

|^??? Ring
|{i:Brass Ring|Brass Ring|13465}
|{i:Copper Ring|Copper Ring|13454}
|{i:Ether Ring|Ether Ring|13549}
|**{i:Storm Ring|Storm Ring|15774}**

=2 Map
!460px-ImperialAgentRescueMap.jpg|right|Assault Map
]=],
}
