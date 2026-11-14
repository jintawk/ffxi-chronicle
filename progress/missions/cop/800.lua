-- Step progress for Garden of Antiquity (Chains of Promathia 8-1, mission id 800). Data only; see progress/missions/sandoria/0.lua.
-- Evidence: LandSandBoat scripts/missions/cop/8_1_Garden_of_Antiquity.lua (no client script for any of the Al'Taieu or Hu'Xzoi
-- objects, so every event below is LandSandBoat only). The Crystalline Field (_0x0, Al'Taieu 33) plays 164 at status 0 (bullet 1)
-- and, once all three Rubious Crystals have had their trio defeated, 100 (bullet 3; its finish sets status 2 whichever option is
-- chosen, option 1 moves the player into Hu'Xzoi). The Rubious Crystals (_0x1 to _0x3) play 161 on the first finished tower, 162 on
-- the second and 163 on the third (bullet 2), so 163 proves the bullet and 161 / 162 mark it as under way. In the Grand Palace of
-- Hu'Xzoi (34) the Gate of the Gods (_iya) plays 1 at status 2 and hands over the Tavnazian Ring (bullet 4; the ring is a reward and
-- is not used), and the east Particle Gate (_iyb) plays 2 at status 3, which completes the mission (bullet 5; the next mission's
-- bullet 1 on the page is this same cutscene). The draft put event 100 on bullet 1 and the Gate of the Gods / Particle Gate events
-- one bullet early, and made the completing bullet a post step; fixed.
return {
    title = 'Garden of Antiquity',
    completes = 's5',
    known = {{t = 'mission', line = 'cop', eq = 800}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'examine the crystalline field at h'},
         done = {
            {t = 'event', zone = 33, event = 164, why = 'Crystalline Field 164 (status 0, LandSandBoat)'},
         }},
        {id = 's2', at = {n = 2, fp = 'examine the 3 rubious crystals to'},
         done = {
            {t = 'event', zone = 33, event = 163, why = 'Rubious Crystal 163: the third tower finished (LandSandBoat)'},
         },
         reach = {
            {t = 'event', zone = 33, event = 161, why = 'Rubious Crystal 161: the first tower finished'},
            {t = 'event', zone = 33, event = 162, why = 'Rubious Crystal 162: the second tower finished'},
         }},
        {id = 's3', at = {n = 3, fp = 'return to and examine the crystalline'},
         done = {
            {t = 'event', zone = 33, event = 100, why = 'Crystalline Field 100: all three towers done (finish sets status 2)'},
         }},
        {id = 's4', at = {n = 4, fp = 'inside examine the gate of the'},
         done = {
            {t = 'event', zone = 34, event = 1, why = 'Gate of the Gods 1 (status 2): the Tavnazian Ring'},
         }},
        {id = 's5', at = {n = 5, fp = 'then touch the east particle gate'},
         done = {
            {t = 'mission', line = 'cop', eq = 800, completed = true, why = 'mission log: Garden of Antiquity completed'},
            {t = 'event', zone = 34, event = 2, why = 'Particle Gate 2 (status 3): completes'},
         }},
        {id = 's6', kind = 'note', with = 's5', at = {n = 6, fp = 'in the name of science is'}},
    },
}
