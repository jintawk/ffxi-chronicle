-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Windurst_Mission_9-2). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Windurst Mission 9-2',
    title = 'Moon Reading',
    source = 'https://www.bg-wiki.com/ffxi/Windurst_Mission_9-2',
    images = {},
    meta_order = {'Name', 'Series', 'Starting NPC', 'Title', 'Repeatable', 'Description', 'Previous Mission', 'Next Mission', 'Rewards'},
    meta = {
        ['Name'] = 'Moon Reading',
        ['Series'] = 'None',
        ['Starting NPC'] = 'Any Windurst Gate Guard',
        ['Title'] = 'Vestal Chamberlain',
        ['Repeatable'] = '__No__',
        ['Description'] = 'To lure the Bearer of Darkness to the Full Moon Fountain, you must collect the three verses of the ancient people. As her guiding star, the Star Sibyl is counting on you to help her decide the path for Windurst\'s future. The fate of Windurst rests upon your shoulders!',
        ['Previous Mission'] = '{M:Doll of the Dead|Windurst Mission 9-1|Doll of the Dead}',
        ['Next Mission'] = 'None',
        ['Rewards'] = '{@g:Windurst} Rank 10{br} 100,000 {p:Gil}{br} {i:Windurstian Flag|Windurstian Flag|183}{br} Ability to buy {@k} {k:Atma of the Full Moon}'
    },
    body = [=[
=2 Walkthrough
Trade enough Crystals to the {p:Conquest NPC} to raise the Rank bar and unlock the Mission, then accept it from the Gate Guard.
* **Optional**: Talk to everyone from {n:Kupipi} and beyond for unique dialogue to this part of the mission within {z:Heavens Tower}. The guards just before the teleporter in {z:Windurst Walls} will also vary at different points in these missions.
** After the upcoming cutscene on the top floor, the dialogue will also be changed for 3 of the 4 Mithra on the top floor closest to the chamber (Shaz Norem's does not change).
** All this dialogue will change yet again after the BCNM of this mission, so before then is your only opportunity to experience it.
* Click the **Door: Vestal Chamber** on the top floor of {z:Heavens Tower} for a cutscene about the {p:Star Sibyl}.
* Collect the following 3 Key Items in any order:

{@k} {k:Ancient Verse of Ro'Maeve}:
* Interact with the **Qu'Hua Spring** in {z:Ro'Maeve} at (H-6).
** {p:Survival Guide} warp is recommended.

{@k} {k:Ancient Verse of Altepa}:
* Zone into {z:Chamber of Oracles}.
** {z:Quicksand Caves} {p:Home Point} #1 is the quickest way to this location.
** Alternatively: use the {z:Western Altepa Desert} (D-12) entrance of {z:Quicksand Caves}. You will need {s:Sneak}. You will need to open the pressure switch door at (I-9).
*** This can be done solo if you posses a {@k} {k:Loadstone} from the Quest {q:Open Sesame|Open Sesame|Open Sesame} or with the required amount of people.
*** Requires 3 points to open the doors: Galka = 3 points; Hume/Elvaan/Mithra = 2 points; Tarutaru = 1 point.
** Keep left to enter {z:Chamber of Oracles}.

{@k} {k:Ancient Verse of Uggalepih}:
* Interact with the **???** in {z:Temple of Uggalepih} (E-8) Map 2.
** An {@i:Uggalepih Key|1136} {i:Uggalepih Key|Uggalepih Key|1136} (**{p:U|Uncommon (10%)}**), dropped from {m:Tonberry Cutters|Tonberry Cutter} on Map 2, is needed to open the **Granite Door** to get to the **???**.
** {p:Unity} Warp Level 125 {z:Temple of Uggalepih} is the quickest route to this location.
** Alternatively: use the {z:Temple of Uggalepih} {p:Survival Guide} to Map 1, go north to {z:Yhoator Jungle} then head west to re-enter and reach Map 2 of the Temple.
** Players 75+ do not aggro.

* Return to the **Door: Vestal Chamber** in {z:Heavens Tower} for a cutscene.
* Go to {p:Full Moon Fountain} and clear a two-part BCNM.
** Fastest path to this location is through {z:Toraimarai Canal} {p:Home Point} #1.
** Alternatively, you can use the {p:Survival Guide} to reach {z:Toraimarai Canal}.

=3 BCNM
\**{c=red:Note:}** If you use the Enternity/FastCS addon, the following cutscenes may not play while using Windower or Ashita. If you are running the game at 60 FPS, you may have to revert to 30 FPS to complete this cutscene.
* Commands to unload them: __//lua u enternity__ - __/addon unload enternity__ - __//lua unload fastcs__ - __//config FrameRateDivisor 2__
* If you crash the game __after__ completing the BCNM, the top door will not provide a cutscene. The remedy is to click the blank, glowing spot right outside of {z:Heavens Tower} to complete Rank 10.
* Not everyone has this issue but if you do the above should work for you.

----
The BCNM fight is trivial at 99. {p:Trusts} can be summoned.
* The first part is against four Ace Cardians:
** A good strategy is to cast {p:Sleepga} on them and and kill {m:Ace of Batons|Ace of Batons (Monster)} (BLM) > {m:Ace of Swords|Ace of Swords (Monster)} (PLD) > {m:Ace of Coins|Ace of Coins (Monster)} (RDM). Sleep {m:Ace of Cups|Ace of Cups (Monster)} (WHM) and rest to full.
** The Cardians will eventually start resisting Sleep. However, unless you take a long time to kill the first three it should not be a problem.
** The Cardians will aggro from outside casting player casting range. The {m:Ace of Swords|Ace of Swords (Monster)} will move to melee range while the other three will cast before moving.
** As soon as the last Cardian dies you will get a cutscene.
* The next fight is with a {p:Wyvern|Category:Wyvern} and a {p:Manticore|Category:Manticore}.
** You will be assisted by {p:Ajido-Marujido}. If he dies, you lose the fight, so be sure to cure him. Kill what {p:Ajido-Marujido} decides to fight first.
** Letting {p:Ajido-Marujido} choose will aggro both NMs. Be prepared to pull both off of him.

* **Optional:** Talk to {n:Kupipi} for optional dialogue which will change once you've reached Rank 10.
** Everyone else upstairs has new lines again, but they won't change after completion of the mission.
* Return to the **Door: Vestal Chamber** in {z:Heavens Tower} for a cutscene.
* Click the **Door: Vestal Chamber** again for the final cutscene with the {p:Star Sibyl} and to end the {p:Windurst} story line.

]=],
}
