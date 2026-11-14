-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_5-5). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'The Voracious Resurgence Mission 5-5',
    title = 'The Sea Sage',
    source = 'https://www.bg-wiki.com/ffxi/The_Voracious_Resurgence_Mission_5-5',
    images = {'Wajaom Woodlands-map-additional-markers.jpg', 'Aydeewa Subterrane-map3.jpg', 'Voracious Resurgence5-5-1.png', 'Voracious Resurgence5-5-2.png'},
    meta_order = {'Name', 'Series', 'Starting NPC', 'Title', 'Repeatable', 'Description', 'Previous Mission', 'Next Mission', 'Rewards'},
    meta = {
        ['Name'] = 'The Sea Sage',
        ['Series'] = 'The Voracious Resurgence',
        ['Starting NPC'] = 'N/A',
        ['Title'] = 'Beloved by the Sea God',
        ['Repeatable'] = '__No__',
        ['Description'] = 'Mission Orders: Bijoux, the apkallu elder, has provided you with a good deal of information. You must look for a breathing pearl to dive into the water and find the pteraketos. Bijoux notes that the Olduum civilization, once located in Wajaom Woodlands, may contain clues. Head for the designated location.',
        ['Previous Mission'] = '{M:The Seagull Phratrie|The Seagull Phratrie|The Seagull Phratrie}',
        ['Next Mission'] = '{M:Sky, Moon, Incantrix|Sky, Moon, Incantrix|Sky, Moon, Incantrix}',
        ['Rewards'] = '{@i:Apkallu Scepter|22043} {p:Apkallu Scepter}'
    },
    body = [=[
\**{c=red:Note:}** The game may freeze during the upcoming cutscenes depending on your Windower/Ashita settings.
* The FastCS addon crashes this cutscene.
* FPS needs to be capped at 30 (if you changed it). If using Windower, use //config FrameRateDivisor 2.
* If it does freeze, you can run `//lua unloadall` then `//exec autoload/autoload`, and it should recover from the frozen cutscene.
* Pressing Print Screen Key may also possibly break you out of soft lock.

=2 Walkthrough
!Wajaom Woodlands-map-additional-markers.jpg||Wajaom Woodlands
!Aydeewa Subterrane-map3.jpg||Aydeewa Subterrane{br}Map 3
* **{c=red:Note:}** You need the {@i:Thunder Hammer|22032} {p:Thunder Hammer} you received from Mission 5-3 to complete this.
* Head to Map 3 of {z:Arrapago Reef} (F-7) and speak with {n:Apkallu Guide} for a cutscene to begin the Mission.
** Teleport to {z:Caedarva Mire}'s {p:Survival Guide} and then zone to the East.
* Proceed to (G-8) in {z:Wajaom Woodlands} to examine the **Leypoint** for a cutscene.
** You may use an {@i:Olduum Ring|15769} {i:Olduum Ring|Olduum Ring|15769} to teleport directly to the spot.
** Alternatively, use the Wajaom Woodlands {p:Survival Guide} or Unity Warp (125).
* Travel to (G-9) in {z:Aydeewa Subterrane} from {z:Wajaom Woodlands}.
** To get here, first go to (E-10) in {z:Wajaom Woodlands}, **Entrance 8** on the map to enter the {z:Aydeewa Subterrane} (Map 3).
*** {p:Voidwatch Warp} to {z:Mamook} will put you close to this entrance, but it's much faster to just run there.
** Follow the path, along the left wall the whole way, **do not drop down**, and take **Exit 7** at (J-8).
* Once outside keep going and after the first ledge drop you will be in an open area.
** __If you see raptors or spiders then you went the wrong way in the Subterrane.__
* Equip the {@i:Thunder Hammer|22032} {p:Thunder Hammer} in your main weapon slot and approach the {p:Marolith|Category:Marolith} at (G-9) for a cutscene.
** The {p:Marolith|Category:Marolith} is not targetable. If {m:Hydra|Hydra (Notorious Monster)} is up, you can walk around it without aggro if you do not want to kill it.
** You will receive {@k} {k:Aeropearl} afterwards.
* Return to the {n:Apkallu Guide} in {z:Arrapago Reef} (F-7) via the Caedarva Mire Survival Guide for a cutscene.
* Speak with {n:Ghatsad} in {p:Aht Urhgan Whitegate} (I-7) for another cutscene.
** Speaking to {n:Dkhaaya} before {n:Ghatsad} will give you a mini-cutscene where he tells you he cannot fix the aeropearl and send you to Ghatsad.
* Head to {z:Alzadaal Undersea Ruins} and defeat the {p:Qiqirns|Category:Qiqirn} in the area to spawn {p:Panaiveriyamman|Category:Acrolith} (WAR), an Acrolith NM.

>**Encounter**
* {p:Panaiveriyamman|Category:Acrolith} (WAR)
** It will appear immediately after killing a Qiqirn, so summon Trusts beforehand.
** You may need to defeat many Qiqirns before Panaiveriyamman spawns.
*** If you're having trouble popping {p:Panaiveriyamman|Category:Acrolith} equip your {p:Thunder Hammer} and get physical kills with it. (Confirmed that the Thunder Hammer is not required to pop Panaiveriyamman... Just kill till it pops, the Thunder Hammer is not required.)
*** The above comment is anecdotal and should not be taken as fact. See {p:Discussion|Talk:The Voracious Resurgence Mission 5-5} page.
** Uses {@g:Two-Hour ability|Two-Hour ability} {p:Mighty Strikes}, but doesn't hit very hard or accurately in general.
** Resistant to magic, especially {@g:Element: Dark|Darkness} **{c=black:Dark}**-based spells, but is very susceptible to {@g:Element: Water|Water} **{c=#4996EC:Water}** damage.
** Has approximately 150k HP.

* You will receive the {@k} {k:Man-made solution} after the fight.
** The Key item will drop to everyone in a party/alliance, even if you are not on the same map.
* Return to {n:Ghatsad} for a cutscene.
** **Note:** FastCS may cause you to get stuck on a black screen during this CS. Unload FastCS or use the Print Screen button to unlock from a soft freeze.
** You will receive {@k} {k:Repaired aeropearl} afterwards.
* Acquire a {@i:Lamian Fang Key|2219} {i:Lamian Fang Key|Lamian Fang Key|2219} once again and head back to the **???** (H-10) Map 1 {z:Arrapago Reef}.
** Survival guide warp to Arrapago Reef.
* Return to the {n:Apkallu Guide} via the Caedarva Mire Survival Guide for the final cutscene and your reward.
** **FastCS will soft-lock your client to a black screen at the end of this cutscene.**
*** To resolve this, upon reaching the aforementioned black screen, hold **Prt Scr** (or **Fn** + **Prt Scr** if on laptop or a 60% keyboard) for 4~ seconds to unlock yourself from the soft-lock.

=2 Notes
* At this point, you can open up more new {p:Records of Eminence} objectives. See the NPC {n:Elijah} in {z:Upper Jeuno} (near Home Point #1) for more information.

=2 Gallery
Art gallery of images used in the cutscenes of this mission.
[WARNING: MAY CONTAIN PLOT SPOILERS!
!Voracious Resurgence5-5-1.png||
!Voracious Resurgence5-5-2.png||
]
]=],
}
