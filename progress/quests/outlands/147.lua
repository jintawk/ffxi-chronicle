-- Step progress for Bugi Soden (Outlands quest 147). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/outlands/Bugi_Soden.lua. Ryoma 184 is the offer (a menu; only option 1 hands over the
-- Kodachi of Trials and the Weapon training guide and begins the quest), so the event, its opening line and the guide's gain
-- (a key item the other weapon skill quests give too) are not accept proof: the quest log's current bit is, with the accept-only
-- line (say #10835). 185 is his reminder while accepted (its menu also lets you quit). 187 is the Kodachi of Trials trade, played
-- only when the weapon has 300 points (186 is the unfinished refusal) and gives the Map to the Annals of Truth (344); 188 is his
-- reminder once the map is held. The ??? in the Labyrinth of Onzozo pops Megapod Megalops and then gives the Annals of Truth
-- (345; The Potential Within uses 343 to 345 too, so each gain after s2 is gated on the quest-specific step before it). Ryoma 189
-- runs quest:complete and takes the key items. Client event script S4 252_Ryoma_010FC03A.txt (184 accept branch say #10835,
-- 185 say #10840, 187 say #10851, 188 say #10853, 189 say #10854). The quest log is set at the accept step, so it is not
-- silent. Not repeatable. Bullets 3 to 5 (the latent) are an indented list, not steps.
-- Draft corrections: 184's line and the guide's gain are not accept proof, 188 belongs to bullet 6 (the map is held) not bullet 9,
-- 187's line was missing and the Annals gain is gated after s6.
return {
    title = 'Bugi Soden',
    completes = 's9',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'you cannot start this quest if'}},
        {id = 's2', at = {n = 2, fp = 'speaking with ryoma will grant you'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Ryoma 184, option 1)'},
            {t = 'chat', re = "I knew that you couldn.t resist the challenge", why = 'Ryoma 184, accept branch (say #10835)'},
            {t = 'ki', id = 343, gained = true, why = 'weapon training guide obtained (also given by other weapon skill quests)'},
            {t = 'ki_have', id = 343, have = true, why = 'weapon training guide held'},
            {t = 'event', zone = 252, event = 185, conf = 'inferred', why = 'Ryoma 185: his reminder, only while accepted'},
            {t = 'chat', re = "When you.ve acquired enough skill, the", conf = 'inferred', why = 'Ryoma 185 (say #10840)'},
         },
         reach = {{t = 'event', zone = 252, event = 184, why = 'Ryoma 184 offered (its finish needs option 1)'}}},
        {id = 's6', at = {n = 6, fp = 'trade the kodachi of trials back'},
         done = {
            {t = 'event', zone = 252, event = 187, after = 's2', why = 'Ryoma 187: the finished Kodachi of Trials accepted (186 is the refusal)'},
            {t = 'chat', re = 'Well, it.s about time%.', after = 's2', why = 'Ryoma 187 (say #10851)'},
            {t = 'ki', id = 344, gained = true, after = 's2', why = 'map to the Annals of Truth obtained'},
            {t = 'ki_have', id = 344, have = true, after = 's2', why = 'map to the Annals of Truth held'},
            {t = 'chat', re = 'obtained key item: map to the annals of truth', after = 's2', why = 'chat: key item obtained'},
            {t = 'event', zone = 252, event = 188, after = 's2', conf = 'inferred', why = 'Ryoma 188: his reminder, only once the map is held'},
            {t = 'chat', re = "Don.t make me repeat myself!", after = 's2', conf = 'inferred', why = 'Ryoma 188 (say #10853)'},
         }},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'take silent oil and prism powder'}},
        {id = 's8', at = {n = 8, fp = 'this fight is against megapod megalops'},
         done = {
            {t = 'ki', id = 345, gained = true, after = 's6', why = 'Annals of Truth obtained (also given by The Potential Within)'},
            {t = 'ki_have', id = 345, have = true, after = 's6', why = 'Annals of Truth held'},
            {t = 'chat', re = 'obtained key item: annals of truth', after = 's6', why = 'chat: key item obtained'},
         }},
        {id = 's9', at = {n = 9, fp = 'go back and speak with ryoma'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'event', zone = 252, event = 189, after = 's6', why = 'Ryoma 189: runs quest:complete'},
            {t = 'chat', re = 'Well, what do you know! If you could whip that monster, you should have no problem using any of the deadly katana techniques%.', after = 's6', why = 'Ryoma 189 (say #10854)'},
            {t = 'chat', re = 'You have learned the weapon skill Blade: Ku!', after = 's6', why = 'Norg BLADE_KU_LEARNED'},
            {t = 'ki', id = 345, gained = false, after = 's8', conf = 'inferred', why = 'Annals of Truth handed over'},
            {t = 'ki', id = 344, gained = false, after = 's8', conf = 'inferred', why = 'map to the Annals of Truth handed over'},
            {t = 'ki', id = 343, gained = false, after = 's8', conf = 'inferred', why = 'weapon training guide handed over'},
         }},
    },
}
