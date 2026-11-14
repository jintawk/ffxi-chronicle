-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/All_by_Myself). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'All by Myself',
    title = 'All by Myself',
    source = 'https://www.bg-wiki.com/ffxi/All_by_Myself',
    images = {'All By Myself Map.jpg'},
    meta_order = {'Name', 'Required Fame', 'Level Restriction', 'Starting NPC', 'Pack', 'Title', 'Repeatable', 'Description', 'Previous Quest', 'Next Quest', 'Rewards'},
    meta = {
        ['Name'] = 'All by Myself',
        ['Required Fame'] = '{p:Bastok|Category:Bastok Quests} Fame Level: 2',
        ['Level Restriction'] = 'None',
        ['Starting NPC'] = '{n:Marin}, {z:Bastok Markets} (E-10)',
        ['Pack'] = 'None',
        ['Title'] = 'None',
        ['Repeatable'] = '__Yes__',
        ['Description'] = 'Marin wants you to watch over her little brother Ken, and make sure nothing happens to him during his military academy exam. Hopefully, this does not count as cheating...',
        ['Previous Quest'] = 'None',
        ['Next Quest'] = 'None',
        ['Rewards'] = '1,500 gil'
    },
    body = [=[
=2 Walkthrough
* Speak to {n:Marin} and accept the quest.
* When prompted, you need to select "I wasn't talking to you, squirt." in order to proceed.
* Enter {z:Dangruf Wadi} for a short introductory cutscene.
** If you use the {p:Survival Guide} to teleport, you must re-zone in order to receive this cutscene.
* Speak to the NPC {n:Ken} to initiate the quest.
** This will cap you at level 10.
** Buffs do remain active, but you cannot cast anything on Ken before starting the quest.

!All By Myself Map.jpg|right|Location of Events.
>**Escort Rules**
* **{c=red:You will fail the mission if }{n:Ken}{c=red: spots you at any time.}**
* Ken engages all enemies that are in his line of sight.
* You must keep {n:Ken} alive as he battles monsters in {z:Dangruf Wadi}.
* He has reasonable survivability, but will be in danger after about 3-4 enemies.
* Ken cannot be stopped like NPC's used in the 3 nation escort quests.
* Ken will attack an unclaimed enemy even if it has aggression on an outside player.
* When attacking, Ken's target will appear unclaimed, but outside people still cannot attack it.
* His sight distance is considerable so be aware of your position.
* When he spots a monster, he makes a beeline for it and begins attacking. After a monster is dead, he will then "snap" back onto the path location he was at before he drew his weapon. This almost certainly means he will turn around abruptly and spot you if you were behind him curing him. This causes him to pass normally impassable terrain.
* He kills lizards and worms in usually only four-five hits. His accuracy is horrible though. Goblins take around five of his hits, and crabs take about six-seven.
* One way to make this quest easier is if you have a higher level friend run slightly ahead of Ken and kill monsters before he attacks them. You will still need to be careful that he does not spot you, and it's possible he will need curing if he reaches a monster before your friend does. Once Ken starts attacking a monster, your friend cannot help him.

>**Escort Route Progression**
* Ken will always follow the same path outlined in the map provided.
* As he progresses you will receive messages of him speaking that indicate how far along the route he currently is. Each message corresponds to a number and location on the map:

* 1: "I have this funny feeling I'm being watched... Let's see if anybody's following me..."
** At this point Ken will stop and turn around. Make sure you're out of sight.
* 2: "Uh-oh... I think I'm lost. I really should have brought that map Sis gave me..."
** Ken will pause for a moment before continuing.
* 3a: "Now, where should I begin my survey..."
** Ken will pause, rotate 360 degrees, Say a couple "Hmms" then run to the pond in the middle of the large room.
* 3b: "This looks like a good place... But I wonder if there is anything interesting further on..."
* 4: "A dead end... I guess I'll go back to that other place."
** Ken will turn around and return the way he came. Hide behind the southern rock.
* 5: "Ah, here we are. Now let's see... Depth... Temperature..."
** Ken will pause to take a reading at the hot spring.
* 6: "... What was that sound..."
** Ken will stop and turn around. Make sure you're out of sight.
* 7: "Have I already been here... Wait a minute... This place looks familiar..."
** As Ken reaches the first room again he will run in circles. Make sure you're far away from the perimeter.
* 8: "Huh. That was easy. I don't know what Sis was all worried about."
** After this, Ken will run towards the zone line and despawn.
** Be behind him for this part, because he will see you when he runs towards the zone line facing out!

* After Ken despawns, Marin will appear at the exit. Speak to her to remove the level cap and receive {@k} {k:Ken's escort award}.
* Return to {z:Bastok Markets} and speak to {n:Marin} again to finish the quest.

]=],
}
