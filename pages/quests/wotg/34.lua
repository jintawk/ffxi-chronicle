-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Seeing_Blood-red). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Seeing Blood-red',
    title = 'Seeing Blood-red',
    source = 'https://www.bg-wiki.com/ffxi/Seeing_Blood-red',
    images = {'Pashhow Marshlands (S) Map.png', 'Grauberg-map.jpg'},
    meta_order = {'Name', 'Required Fame', 'Level Restriction', 'Starting NPC', 'Pack', 'Title', 'Repeatable', 'Description', 'Previous Quest', 'Next Quest', 'Rewards'},
    meta = {
        ['Name'] = 'Seeing Blood-red',
        ['Required Fame'] = '__Unknown__',
        ['Level Restriction'] = 'None',
        ['Starting NPC'] = 'Erlene, Batallia Downs (S)',
        ['Pack'] = 'Wings of the Goddess',
        ['Title'] = 'Summa Cum Laude',
        ['Repeatable'] = '__No__',
        ['Description'] = 'Ulbrecht\'s maniacal machinations have been made clear, and only one person holds the key to tracking him down. Find Professor Schultz!',
        ['Previous Quest'] = '{q:Downward Helix|Downward Helix|Downward Helix}',
        ['Next Quest'] = '{q:Survival of the Wisest|Survival of the Wisest|Survival of the Wisest}{br}(Limit Break Questline)',
        ['Rewards'] = '{@i:Scholar\'s M.board|16140} {i:Scholar\'s Mortarboard|Scholar\'s Mortarboard|16140}'
    },
    body = [=[
=2 Walkthrough
!Pashhow Marshlands (S) Map.png|right|Pashhow Marshlands (S)
!Grauberg-map.jpg|right|Grauberg
* Wait until the next game day and zone after completing the previous quest in order to begin this one.
* Speak to {n:Erlene}, {z:The Eldieme Necropolis (S)} (J-8) on Scholar. She will ask you to return to the previous location where you found Schultz.
** (Optional) Speaking with her again will result in some additional dialogue.
** After flagging the quest with this cutscene, you can continue forward through the rest of it on any job.
* Travel to the **Indescript Markings** in {z:Pashhow Marshlands (S)} along the north edge of (E-11) next to the wall for the {@k} {k:Unaddressed sealed letter}.
** The {s:Recall-Pashh} telepoint and {p:Survival Guide} will take you to the southern end of the map, leaving you with a shorter walk West than using the {p:Campaign Arbiters} warp NPCs from a Shadowreign city. The {z:Grauberg (S)} {p:Survival Guide} isn't terribly far from it, either.
* Read the {k:Unaddressed sealed letter} by examining it in your Temporary Key Item menu.
* Return to Erlene and talk to her again for a cutscene and a {@k} {k:Porting magic transcript}.
* Go to {z:Grauberg (S)} (E-10) and enter the cave opposite the waterfall. Examine the unnamed shimmering light on the ground.
** The cave entrance is on the boundary line of E-10 and F-10. If you go near the waterfall, you've gone too far. The entrance to the cave is on dry land. Also, if you don't heed this advice and still go past the waterfall, you will have to go all the way back around.
** Using the {p:Campaign Arbiters} warp NPCs from a Shadowreign city is the closest arrival point. The {z:Grauberg (S)} {p:Survival Guide} is a bit further away.
* Inspect the **Indescript Markings** on the wall in the same cave to enter the instance.
** Only the party leader with the quest active can enter the party into the instance, which is held in {z:Ruhotz Silvermines}.
** If you fail this fight, you will need to trade {n:Erlene} a {i:Sheet of Vellum|Sheet of Vellum|2550} to receive another {k:Porting magic transcript} before re-entering the fight.
* Return to Erlene after clearing the battlefield for your reward.

=2 Battlefield
* The instance has a 30 minute time limit and up to 6 party members can enter.
* You may summon {p:Trusts} inside.
* The fight is against {n:Ulbrecht}, who is a level 67 {p:Scholar} with ~12,000 HP that uses {p:Dark Arts} {p:Stratagems|Stratagem}.
** Uses a {p:Dagger} and can use {p:Wasp Sting}.
** Will use a {p:Stratagem} every minute.
** Can cast the following spells: {p:Aspir}, {s:Cure IV}, {p:Drain}, {s:Dispel}, {s:Protect III}, {s:Regen II}, {s:Shell III}, {s:Sleep}, the {p:Storm} line of spells, and all tier III elemental nukes. Casts tier III elemental spells with random elements, even after giving himself a specific {p:Storm}. In fact, spell selection overall is __very poor__ and he appears to just randomly choose one with no real logic.
** Immune to {p:Silence} but not any other form of {s:Enfeebling Magic}, including {s:Bind}, {s:Gravity}, and {s:Sleep}. Like all NMs, it is believed he will build resistance with repeated usage.
** At around 50% he will use {p:Tabula Rasa} and spam spells.
*** During this time, his {p:Stratagems} will not wear off upon a single spell cast, lasting a full minute duration. __(verification needed)__
* The battle ends once Ulbrecht's HP drops below 20%.

=2 Notes
* Added in the {p:March 2008 Version Update|Version Update (03/11/2008)}.
* Since the {p:October 2016 Version Update|October 2016 Version Update Changes}, players were able to summon {p:Trusts}.

]=],
}
