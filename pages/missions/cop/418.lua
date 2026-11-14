-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Promathia_Mission_4-2). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Promathia Mission 4-2',
    title = 'The Savage',
    source = 'https://www.bg-wiki.com/ffxi/Promathia_Mission_4-2',
    images = {'Riverne - Site B01-map.jpg'},
    meta_order = {'Name', 'Series', 'Starting NPC', 'Title', 'Repeatable', 'Description', 'Previous Mission', 'Next Mission', 'Rewards'},
    meta = {
        ['Name'] = 'The Savage',
        ['Series'] = 'Chains of Promathia',
        ['Starting NPC'] = 'Spacial Displacement, {z:Misareaux Coast} - (D-6)',
        ['Title'] = 'Mist Melter (defeating {m:Ouryu}){br} Nag\'molada\'s Underling (Mission Completion)',
        ['Repeatable'] = '__No__',
        ['Description'] = '{p:Ulmia} is determined to know the truth, and is ready to revisit {p:Bahamut} to learn it. Enlist the aid of {p:Tenzen} and {n:Justinius} to help you find Ulmia before something terrible occurs.',
        ['Previous Mission'] = '{M:Sheltering Doubt|Promathia Mission 4-1|Sheltering Doubt}',
        ['Next Mission'] = '{M:The Secrets of Worship|Promathia Mission 4-3|The Secrets of Worship}',
        ['Rewards'] = 'Access to {z:Sacrarium} (after examining the **Walnut door** to kick-off the next mission){br} {q:Uninvited Guests|Uninvited Guests|Uninvited Guests} Quest unlocked'
    },
    body = [=[
\**{c=red:Note:}** With the lifting of the level cap in Promathia areas, this quest is now relatively trivial in difficulty. The walkthrough below was written for a level cap of 50.
=2 Walkthrough
=3 Preparation
* **(Optional)**: {n:Ferchinne} at (G-9, Map 2) in {z:Tavnazian Safehold} offers the quest {p:Fly High} where two {@i:Hippogryph Tf.|1690} {i:Hippogryph Tailfeathers|Hippogryph Tf.|1690} can be exchanged for one {@i:Mistmelt|5265} {i:Mistmelt|Mistmelt|5265}. This quest is entirely optional but highly recommended for the {m:Ouryu} battle.
** High levels and ranged damage and/or healing can negate the need for this.

[Useful Items to bring:
For canceling {m:Ouryu}'s flight:
* {@i:Mistmelt|5265} {i:Mistmelts|Mistmelt|5265}

For sneaking past mobs:
* {@i:Silent Oil|4165} {i:Silent Oil|Silent Oil|4165}
* {@i:Prism Powder|4164} {i:Prism Powder|Prism Powder|4164}

For self healing (or bring trusts):
* {@i:Hi-Ether|4132} Potions and Ethers
* {@i:Reraiser|4172} Reraise items
* {@i:Yagudo Drink|4558} MP and HP Regen drinks.

]
----
!Riverne - Site B01-map.jpg|right|Site B01
* Head to the **Dilapidated Gate** at {z:Misareaux Coast} (F-7) for a cutscene.
** You will be transported to {p:Riverne - Site B01} after it ends.
*** Unity level 122 / 128 nm will teleport you right at the gate.
* Take the following path to reach {z:Monarch Linn}:
** This is a different part of {z:Monarch Linn} than you were at in {M:Promathia Mission 2-5|Promathia Mission 2-5|Ancient Vows}, so you cannot use the {p:Home Point} you previously ran across in {p:Riverne - Site A01}.
* Head southwest to the **Spatial Displacement**.
** If you haven't done so beforehand, you will need to farm one {@i:Giant Scale|1691} {i:Giant Scale|Giant Scale|1691} by killing some of the {p:wyverns|Category:Wyvern} in this area.
*** {m:Pyrodrake} are level 50-53, {m:Ignidrake} and Morbol are level 57.
** {p:Sneak|Sneak (Status)} up to avoid the {p:morbol|Category:Morbol} monsters and {p:Invisible|Invisible (Status)} for {p:bombs|Category:Bomb} and wyverns. Avoid walking in front of the true sight {p:Hippogryphs|Category:Hippogryph}.
* Head west-northwest until you reach the **Unstable Displacement** at (G-8).
** When your party is ready, trade the {i:Giant Scale|Giant Scale|1691} to the displacement and pass through.
* Head northwest to the next **Spatial Displacement**, and then south to the one after that. This will put you in the uncapped area {z:Monarch Linn}.
** As with the previous missions, use this time to rest, and go over strategies.
* When your party is ready, check the **Spatial Displacement** and choose the battlefield "The Savage". Buffs and trusts will wear when entering, so do so inside the battlefield.
** **{c=red:Warning:}**{c=red: }Without {@i:Mistmelt|5265} {i:Mistmelts|Mistmelt|5265} the boss will spend most of the fight flying outside melee reach, greatly drawing out the battle and potentially whittling down melee players (even at level 99), while giving them little chance to fight back. As melee attacks can not hit during flight.
*** A lone healing trust is likely sufficient to survive this at high levels, while ranged or magic damage trusts should help speed up the fight.
* After defeating {m:Ouryu}, speak with {n:Justinius} in {z:Tavnazian Safehold} (J-6) on Map 1 (Home Point #3) to complete the mission.

=2 Boss Fight
[Area Name
{z:Monarch Linn}
>Boss Name
{m:Ouryu}
>Abilties
* On the ground:
** **Absolute Terror:** Inflicts Terror, halting all actions until it wears.
** **Geotic Breath:** Cone Attack dealing Earth damage.
** **Horrid Roar:** Single target attack with a Dispel effect removing up to 15 buffs, including food. Also resets enmity.
** **Spike Flail:** Area attack dealing physical damage. Used only if someone behind it has hate. Absorbed by shadow images.
** **Typhoon Wing:** Frontal area attack dealing physical damage and inflicting Blindness.
* In the air:
** **Bai Wing:** Area attack dealing Earth damage and inflicting Slow.
** **Ochre Blast:** Area attack dealing Earth damage.
** **Touchdown:** Area attack dealing magical damage. Used when landing if a {i:Mistmelt|Mistmelt|5265} was not used.
* {@g:Element: Earth|Earth} **Magic:** {p:Slowga}, {s:Stoneskin}, {s:Stonega II}

>Notes
* Upon entry she will have {s:Stoneskin} on so {s:Dispel} it if you can.
* She uses {p:Invincible} at couple intervals throughout the fight.
* Using a {i:Mistmelt|Mistmelt|5265} while she is in the air will bring her down again so use them accordingly.
* The best idea is to keep her on the ground where she is more manageable. She can be slept when on the ground to recover {p:MP} and {p:HP} if need be.
* If Mistmelts are not used, she will alternate flying for 2 minutes, followed by 2 minutes on the ground.
* After you get her to about 30% HP, the fight will end.

]
=2 Optional
* {q:Go! Go! Gobmuffin!|Go! Go! Gobmuffin!|Go! Go! Gobmuffin!} is available in Tavnazian Safehold after entering {p:Cape Riverne - Geological Site #B01|Riverne - Site B01}. (Level 50+)
* {p:Fly High} is available in Tavnazian Safehold after entering {p:Cape Riverne - Geological Site #B01|Riverne - Site B01}. (Level 50+)
* {q:Uninvited Guests|Uninvited Guests|Uninvited Guests} is available in Tavnazian Safehold after entering {p:Cape Riverne - Geological Site #B01|Riverne - Site B01}. (Level 90+)
* {q:A Hard Day's Knight|A Hard Day's Knight|A Hard Day's Knight} is available in Tavnazian Safehold after completing this mission. (Level 50+)
* {p:ENMs|ENM} are available in Riverne - Site B01. See {n:Morangeart} for key items.

]=],
}
