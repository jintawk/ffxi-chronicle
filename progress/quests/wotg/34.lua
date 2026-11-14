-- Step progress for Seeing Blood-red (Crystal War quest 34, Wings of the Goddess). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat names the quest (SEEING_BLOOD_RED) but implements nothing (it is only a roe record and a Vingijard
-- requirement); the client event script S4 175_Erlene_010AF2CC.txt has no dialogue for the quest's events and zone 90's
-- Indescript Markings (090_Indescript_Markings_0105A303.txt) is empty, so the page is the source. Key items from
-- res/key_items.lua: the Unaddressed sealed letter (977) is the pickup at the Indescript Markings (n=3) and the Porting magic
-- transcript (978) is Erlene's hand-out after the letter (n=5). The page says the first Erlene cutscene "flags" the quest, so the
-- log's current bit is bullet 2 (inferred from the page text only); the reward comes from Erlene again after the battlefield
-- (n=8), so the completed bit belongs there, not at the transcript. The fight (n=6, 7) and its facts (n=9 to 12) have no signal
-- of their own: notes; the two version-update lines (n=13, 14) are not steps. Not repeatable.
-- Shared-signal audit: neither key item is named by any LandSandBoat script and neither appears under progress/.
return {
    title = 'Seeing Blood-red',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', kind = 'note', with = 's2', at = {n = 1, fp = 'wait until the next game day'}},
        {id = 's2', at = {n = 2, fp = 'speak to erlene the eldieme necropolis'},
         done = {
            {t = 'quest', current = true, conf = 'inferred', why = 'quest log: flagged by this cutscene (page text)'},
         }},
        {id = 's3', at = {n = 3, fp = 'travel to the indescript markings in'},
         done = {
            {t = 'ki', id = 977, gained = true, why = 'Unaddressed sealed letter obtained'},
            {t = 'ki_have', id = 977, have = true, why = 'Unaddressed sealed letter held'},
            {t = 'chat', re = 'obtained key item: unaddressed sealed letter', why = 'chat: key item obtained'},
         }},
        {id = 's4', kind = 'note', with = 's5', at = {n = 4, fp = 'read the unaddressed sealed letter by'}},
        {id = 's5', at = {n = 5, fp = 'return to erlene and talk to'},
         done = {
            {t = 'ki', id = 978, gained = true, why = 'Porting magic transcript obtained'},
            {t = 'ki_have', id = 978, have = true, why = 'Porting magic transcript held'},
            {t = 'chat', re = 'obtained key item: porting magic transcript', why = 'chat: key item obtained'},
         }},
        {id = 's6', kind = 'note', with = 's8', at = {n = 6, fp = 'go to grauberg s e 10'}},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'inspect the indescript markings on the'}},
        {id = 's8', at = {n = 8, fp = 'return to erlene after clearing the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed at Erlene after the battlefield'},
         }},
        {id = 's9', kind = 'note', with = 's8', at = {n = 9, fp = 'the instance has a 30 minute'}},
        {id = 's10', kind = 'note', with = 's8', at = {n = 10, fp = 'you may summon trusts inside'}},
        {id = 's11', kind = 'note', with = 's8', at = {n = 11, fp = 'the fight is against ulbrecht who'}},
        {id = 's12', kind = 'note', with = 's8', at = {n = 12, fp = 'the battle ends once ulbrecht s'}},
    },
}
