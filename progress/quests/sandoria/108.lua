-- Step progress for Signed in Blood (San d'Oria quest 108). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/sandoria/Signed_in_Blood.lua (Sobane 732 offers it, option 1 begins it; 733 is her
-- reminder at Prog 0; the trade of the Cathedral Tapestry is 734 (Prog 1); Abelard 1104 at Prog 1 sets Prog 2 and 1105 is
-- his reminder; the Ordelle's Caves chest gives key item 626; Abelard 1106 needs 626 and sets Prog 3; Sobane 736 completes
-- and takes 626; 735 is Sobane's reminder from Prog 1 on); client event scripts S4 230_Sobane_010E601A.txt (733 say #9782,
-- 735 #9810) and 248_Abelard_010F800F.txt (1105 say #7395). The draft put the tapestry trade (734) on the first bullet and
-- Abelard 1106 on the Selbina bullet: 1104 is the first Abelard talk (bullet 3) and 1106 is the return (bullet 6). Abelard
-- 48 also belongs to An Explorer's Footsteps, so it is not used. Key item 626 is lost at Sobane 736, so its loss is not used.
return {
    title = 'Signed in Blood',
    completes = 's7',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to sobane who will request'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
            {t = 'event', zone = 230, event = 733, conf = 'inferred', why = 'Sobane 733: reminder at Prog 0, only once accepted'},
            {t = 'chat', re = 'Should you decide to take up my request, would you be willing to swear a blood oath%?', conf = 'inferred', why = 'Sobane 733 (say #9782)'},
         },
         reach = {{t = 'event', zone = 230, event = 732, why = 'Sobane 732 offered (its finish needs option 1)'}}},
        {id = 's2', at = {n = 2, fp = 'trade the cathedral tapestry to sobane'},
         done = {
            {t = 'event', zone = 230, event = 734, why = 'Sobane 734: the tapestry traded'},
            {t = 'event', zone = 230, event = 735, conf = 'inferred', why = 'Sobane 735: reminder, from Prog 1'},
            {t = 'chat', re = 'Is Count Teulomme truly searching for the knight of Mistalle to cause him harm%?', conf = 'inferred', why = 'Sobane 735 (say #9810)'},
         }},
        {id = 's3', at = {n = 3, fp = 'travel to selbina and speak to'},
         done = {
            {t = 'event', zone = 248, event = 1104, why = 'Abelard 1104: the first talk'},
            {t = 'event', zone = 248, event = 1105, conf = 'inferred', why = 'Abelard 1105: reminder, from Prog 2'},
            {t = 'chat', re = 'Have you heard of Lord Torresapet B Ordelle%?', conf = 'inferred', why = 'Abelard 1105 (say #7395)'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'head to ordelle s caves obtain'}},
        {id = 's5', at = {n = 5, fp = 'use the key on a chest'},
         done = {
            {t = 'ki', id = 626, gained = true, why = 'torn-out pages obtained'},
            {t = 'ki_have', id = 626, have = true, why = 'torn-out pages held'},
            {t = 'chat', re = 'obtained key item: torn%-out pages', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'return to abelard'},
         done = {
            {t = 'event', zone = 248, event = 1106, why = 'Abelard 1106: the pages handed over'},
         }},
        {id = 's7', at = {n = 7, fp = 'speak to sobane to complete this'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         },
         reach = {{t = 'event', zone = 230, event = 736, why = 'Sobane 736: plays even when the Cunning Earring does not fit, so it is not proof'}}},
    },
}
