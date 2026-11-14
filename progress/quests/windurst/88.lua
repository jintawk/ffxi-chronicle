-- Step progress for Escort for Hire (Windurst quest 88). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat has no script for this quest and the client event scripts hold none for Dehn Harzhapan or Wanzo-Unzozo
-- (steps rest on the page and the key item: res/key_items.lua 346 completion certificate, a temporary key item the page
-- names in bullet 11 and lists as the requirement of the next escort quest). The draft mapped the permanent key item 1846 (pouch
-- of weighted stones) to bullet 9 and the completed bit to bullet 11; the pouch appears only in an indented tip and may already
-- be owned, and the quest is handed in to Dehn Harzhapan (bullet 12), so the log's accepted bit belongs to bullet 6, the key item to
-- bullet 11 and the completed bit to bullet 12. Bullets 1 to 5 are notes, 7 to 10 are travel and fight notes. The quest is
-- repeatable once per conquest tally, but no observation opens a second run (the key item is the only new event and it belongs to
-- bullet 11), so there is no `repeatable` entry.
-- Key item 346 (completion certificate) and its line are shared with bastok/70 and the other Escort for Hire quests: gated after s6, ki_have dropped.
return {
    title = 'Escort for Hire (Windurst)',
    completes = 's12',
    known = {{t = 'quest'}},
    steps = {
        {id = 'n1', kind = 'note', with = 's6', at = {n = 1, fp = 'you can only have one escort'}},
        {id = 'n2', kind = 'note', with = 's6', at = {n = 2, fp = 'escort for hire quests can be'}},
        {id = 'n3', kind = 'note', with = 's6', at = {n = 3, fp = 'only one escort for hire quest'}},
        {id = 'n4', kind = 'note', with = 's6', at = {n = 4, fp = 'can summon trusts'}},
        {id = 'n5', kind = 'note', with = 's6', at = {n = 5, fp = 'zoning in with an adventuring fellow'}},
        {id = 's6', at = {n = 6, fp = 'speak to dehn harzhapan to begin'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted'},
         }},
        {id = 'n7', kind = 'note', with = 's11', at = {n = 7, fp = 'head to garlaige citadel'}},
        {id = 'n8', kind = 'note', with = 's11', at = {n = 8, fp = 'as soon as you zone in'}},
        {id = 'n9', kind = 'note', with = 's11', at = {n = 9, fp = 'once the cutscene is over an'}},
        {id = 'n10', kind = 'note', with = 's11', at = {n = 10, fp = 'you will have 30 minutes to'}},
        {id = 's11', at = {n = 11, fp = 'escort wanzo unzozo until he stops'},
         done = {
            {t = 'ki', id = 346, gained = true, after = 's6', why = 'completion certificate obtained'},
            {t = 'chat', re = 'obtained key item: completion certificate', after = 's6', why = 'chat: key item obtained'},
         }},
        {id = 's12', at = {n = 12, fp = 'return to dehn harzhapan for your'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
            {t = 'ki', id = 346, gained = false, after = 's11', conf = 'inferred', why = 'completion certificate handed over'},
         }},
    },
}
