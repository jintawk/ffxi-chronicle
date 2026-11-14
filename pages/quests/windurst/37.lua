-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Making_Headlines). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Making Headlines',
    title = 'Making Headlines',
    source = 'https://www.bg-wiki.com/ffxi/Making_Headlines',
    images = {'Inner Horutoto Ruins-map1.jpg', 'Inner Horutoto Ruins-map2.jpg'},
    meta_order = {'Name', 'Required Fame', 'Level Restriction', 'Starting NPC', 'Pack', 'Title', 'Repeatable', 'Description', 'Previous Quest', 'Next Quest', 'Rewards'},
    meta = {
        ['Name'] = 'Making Headlines',
        ['Required Fame'] = '{p:Windurst|Category:Windurst Quests} Fame Level: __Unknown__',
        ['Level Restriction'] = 'None',
        ['Starting NPC'] = '{p:Naiko-Paneiko}, {z:Southern Windurst Waters|Windurst Waters}(C-11)',
        ['Pack'] = 'None',
        ['Title'] = 'Editor\'s Hatchet Man',
        ['Repeatable'] = '__No__',
        ['Description'] = 'The editor wants you to gather news articles from the reporters dispatched to each of the four districts of Windurst. In addition, he wants you to confirm the validity of the scoop reported by the reporter in Windurst Woods.',
        ['Previous Quest'] = 'None',
        ['Next Quest'] = '{q:Scooped!|Scooped!|Scooped!}',
        ['Rewards'] = '{@i:Counterfeit Gil|1708} 560 gil'
    },
    body = [=[
=2 Walkthrough
* Speak to {p:Naiko-Paneiko} in {z:Southern Windurst Waters|Windurst Waters} (C-11) at The Tarutaru Times Company to begin the quest.
* Speak to the following NPCs to retrieve {p:key items|Category:Key Items}:
** {n:Kyume-Romeh} in {z:Northern Windurst Waters|Windurst Waters} (F-10) in the Timbre Timbers Tavern for {@k} {k:Windurst Waters scoop}
** {n:Hiwon-Biwon} in {z:Windurst Walls} (K-8) by Shanttoto's House for {@k} {k:Windurst Walls scoop}
** {n:Umumu} in {z:Windurst Woods} (I-6) near the Dhamel Farm for {@k} {k:Windurst Woods scoop}
** {n:Yujuju} in {z:Port Windurst} (M-6) by the Air Travel Agency for {@k} {k:Port Windurst scoop}.
* Return to Naiko-Paneiko, he will request that you check out a lead in the {z:Inner Horutoto Ruins}.
* Enter from {z:East Sarutabaruta} (J-7) to enter the first map of {z:Inner Horutoto Ruins}.
* Examine the Cracked Wall at (G-8) to enter the second map.
** The Cracked Wall at (G-9) can be used as an alternative if you do not have a way to apply {p:Invisible (Status)} once past the door to avoid goblin aggro.
** Low level players may notice the monsters on the second map are much higher level, but should not panic. Only "evil" mobs are aggressive. See notes below for more info.
* Examine the Mahogany Door at (G-8) to get a message to confirm the {@k} {k:Windurst Woods scoop}.
* Return to Naiko-Paneiko to finish the quest and receive your reward.

!Inner Horutoto Ruins-map1.jpg||Horutoto Ruins Map 1
!Inner Horutoto Ruins-map2.jpg||Horutoto Ruins Map 2
=2 Notes
* What low level players should know about Incredibly Tough mobs (level 79-92) in beginner zones such as {z:Inner Horutoto Ruins}.
** Why they are here:
*** After the level cap was raised beyond 75 in the Abyssea era, SE decided to repurpose some of the many underutilized low level zones into leveling camps for level 75+.
** These changes should not disrupt new players:
*** Regular wildlife ({p:Beasts|Category:Beasts}, {p:Vermin|Category:Vermin}, etc.) will be non-aggressive. You can walk past them.
*** Evil creatures ({p:Undead|Category:Undead}, {p:Beastmen|Category:Beastmen}, {p:Demons|Category:Demons} will still be {p:aggressive|Aggressive} and should be avoided.
**** You do not need {s:Sneak} and {s:Invisible} usually. Check for alternative tunnels where these creatures are not present.
**** At {z:Inner Horutoto Ruins}, the southern tunnel marked **B** on the maps do not have skeletons or goblins.
** To look up the level of an Incredibly Tough mob, you can look at the zone pages on this wiki, or the {p:Grounds Tomes|Grounds Tome} in middle lands areas.
* Summary
** Deathwatch Beetle and Troika Bats: ignore them and they'll ignore you.
** Goblins : If they {p:see|Aggressive} {@a:Sight|Detects by Sight} you, they will attack. Stay more than {p:10y|Yalm} away (roughly half the width of the tunnel), be careful around (H-8).
** Skeletons: If they {p:hear|Aggressive} {@a:Sound|Detects by Sound} you or your {@a:HP|Detects by Low HP} {p:Hit Points} are below 80%, they will attack. Stay more than {p:10y|Yalm} away, these are also around (H-8), further ahead than the goblins.
** The aggressive enemies can be avoided without Sneak/Invisible by using the southern tunnel marked **B** and staying to the left while going toward the Mahogany Door.

]=],
}
