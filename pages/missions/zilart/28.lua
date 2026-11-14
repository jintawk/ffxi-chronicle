-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Zilart_Mission_16). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Zilart Mission 16',
    title = 'The Celestial Nexus',
    source = 'https://www.bg-wiki.com/ffxi/Zilart_Mission_16',
    images = {'The Shrine of Ru\'Avitau-map1.jpg'},
    meta_order = {'Name', 'Series', 'Starting NPC', 'Title', 'Repeatable', 'Description', 'Previous Mission', 'Next Mission', 'Rewards'},
    meta = {
        ['Name'] = 'The Celestial Nexus',
        ['Series'] = 'Rise of the Zilart',
        ['Starting NPC'] = 'None',
        ['Title'] = 'Burier of the Illusion',
        ['Repeatable'] = '__No__',
        ['Description'] = 'The fate of Vana\'diel awaits you in the {z:Celestial Nexus}!',
        ['Previous Mission'] = '{M:The Sealed Shrine|Zilart Mission 15|The Sealed Shrine}',
        ['Next Mission'] = '{M:Awakening|Zilart Mission 17|Awakening}',
        ['Rewards'] = 'None'
    },
    body = [=[
=2 Walkthrough
* {z:The Shrine of Ru'Avitau} is full of magic aggro, so even mages should bring along {i:Silent Oil|Silent Oil|4165} and {i:Prism Powder|Prism Powder|4164}.
** Note that {s:Ninjutsu} and {p:Spectral Jig} are also options for applying {p:Sneak (Status)} and {p:Invisible (Status)} without potentially aggroing nearby enemies.

* You may want to enter {z:The Shrine of Ru'Avitau} via entrance A at (H-8) in {z:Ru'Aun Gardens}. From there, take the path East and then North to a room with two Monoliths at (H-10). Make sure the East Monolith is active to open the yellow doors in the zone. Once verified, continue to the next step.
* Go to (I-6) in {z:Ru'Aun Gardens} and enter the Shrine. You'll be on Map 1. Sneak and head south. Go past (J-7) through the first yellow door. Go west from here, to the room with 2 Monoliths in (H-7). You'll need Invisible, then go south around the square hallway filled with {m:Aura Statue} to another room with 2 {m:Dark Elementals|Dark Elemental} around (H-10).
* Go north, down a flight of stairs to the {z:Celestial Nexus} at (H-9).
* Gather together and get ready for the last BC of the expansion. You'll be fighting {n:Eald'narche}, who has two forms.

!The Shrine of Ru'Avitau-map1.jpg||Ru'Avitau
=2 Boss Fight
* Upon clearing the BC, you'll receive a final cutscene and be returned to the {z:Hall of the Gods}.

[Area
{z:Celestial Nexus}
>Enemy
{n:Eald'narche} - First Form
>Abilities
* {m:Exoplate}:
** **Gaea Stream:** Single target damage __(verification needed)__ (~200). Absorbed by {p:Utsusemi}.
** **Uranos Cascade:** AoE physical damage (~200-400). Absorbed by {p:Utsusemi}.
** **Cronos Sling:** Cone attack physical damage (~300-600). Absorbed by {p:Utsusemi}.
** **Phase Shift:** AoE (large area) physical damage (~600-1300), Additional effect of {p:Stun|Stun (Status)} and/or {p:Bind|Bind (Status)}. Absorbed by {p:Utsusemi}.
*** Used at around 66%, 33% and 1-2% HP. It gets progressively more powerful.
*** At 1% the {m:Exoplates|Exoplate} will **not** die until they **Phase Shift**. It is possible to go below 66 and 33% before **Phase Shift**
* {n:Eald'narche}:
** {n:Eald'narche} uses ancient magic and will cast {s:Sleepga II}. Low HP (~2,000) will end him fairly quickly, however.

>Notes
* There will be 2 {m:Orbitals|Orbital}, which have very little HP. They will be resummoned if killed. They heavily resist {p:Lullaby}, but {s:Sleep} is reliable.
* {m:Exoplates|Exoplate} surround {n:Eald'narche} and have about 10,000 HP. It does not melee.
* Go all out, and defeat the Exoplates as quick as possible. You'll want to keep mages far out of range for Phase Shift. When it appears time for a Phase Shift, try to get everyone healed to full and get shadows back up. This will negate most, if not all, damage.
* If you wipe, wait until you are ejected, as you'll aggro anywhere on the battlefield.

----
{z:Celestial Nexus}
>Enemy
{n:Eald'narche} - Second Form
>Abilities
* **Vortex:** Medium-range AoE, low damage (~100), with an additional effect of {p:Terror} and {s:Bind}. Absorbed by {p:Utsusemi}.
* **Stellar Burst:** AoE, low damage (~100), with an additional effect of {p:Silence}. Absorbed by {p:Utsusemi}.
* **Omega Javelin:** Single target damage (~150), with an additional effect of {p:Petrification}. Absorbed by {p:Utsusemi}.

>Notes
* The second form is against {n:Eald'narche} only. He will teleport around like {m:Ark Angel TT} and cast various Black Magic spells, including Bindga.
* He still has relatively low HP (~2,500), but may or may not have a large defense and magic defense boost.
* You have 1 minute before he aggro's, regardless of your range from him.
* It has been observed that he may be heavily resistant to magic, however, a Tarutaru BLM/NIN was seen doing all of the damage to this form, ending the fight in 3 spells.
* He has very fast melee speed, but not quite the speed of Hundred Fists.
* {p:Poison Potions|Poison Potion} and {s:Stun} can make the second form a lot easier.

]
]=],
}
