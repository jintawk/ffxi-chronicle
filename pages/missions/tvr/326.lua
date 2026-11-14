-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_5-2). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'The Voracious Resurgence Mission 5-2',
    title = 'The Revelation',
    source = 'https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_5-2',
    images = {'Wajaom Woodlands-map-additional-markers.jpg', 'Aydeewa Subterrane-map2-with-additional-markers.jpg', 'Aydeewa Subterrane-map5.jpg', 'Aydeewa Subterrane-map3.jpg', 'Voracious Resurgence5-2-1.png'},
    meta_order = {'Name', 'Series', 'Starting NPC', 'Title', 'Repeatable', 'Description', 'Previous Mission', 'Next Mission', 'Rewards'},
    meta = {
        ['Name'] = 'The Revelation',
        ['Series'] = 'The Voracious Resurgence',
        ['Starting NPC'] = '{n:Abda-Lurabda}, {z:Aht Urhgan Whitegate} (I-7)',
        ['Title'] = 'None',
        ['Repeatable'] = '__No__',
        ['Description'] = 'Mission Orders: Ghatsad\'s apprentices are concerned with his demeanor of late, as he is completely engrossed with learning more about Olduum. Head to Aydeewa Subterrane to assist with the investigation. The exact location: right past the area connecting the northern Wajaom Woodlands with Aydeewa Subterrane.',
        ['Previous Mission'] = '{M:Ghatsad\'s Quandary|Ghatsad\'s Quandary|Ghatsad\'s Quandary}',
        ['Next Mission'] = '{M:Tateeya\'s Worries|Tateeya\'s Worries|Tateeya\'s Worries}',
        ['Rewards'] = '20,000 {p:Gil}'
    },
    body = [=[
\**{c=red:Note:}** The game may freeze during the upcoming cutscenes depending on your Windower/Ashita settings.
* The FastCS addon crashes this cutscene.
* FPS needs to be capped at 30 (if you changed it). If using Windower, use //config FrameRateDivisor 2.
* If it does freeze, you can run `//lua unloadall` then `//exec autoload/autoload`, and it should recover from the frozen cutscene.
* Pressing Print Screen Key may also possibly break you out of soft lock.

=2 Walkthrough
!Wajaom Woodlands-map-additional-markers.jpg||Wajaom Woodlands{br}Full Map
!Aydeewa Subterrane-map2-with-additional-markers.jpg||Aydeewa Subterrane{br}Map 2
>Aydeewa Subterrane
!Aydeewa Subterrane-map5.jpg||Map 5
!Aydeewa Subterrane-map3.jpg||Map 3
* Speak with {n:Abda-Lurabda} in the **Automaton Workshop** (I-7) in {p:Aht Urhgan Whitegate} HP #1 for a cutscene to begin the Mission.
* Zone into {z:Aydeewa Subterrane} from the {z:Wajaom Woodlands} (I-6) entrance for a cutscene.
** You can exit {z:Al Zahbi} or {p:Aht Urhgan Whitegate} at (H-10) directly for the fastest route to this objective.
** You can also take the Survival Guide to {z:Aydeewa Subterrane} and Escape. This will put you at the (I-6) entrance.
* Head to and examine the **Survey Point** at (K-7) of Map 2 of {z:Aydeewa Subterrane} for a cutscene.
* Head south then hug the wall west to examine the **Survey Point** at the intersection of (I-9)/(J-9) for another cutscene.
** You should unlock the {p:Survival Guide} before proceeding further if you do not have it as it is a very convenient time to do so.
* Proceed to (E-9), and then west down the ramp (marked as **D**). This room is full of aggressive {m:Chigoes|Chigoe}.
* You will be on Map 5 of {z:Aydeewa Subterrane}. Examine **Survey Point** at (F-8) for another cutscene.
* After the cutscene, head south west towards the exit marked as **F** to transition to Map 3.
* After the map changes, drop down, follow the path, and make your way south to (G-10).

* Once you approach the stairs you'll see a brief cutscene. After this inspect the **Final Survey Point**.
** This cutscene may not happen under certain conditions (such as Sneak/Invis). If this happens, examine the **Final Survey Point** again.
* Examine the **Final Survey Point** again to begin a confrontation with Missabikong, a {m:Marolith}.
** Has approximately 150k HP.
** Missabikong has undispellable Shock Spikes and tends to spam __Subduction__, __Metamorphic Blast__, and __Enervating Grasp__.
*** The Shock Spikes and its high damage reduction can be removed under certain conditions. Thunder spells seem to be a trigger and quite possibly {s:Gates of Hades} (verification needed).
** Can use Mighty Strikes and multiple AoE TP moves, especially at low HP.
** Susceptible to Darkness and absorbs {@g:Element: Thunder|Thunder} Thunder, including associated skillchains (Light included).
** Vulnerable to {@g:Blunt|Blunt} Blunt Damage

* Examine the **Final Survey Point** after the fight for another cutscene.
* Return to {n:Abda-Lurabda} at Aht Urhgan Whitegate (I-7) for the **final cutscene** and your reward.

=2 Gallery
Art gallery of images used in the cutscenes of this mission.
[WARNING: MAY CONTAIN PLOT SPOILERS!
!Voracious Resurgence5-2-1.png||
]
]=],
}
