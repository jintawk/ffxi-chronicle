-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Shoot_First,_Ask_Questions_Later). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Shoot First, Ask Questions Later',
    title = 'Shoot First, Ask Questions Later',
    source = 'https://www.bg-wiki.com/ffxi/Shoot_First,_Ask_Questions_Later',
    images = {'Broken Latent.png'},
    meta_order = {'Name', 'Required Fame', 'Level Restriction', 'Starting NPC', 'Pack', 'Title', 'Repeatable', 'Description', 'Previous Quest', 'Next Quest', 'Requirements', 'Rewards'},
    meta = {
        ['Name'] = 'Shoot First, Ask Questions Later',
        ['Required Fame'] = '{p:Bastok|Category:Bastok Quests} Fame Level: NA',
        ['Level Restriction'] = 'Level 71',
        ['Starting NPC'] = '{p:Cid} - {z:Metalworks} (H-8)',
        ['Pack'] = 'Rise of the Zilart',
        ['Title'] = 'None',
        ['Repeatable'] = '__No__',
        ['Description'] = 'Cid would like you to assist him in testing a new firearm. Return to the lab when the weapon no longer functions properly.',
        ['Previous Quest'] = 'None',
        ['Next Quest'] = 'None',
        ['Requirements'] = '{p:Marksmanship} Skill 250+{br} Level 71',
        ['Rewards'] = '{p:Detonator} Weaponskill'
    },
    body = [=[
\**{c=red:Note:}** You cannot start this Quest if you have a other {q:Weapon Skill Quest|WSNM|Weapon Skill Quest} active or if you are on the Quest {q:Cid's Secret|Cid's Secret|Cid's Secret}.
=2 Walkthrough
* Speaking with {p:Cid} will grant you the {@k} {k:Weapon training guide} as well as the {@i:Gun of Trials|18146} {p:Gun of Trials}.
* You will need to break the latent on the {p:Gun of Trials} before completing the rest of the Quest.

=3 Breaking the Latent
::* With the {p:Gun of Trials} equipped in your Main hand, fight experience-yielding mobs ("Incredibly Easy Prey" or higher) and perform {p:Weapon Skills|Category:Weapon Skills} or close {p:Skillchains|Category:Skillchain} to accumulate 300 "Trial Points".

|^Skillchain Level|Points
|No Skillchain|5
|Level 1|7
|Level 2|9
|Level 3|11

::* You know you have enough points when the latent breaks. You will know it is done when the weapon's elemental resistances disappear from your active resistances (colored dots below the gear grid, but above the selected item description). **The item's description text will never change**.

!Broken Latent.png||
----
* Trade the {p:Gun of Trials} back to {p:Cid}. This will give you the {@k} {k:Map to the Annals of Truth}.
* You will be instructed to travel to {z:The Boyahda Tree}.
** Examine the **???** at (J-8) in {z:The Boyahda Tree |The Boyahda Tree} Map 3.
** Short path:
*** Take the {z:The Boyahda Tree} Home Point or {z:The Boyahda Tree} Unity Warp, this will put you on Map 2, run to (G-10) and go south into a tunnel leading to Map 3. Inside, continue south and examine **???** at (J-8) to spawn the NM.
** Otherwise, long path:
*** Take {@i:Silent Oil|4165} {i:Silent Oil|Silent Oil|4165} with you and head to {z:The Sanctuary of Zi'Tah}.
*** Travel to (J-12) and enter {z:The Boyahda Tree} just to the north.
*** Inside the {z:Tree|The Boyahda Tree}, follow the path until it opens into a large room; this should be around (I-8). Travel northwest to (G-7) and fall over the ledge. Continue northwest to (C-4) and enter the tunnel there. Follow it as it curves to the south, and then travel south to the tunnel at (A-6).
*** When you exit the tunnel, you will be in a large area with several waterfalls leading down and a large tree in the center. This area is populated with {m:Korrigan} and {m:Elder Goobbue}. Travel south to (G-10) tunnel, just inside is the **???** to spawn the NM.
* This fight is against {m:Beet Leafhopper}, a {m:Fly}. It is weak to {@g:Element: Ice|Ice} **{p:Ice}**.
* Once you kill it, re-examine the **???** to receive the {@k} {k:Annals of Truth}.
* Go back and speak with {p:Cid} to receive your reward.

]=],
}
