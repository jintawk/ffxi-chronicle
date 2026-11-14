-- Step progress for Headstone Pilgrimage (Rise of the Zilart mission 5, mission id 10). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/rotz/05_Headstone_Pilgrimage.lua; key items 239 fire, 240 water, 241 earth, 242 wind,
-- 243 lightning, 244 ice, 245 light fragment (res/key_items.lua). Each Cermet Headstone plays event 200 (and 201 on the cooldown
-- path) only after a prompt whose option 1 does the work, and the NM headstones play 200 to spawn the fight, so no headstone event is
-- used; what proves a bullet is the fragment's key item being gained (the zone message "Obtained key item", or on the last fragment
-- "You now have all 8 fragments of light!"). The seven fragments can be collected in any order, so each has its own group opened by
-- the previous mission (id 8) being done, and every one still to collect is next. The last fragment also completes the mission
-- (giveFragment -> mission:complete): bullet 32 carries the completed id and that message, and implies all seven. The fragments stay
-- held until mission 14 takes them, so the login snapshot (ki_have) ticks a fragment already owned. Gilgamesh 9 is a reminder that
-- proves nothing. Dropped from the draft: bullet 2 (a tip, not an accept), its eight headstone event guesses on bullet 10, and the
-- no-signal bullets 3 and 16 (the Opo-opo Necklace and Flagellant's Rope trades are optional item rewards).
return {
    title = 'Headstone Pilgrimage',
    completes = 's32',
    known = {{t = 'mission', line = 'zilart', min = 8, completed = true}},
    groups = {
        earth = {start = {{t = 'mission', line = 'zilart', min = 8, completed = true}}},
        water = {start = {{t = 'mission', line = 'zilart', min = 8, completed = true}}},
        ice = {start = {{t = 'mission', line = 'zilart', min = 8, completed = true}}},
        fire = {start = {{t = 'mission', line = 'zilart', min = 8, completed = true}}},
        lightning = {start = {{t = 'mission', line = 'zilart', min = 8, completed = true}}},
        wind = {start = {{t = 'mission', line = 'zilart', min = 8, completed = true}}},
        light = {start = {{t = 'mission', line = 'zilart', min = 8, completed = true}}},
    },
    steps = {
        {id = 's10', group = 'earth', at = {n = 10, fp = 'move in a southwesterly direction towards'},
         done = {
            {t = 'ki', id = 241, gained = true, why = 'Earth fragment obtained (Western Altepa Desert headstone)'},
            {t = 'ki_have', id = 241, have = true, why = 'Earth fragment held'},
            {t = 'chat', re = 'obtained key item: earth fragment', why = 'chat: key item obtained'},
         }},
        {id = 's12', group = 'water', at = {n = 12, fp = 'proceed to la theine plateau and'},
         done = {
            {t = 'ki', id = 240, gained = true, why = 'Water fragment obtained (La Theine Plateau headstone)'},
            {t = 'ki_have', id = 240, have = true, why = 'Water fragment held'},
            {t = 'chat', re = 'obtained key item: water fragment', why = 'chat: key item obtained'},
         }},
        {id = 's13', group = 'ice', at = {n = 13, fp = 'make your way to the cloister'},
         done = {
            {t = 'ki', id = 244, gained = true, why = 'Ice fragment obtained (Cloister of Frost headstone)'},
            {t = 'ki_have', id = 244, have = true, why = 'Ice fragment held'},
            {t = 'chat', re = 'obtained key item: ice fragment', why = 'chat: key item obtained'},
         }},
        {id = 's19', group = 'fire', at = {n = 19, fp = 'once outside gather everyone up and'},
         done = {
            {t = 'ki', id = 239, gained = true, why = 'Fire fragment obtained (Yuhtunga Jungle headstone, after Carthi and Tipha)'},
            {t = 'ki_have', id = 239, have = true, why = 'Fire fragment held'},
            {t = 'chat', re = 'obtained key item: fire fragment', why = 'chat: key item obtained'},
         }},
        {id = 's21', group = 'lightning', at = {n = 21, fp = 'clear the area of mobs and'},
         done = {
            {t = 'ki', id = 243, gained = true, why = "Lightning fragment obtained (Behemoth's Dominion headstone, after the two Weapons)"},
            {t = 'ki_have', id = 243, have = true, why = 'Lightning fragment held'},
            {t = 'chat', re = 'obtained key item: lightning fragment', why = 'chat: key item obtained'},
         }},
        {id = 's26', group = 'wind', at = {n = 26, fp = 'check the headstone to pop a'},
         done = {
            {t = 'ki', id = 242, gained = true, why = 'Wind fragment obtained (Cape Teriggan headstone, after Axesarion)'},
            {t = 'ki_have', id = 242, have = true, why = 'Wind fragment held'},
            {t = 'chat', re = 'obtained key item: wind fragment', why = 'chat: key item obtained'},
         }},
        {id = 's30', group = 'light', at = {n = 30, fp = 'defeat the nm and check the'},
         done = {
            {t = 'ki', id = 245, gained = true, why = "Light fragment obtained (Sanctuary of Zi'Tah headstone, after Doomed Pilgrims)"},
            {t = 'ki_have', id = 245, have = true, why = 'Light fragment held'},
            {t = 'chat', re = 'obtained key item: light fragment', why = 'chat: key item obtained'},
         }},
        {id = 's32', implies = {'s10', 's12', 's13', 's19', 's21', 's26', 's30'}, at = {n = 32, fp = 'upon obtaining the final fragment you'},
         done = {
            {t = 'mission', line = 'zilart', eq = 10, completed = true, why = 'mission log: Headstone Pilgrimage completed'},
            {t = 'chat', re = 'you now have all 8 fragments of light', why = 'the last fragment (FOUND_ALL_FRAGS message)'},
         }},
    },
}
