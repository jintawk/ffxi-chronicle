-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-7-1). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Seekers of Adoulin Mission 2-7-1',
    title = 'Behind the Sluices',
    source = 'https://www.bg-wiki.com/ffxi/Seekers_of_Adoulin_Mission_2-7-1',
    images = {'Adoulin-mission-2-7-1-Rala-map.jpg'},
    meta_order = {'Name', 'Series', 'Starting NPC', 'Title', 'Repeatable', 'Description', 'Previous Mission', 'Next Mission', 'Rewards'},
    meta = {
        ['Name'] = 'Behind the Sluices',
        ['Series'] = 'Seekers of Adoulin',
        ['Starting NPC'] = 'N/A',
        ['Title'] = 'Princess\'s Partisan',
        ['Repeatable'] = '__No__',
        ['Description'] = 'Mission Orders: An antiquated sluice gate sits in the heart of the assassins\' Rala Waterways lair. According to Arciela, you should be able to operate it once you have a waterway facility crank in your possession.',
        ['Previous Mission'] = '{M:Predators and Prey|Seekers of Adoulin Mission 2-7|Predators and Prey}',
        ['Next Mission'] = '{M:The Leafkin Monarch|Seekers of Adoulin Mission 2-7-2|The Leafkin Monarch}',
        ['Rewards'] = '15k {p:Bayld} if you repeat the fight to help someone else.'
    },
    body = [=[
=2 Walkthrough
!Adoulin-mission-2-7-1-Rala-map.jpg||Rala Sluice Gate to Storage Container walk
* Head to (H-6) in {z:Rala Waterways}, and retrieve the {@k} {k:Waterway facility crank} from the **Storage Container**.
** If you already are in Rala Waterways at the Sluice Gate from the last mission and have easy access to the {s:Sneak} status, it's faster just to run there directly. No need for invisible in this area.
** If you're coming from town, this is most easily accessed via {z:Western Adoulin} (K-8) from the **Big Bridge** {p:Waypoint}.

* Return to the **Sluice Gate** (C-6) for a cutscene.
* Click the **Sluice Gate** to enter the area behind the gate.
** If progress in {p:Rhapsodies of Vanadiel} is at {M:Rhapsodies of Vanadiel Mission 3-8|Rhapsodies of Vanadiel Mission 3-8|Gone but Not Forgotten}, the **Inconspicuous Barrel** is immediately on the right in the corner.
* Click the **Antiquated Sluice Gate** to enter the battlefield: {p:Behind the Sluices (Battle)}.
** If you fail the fight you will have to run back to the storage container at (H-6) for another {@k} {k:Waterway facility crank}.

* Notes for those assisting with the fight already completing it:
** They do not need a {@k} {k:Waterway facility crank}.
** They also don't need to be near the **Antiquated Sluice Gate** - just somewhere in the zone, and they'll be teleported instantly when the fight begins.
** The reward message __You have obtained 15000 bayld!__ seems to display only intermittently (rarely appearing even with no log filtering), but comparing bayld before-and-after the fight shows that the reward occurs even without the message.
** The party leader needs to be on the mission and needs to be the one interacting with the **Antiquated Sluice Gate**, but the leader can be changed once the battle begins to improve trust selection.
** The fight can be repeated for the bayld bonus as soon as finishing it, prior to leaving the zone even while this mission is still active.
*** A party can split up and go through one-by-one, repeating the fight with the next person. The last person to go through won't get a reward, but each other player would get rewards based on the number of times they repeated it.

=2 The Battle
* You fight against four enemies.
* All four enemies run to a random target to perform weapon skills, regardless of hate.
** This causes {p:skillchains|Skillchain} to happen on players so take care.
* Alter Ego {p:Trusts|Trust} may be summoned in this fight.
* At 119 this fight is not a problem with 5 Trusts.
** Mileage may vary, see "coldReactive's RDM Trust Solo Testimonial" on the {p:discussion|Talk:Seekers of Adoulin Mission 2-7-1} page.

* You fight alongside {p:Arciela}!
** {p:Arciela} will buff herself with **Stoneskin**, **Protect V**, and **Shell V**.
** {p:Arciela} will engage the enemies on her own after a player readies their battle stance (takes weapons out), but will stay put until then.
** {p:Arciela} can hold her own well, but will require healing. If she dies, you'll fail the mission.
** {p:Valaineral|BGWiki:Trusts} can be useful to hold hate off of her due to {i:Uriel Blade}.

=3 Enemies
\**The Keeper:** (SCH/BLM)
:* Uses {p:Gust Slash}, {p:Cyclone}, {p:Aeolian Edge}, and casts single target {s:Kaustra}.
:* Can close a skillchain with Magic using {p:Immanence} after the Mistdagger is felled.
:* He is the most resistant to damage.

::* Recommended to fight last.

\**Mistdagger:** (NIN)
:* Casts {s:Ninjutsu}, and has access to all {p:Katana} weapon skills.

\**The Briars:** (Galka) (WAR)
:* Has access to all {p:Great Axe|Category:Great Axe} weapon skills, but is likely to use {p:Full Break} and {p:Fell Cleave}.

\**The Briars:** (Elvaan) (RDM/BLM)
:* Casts -aga 3 black magic and spells like {s:Slow II}.

]=],
}
