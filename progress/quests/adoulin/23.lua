-- Step progress for Forging New Bonds (Adoulin quest 23). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: no LandSandBoat script and no decoded client event (the quest's cutscenes are bare in S4), so the signals are key
-- items and the log, read from BG-wiki's walkthrough (the page's own sub-bullets say where each key item comes and goes):
-- the Rune saber (2354) and the Flask of fruiserum (2355) are handed over at the Tomato Vantage Point, the Flask is lost at the
-- Molten Rift, the Frost-encrusted flame gem (2356) is the Staumarth drop, and the Barrel takes the saber and the gem. All three
-- are temporary key items from res/key_items.lua. The draft gave the saber and the gem to bullet 2 (the Barrel) and the Flask
-- to the last step; that reverses the page. Octavien starts the quest (BG-wiki), so the accepted bit is bullet 1's signal; the
-- Barrel cutscenes (2 and 7) have no signal of their own and are notes on the step they lead into. The draft put the completed
-- bit on bullet 3; the quest completes when Octavien hands over the Beorc Sword at bullet 8. Not repeatable.
return {
    title = 'Forging New Bonds',
    completes = 's8',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'zone and come back to speak'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Octavien starts the quest)'},
         }},
        {id = 's2', kind = 'note', with = 's3', at = {n = 2, fp = 'check the inconspicuous barrel in western'}},
        {id = 's3', at = {n = 3, fp = 'check the tomato vantage point in'},
         done = {
            {t = 'ki', id = 2354, gained = true, after = 's1', why = 'rune saber obtained at the Tomato Vantage Point'},
            {t = 'ki_have', id = 2354, have = true, why = 'rune saber held'},
            {t = 'chat', re = 'obtained key item: rune saber', why = 'chat: key item obtained'},
            {t = 'ki', id = 2355, gained = true, after = 's1', why = 'flask of fruiserum obtained at the Tomato Vantage Point'},
            {t = 'ki_have', id = 2355, have = true, why = 'flask of fruiserum held'},
            {t = 'chat', re = 'obtained key item: flask of fruiserum', why = 'chat: key item obtained'},
         }},
        {id = 's4', at = {n = 4, fp = 'go to moh gates and trade'},
         done = {
            {t = 'ki', id = 2355, gained = false, after = 's3', why = 'flask of fruiserum lost at the Molten Rift'},
         }},
        {id = 's5', at = {n = 5, fp = 'check the molten rift again to'},
         done = {
            {t = 'ki', id = 2356, gained = true, after = 's3', why = 'frost-encrusted flame gem obtained from Staumarth'},
            {t = 'ki_have', id = 2356, have = true, why = 'frost-encrusted flame gem held'},
            {t = 'chat', re = 'obtained key item: frost%-encrusted flame gem', why = 'chat: key item obtained'},
         }},
        {id = 's6', at = {n = 6, fp = 'check the inconspicuous barrel in western'},
         done = {
            {t = 'ki', id = 2354, gained = false, after = 's5', why = 'rune saber taken at the Barrel'},
            {t = 'ki', id = 2356, gained = false, after = 's5', why = 'frost-encrusted flame gem taken at the Barrel'},
         }},
        {id = 's7', kind = 'note', with = 's8', at = {n = 7, fp = 'check the inconspicuous barrel after one'}},
        {id = 's8', at = {n = 8, fp = 'talk with octavien to receive the'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed'},
         }},
        {id = 's9', kind = 'note', with = 's8', at = {n = 9, fp = 'note completing this quest allows the'}},
    },
}
