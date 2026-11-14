-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/The_Communion). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'The Communion',
    title = 'The Communion',
    source = 'https://www.bg-wiki.com/ffxi/The_Communion',
    images = {},
    meta_order = {'Name', 'Required Fame', 'Level Restriction', 'Starting NPC', 'Pack', 'Title', 'Repeatable', 'Description', 'Previous Quest', 'Next Quest', 'Requirements', 'Rewards'},
    meta = {
        ['Name'] = 'The Communion',
        ['Required Fame'] = '{p:Adoulin|Category:Adoulin Quests} Fame Level: __Unknown__',
        ['Level Restriction'] = 'Level 90+ Geomancer',
        ['Starting NPC'] = '{p:Sylvie}, {z:Western Adoulin} (I-5)',
        ['Pack'] = 'Seekers of Adoulin',
        ['Title'] = 'Storied Geomancer',
        ['Repeatable'] = '__No__',
        ['Description'] = 'Lhaiso Neftereh has fallen ill, perhaps because of the anomalies in the earth. Sylvie wants you to accompany her to the Order of Renaye residence in Eastern Adoulin to check up on Lhaiso.',
        ['Previous Quest'] = '{q:The Bloodline of Zacariah|The Bloodline of Zacariah|The Bloodline of Zacariah}',
        ['Next Quest'] = '{q:Geomancer Relic Armor|Geomancer Relic Armor|Geomancer Relic Armor}{br} {q:Saved by the Bell|Saved by the Bell|Saved by the Bell}',
        ['Requirements'] = '{@k} {k:Lhaiso Neftereh\'s bell}',
        ['Rewards'] = '{@i:Geomancy Pants|28206} {i:Geomancy Pants|Geomancy Pants|28206}{br} Up to 10,000 {p:Bayld}'
    },
    body = [=[
>**{c=red:You must wait until the next game day after completing }{q:The Bloodline of Zacariah|The Bloodline of Zacariah|The Bloodline of Zacariah}{c=red: to begin this quest!}**
=2 Walkthrough
* Speak to {p:Sylvie} at {z:Western Adoulin} Waterfront (I-5) Waypoint #9 to begin the quest.
** {p:Geomancer} must be set as your main job to activate the quest. Can be completed as any job.
* **{c=red:WARNING:}** The following two Windower addons will crash your game if you attempt this quest while running them:
** **"FastCS"** causes this cutscene to freeze. Unload the addon (//lua u fastcs) before speaking to Nhili Uvolep if you use it. Also make sure you're at 30 fps (//config FrameRateDivisor 2) - froze Apr '23 because of this.
* Speak to {n:Nhili Uvolep} at {z:Eastern Adoulin} (I-7), Sverdhried Hillock Waypoint #7, for another **cutscene** and to receive the {k:Lhaiso Neftereh's bell} Key Item.
** If you still have the {p:Trial Wand} or receive the quest {q:Geomancerrific|Geomancerrific|Geomancerrific} instead from Nhili Uvolep, talk to her twice to trigger the right cutscene.
** Those not in possession of {k:Lhaiso Neftereh's bell} Key Item will receive a {p:Bayld} reward. The size of the reward depends on the number of players present for assisting with defeating the Ancestral Rage. You can only receive this reward once.
* Travel to M-8/9 in {z:Cirdas Caverns} and examine the **Overgrown Grave** for a **cutscene**.
** {z:Cirdas Caverns} - {p:Augural Conveyor} is the fastest warp, otherwise {z:Yorcia Weald} Frontier Station.
** A {p:Colonization Reive} may block the way and will need to be cleared to reach the grave.
* Examine the **Overgrown Grave** again to spawn an Ancestral Rage NM.
** Has approximately 70k HP.
** This NM is a Gravitation elemental (earth and darkness) with very high physical damage reduction.
** Uses high level Earth and Darkness magic including Sleepga 2, AOE Drain, and AOE Aspir.
** Can use Entomb (AOE Earth damage, Slow, Petrify, and Hate Reset) and Tenebral Crush (AOE Darkness damage, Defense Down).
** {p:Monk} job ability {p:Formless Strikes} does not work on this NM.
** Can be slept with {s:Repose} and {p:Lullaby}.
* Upon defeating the Ancestral Rage, examine the **Overgrown Grave** again for a **cutscene**.
* Return to {p:Sylvie} for one **last cutscene**, your **reward**, and title. You will also lose {k:Lhaiso Neftereh's bell}.

]=],
}
