-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Carbuncle_Debacle). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Carbuncle Debacle',
    title = 'Carbuncle Debacle',
    source = 'https://www.bg-wiki.com/ffxi/Carbuncle_Debacle',
    images = {'The Boyahda Tree-map1.jpg', 'The Boyahda Tree-map2.jpg', 'Kuftal Tunnel-map1.jpg', 'Kuftal Tunnel-map2.jpg', 'Cape Teriggan - Map.jpg'},
    meta_order = {'Name', 'Required Fame', 'Level Restriction', 'Starting NPC', 'Pack', 'Title', 'Repeatable', 'Description', 'Previous Quest', 'Next Quest', 'Requirements', 'Rewards'},
    meta = {
        ['Name'] = 'Carbuncle Debacle',
        ['Required Fame'] = '{p:Windurst|Category:Windurst Quests} Fame Level: __Unknown__',
        ['Level Restriction'] = 'Level 50+ {p:Summoner}',
        ['Starting NPC'] = '{p:Carbuncle}, {z:Windurst Walls}',
        ['Pack'] = 'Rise of the Zilart',
        ['Title'] = 'Paragon of Summoner Excellence',
        ['Repeatable'] = '__Yes, after {n:Memory reset}__',
        ['Description'] = 'Carbuncle needs your help. The Mana Orb held by the energy thief has grown so powerful it is threatening to enslave all the Carbuncles in the world. You must act now to save them!',
        ['Previous Quest'] = '{q:Class Reunion|Class Reunion|Class Reunion}',
        ['Next Quest'] = 'None',
        ['Requirements'] = '{@i:Ltng. Pendulum|1172} {i:Lightning Pendulum|Lightning Pendulum|1172}{br} {@k} {k:Daze-breaker charm}{br} {@i:Wind Pendulum|1174} {i:Wind Pendulum|Wind Pendulum|1174}',
        ['Rewards'] = '{@i:Evoker\'s Horn|12520} {i:Evoker\'s Horn|Evoker\'s Horn|12520}'
    },
    body = [=[
=2 Walkthrough
__You must zone after completing the previous quest.__
* Interact with the **House of the Hero** in {z:Windurst Walls} while your job is set to {p:Summoner} to begin this quest.
* Speak to {p:Koru-Moru} at (E-7). His reference to a Rhinostery Researcher is to {n:Ripapa}.
* Travel to {z:Mhaura} and speak to {n:Ripapa} (I-9) to obtain a {i:Lightning Pendulum|Lightning Pendulum|1172}.

* The cutscene that follows the next fight is known to cause problems for Windower addons. It may freeze. If it does:
** If you use FastCS simply unload it when the cutscene stops and it should proceed - you can immediately reload it and the cutscene should proceed without issue.
** If you use Enternity and the cutscene stalls, it may be due to the animation needing to catch up with the chat log. Just give it more time for the animation to catch up with the chat log.
** If all else fails simply reload using basic pol.exe and the cutscene should replay and complete successfully.
** 5/6/22 using all of the above I only had to reload FastCS when the cutscene paused. It then completed without a problem.
** 7/10/23 If you use the 60 FPS config command, turn it to 30 for the BCNM CS at the thunder protocrystal with //config FrameRateDivisor 2 to revert to 30 FPS, after fight use 1 to go back

* Trade the {i:Lightning Pendulum|Lightning Pendulum|1172} to the **Lightning Protocrystal** inside of the {z:Cloister of Storms} for a cutscene and to enter a BC.
** The {z:Cloister of Storms} can be reached via {z:The Sanctuary of Zi'Tah} at (K-12) > {z:The Boyahda Tree}. The closest Home Point is #1.
*** Once in the tree, you need to head upstairs at (B-7), then go to (J-12) on the following map.

!The Boyahda Tree-map1.jpg||The Boyahda Tree map 1
!The Boyahda Tree-map2.jpg||The Boyahda Tree map 2
* Defeat both {m:Lightning Gremlin} and {m:Thunder Gremlin}. They are both {m:Arcana} type mobs.
** {m:Lightning Gremlin}'s attacks drains {p:TP}.
** {m:Thunder Gremlin}'s attacks drains {p:MP}.
** Both NM's resist sleep spells.
* Return to {z:Windurst Walls} and speak to {p:Koru-Moru} to obtain a {@k} {k:Daze-breaker charm}.
* Head to {z:Rabao} and talk to {n:Agado-Pugado} (G-9) to receive a {i:Wind Pendulum|Wind Pendulum|1174}.
* Trade the {i:Wind Pendulum|Wind Pendulum|1174} to the **Wind Protocrystal** inside of the {z:Cloister of Gales} for a cutscene and to enter a BC.
** To get to the {z:Cloister of Gales}, you must go to {z:Western Altepa Desert} > {z:Kuftal Tunnel} > {z:Cape Teriggan}
*** Zone into {z:Kuftal Tunnel} from {z:Western Altepa Desert} at (H-4)
*** Go through the tunnel by reaching A on the first map, then the zone line is all the way north.

!Kuftal Tunnel-map1.jpg||Kuftal Tunnel map 1
!Kuftal Tunnel-map2.jpg||Kuftal Tunnel map 2
::* The Cloister is at (F-5) in {z:Cape Teriggan}.

!Cape Teriggan - Map.jpg||Cape Teriggan Map
* Defeat {m:Ogmios}, who is a {m:Manticore}.
* Return to {z:Windurst Walls} and talk to {p:Koru-Moru} to receive your {i:Evoker's Horn|Evoker's Horn|12520} and to complete the quest.
** You can toss the {i:Lightning Pendulum|Lightning Pendulum|1172} and {i:Wind Pendulum|Wind Pendulum|1174} after completing the quest, as they serve no further purpose.

]=],
}
