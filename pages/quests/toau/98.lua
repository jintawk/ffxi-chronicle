-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Promotion:_First_Lieutenant). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Promotion: First Lieutenant',
    title = 'Promotion: First Lieutenant',
    source = 'https://www.bg-wiki.com/ffxi/Promotion:_First_Lieutenant',
    images = {},
    meta_order = {'Name', 'Required Fame', 'Level Restriction', 'Starting NPC', 'Pack', 'Title', 'Repeatable', 'Description', 'Previous Quest', 'Next Quest', 'Requirements', 'Rewards'},
    meta = {
        ['Name'] = 'Promotion: First Lieutenant',
        ['Required Fame'] = '{p:Aht Urhgan|Category:Aht Urhgan Quests} Fame Level: 1',
        ['Level Restriction'] = 'None',
        ['Starting NPC'] = '{q:Salaheem\'s Sentinels|Salaheem\'s Sentinels|Salaheem\'s Sentinels} - {z:Aht Urhgan Whitegate} (1-10)',
        ['Pack'] = 'Treasures of Aht Urhgan',
        ['Title'] = 'First Lieutenant',
        ['Repeatable'] = '__No__',
        ['Description'] = 'Your final term at the Salaheem Officer Academy has begun. Will all the cadets survive until graduation...?',
        ['Previous Quest'] = '{q:Promotion: Second Lieutenant|Promotion: Second Lieutenant|Promotion: Second Lieutenant}',
        ['Next Quest'] = '{q:Promotion: Captain|Promotion: Captain|Promotion: Captain}',
        ['Requirements'] = 'Complete 25 points worth of {p:Assaults|Assault} as {p:Second Lieutenant}{br} 5 {i:Imperial Gold Pieces|Imperial Gold Piece|2187}',
        ['Rewards'] = '{k:FL Wildcat badge}{br} Access to {p:FL|Category:Assault} Assaults'
    },
    body = [=[
=2 Rhapsodies of Vanadiel
{p:Curio Vendor Moogles|Curio Vendor Moogle} will sell the {p:Key Item} reward once {k:"Rhapsody in Azure"} is obtained from {p:Rhapsodies of Vanadiel}.
=2 Walkthrough
* The quest is started by entering the {q:Salaheem's Sentinels|Salaheem's Sentinels|Salaheem's Sentinels} office.
* Trade {n:Abquhbah} 5 {i:Imperial Gold Pieces|Imp. Gold Piece|2187}.
* Wait until the game day changes and zone.
* Talk to {n:Abquhbah} to start the first trial.

>**Trial 1: Logic Puzzle**
* In this task, you will be shown 12 humes. Some of these humes are actually Qiqirn spies. By using a limited number of queries, you must determine which of the humes are spies.
* There are 2 types of queries:
** One will tell you how many spies are in a consecutive set of 4 humes.
** One will tell you how many spies are in a pair of humes.
* You must solve 3 rounds to succeed at this task.
** First, there are 3 spies, and you may ask about 5 sets and 5 pairs.
** Second, there are 4 spies, and you may ask about 5 sets and 4 pairs.
** Third, there are 5 spies, and you may ask about 6 sets and 5 pairs.
* If you fail, you may retry the following Earth minute for no additional fee.

* After you succeed, wait for the game day to change and zone.
* Talk to {n:Abquhbah} to start the second trial.

>**Trial 2: Word substitution**
* In this task, you will be asked several questions in a cipher. You must respond correctly in the cipher language.
* Language:

|^Word|Subsitution|Word|Subsitution|Word|Subsitution
|**Aaka**|You|**Keean**|Okay|**Raloosha**|Ayran
|**Aata**|Chai|**Kiichi**|Instructor|**Shidet**|Cadet
|**Ankii**|Thank you|**Kolcha**|Coffee|**Shooya**|Revision
|**Chifaan**|Different|**Konhe**|Hello|**Sooto**|That
|**Churuuk**|Attention|**Kosu**|This|**Taafu**|Food
|**Dogoog**|Fail|**Lakiino**|Like|**Tachiito**|Sutlac
|**Dooto**|Which|**Lukiina**|Dislike|**Tsuto**|Next
|**Een**|No|**Miil**|Everyone|**Una**|Now
|**Goog**|Pass|**Nawaan**|What|**Waami**|I
|**Haes**|Yes|**Nooku**|Drink|**Wande**|Bad
|**Jinrii**|Training|**Oim**|Same|**Yonde**|Good

* You will be asked 4 questions. The correct answers are:
** Haes, Waami lakiino kiichi.
** Waami lakiino tachiito!
** Waami lakiino Yasmeel.
** Waami lakiino kolcha.

* If you fail, you may retry the following Earth minute for no additional fee.
* After you succeed, wait a game day and zone.
* Talk to {n:Abquhbah} to start the third trial.

>**Trial 3: BCG**
* This game is the same as Rock-Paper-Scissors.
** You and a foe will each choose a critter.
** Based on the critters chosen, the round will either be a tie or a win for either the player or foe.
** In the event of a win, the bomb behind the loser will explode, and the loser will lose points.
*** By default, the loser will lose 1 point for losing a round.
*** In the event of a tied round, the bomb behind each player will grow, increasing the points lost by 1.
*** When the bomb explodes, its size is set to normal and the points lost returns to 1.
** To win, reduce your opponents to 0 points.
* The three critters are __B__eetle, __C__rab, and __G__host.
** Ghosts defeat Beetles.
** Beetles defeat Crabs.
** Crabs defeat Ghosts.
* The first opponent you fight, after a lengthy cutscene, is Arcuhbah.
** He will use a simple repeating sequence of the 3 options. For example, if he chooses crab first, his next choice will be beetle or ghost, and his third choice will be the remaining critter.
* The second opponent you fight is a team-up of Fubruhn and Ugrihd.
** These two will tip off what their choice will be based on the emote they use and their current plan.
*** __Nod__ can either be Beetle (plan 1) or Crab (plan 2). If you don't know their current plan, choose Beetle.
*** __Laugh__ can either be Ghost (plan 1) or Beetle (plan 2). If you don't know their current plan, choose Ghost.
*** __Psych__ can either be Crab (plan 1) or Ghost (plan 2). IF you don't know their current plan, choose Crab.
* The third opponent you fight is the Drill Sergeant.
** He will use a repeating sequence of 4 choices.
** Either on every even-numbered round or on every odd-numbered round he will pick the same critter.
** On the other rounds, he will alternate between the 2 critters he doesn't pick on even-numbered rounds.
** For example: Crab, Ghost, Beetle, Ghost, repeat.
** If he falls below 4 points, he will cheat and restore himself to 4 points
** In order to beat him, bring him to 4 points, tie him three times, and then win once to K.O. him in one shot.
* The final opponent you fight is Koja Salaheem.
** The battle will be decided in a single round.
** Choose Beetle to defeat Koja.
* After winning, wait until the game day changes and zone.
* Talk to {n:Abquhbah} between 15:00 and 17:00 game-time to complete the quest.

]=],
}
