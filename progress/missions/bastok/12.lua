-- Step progress for Jeuno (Bastok mission 3-3, mission id 12). Data only; see progress/missions/sandoria/0.lua for the format.
-- Evidence: LandSandBoat scripts/missions/bastok/3_3_Jeuno.lua. The page has no accept bullet; the nation line moving to id 12
-- (65535 = no mission before; completing sets it back to 65535 and adds id 12 to the completed set) only marks the mission as
-- known. Lucius (Metalworks 237) event 322 hands over the Letter to the ambassador (key item 30, res/key_items.lua); Goggehn
-- (Ru'Lude Gardens 243) event 41 takes it; the Cermet Door in Lower Delkfutt's Tower (184) plays cutscene 1 only with
-- the mission at status 2 and the Delkfutt key (otherwise a server message), which sets status 3; the Bastokan Embassy door
-- (243) event 38 plays only at status 3 and completes the mission. Events 322, 41 and the door's 1 and 38 have no decoded body
-- in the client scripts (237_Lucius_010ED018.txt and 243_Goggehn_010F3003.txt list 322 and 41; the two doors are not decoded):
-- their ids come from LandSandBoat. Goggehn's 66 and 139 are reminder talks and prove nothing more. The Delkfutt key is a
-- permanent key item that can be owned already, so it is not used. Every bullet after the fourth is route advice for getting the
-- key (notes); the two that repeat the embassy cutscene (9 and 32) take the completing step's state.
return {
    title = 'Jeuno',
    completes = 's4',
    known = {{t = 'mission', line = 'bastok', eq = 12}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to lucius located at the'},
         done = {
            {t = 'event', zone = 237, event = 322, why = 'Lucius 322: the Letter to the ambassador handed over'},
            {t = 'ki', id = 30, gained = true, why = 'Letter to the ambassador obtained'},
            {t = 'ki_have', id = 30, have = true, why = 'Letter to the ambassador held'},
            {t = 'chat', re = 'obtained key item: letter to the ambassador', why = 'chat: key item obtained'},
         }},
        {id = 's2', at = {n = 2, fp = 'head to the bastokan embassy in'},
         done = {
            {t = 'event', zone = 243, event = 41, why = 'Goggehn 41: the Letter to the ambassador handed over'},
            {t = 'ki', id = 30, gained = false, why = 'Letter to the ambassador taken'},
         }},
        {id = 's3', at = {n = 3, fp = 'head to lower delkfutt s tower'},
         done = {
            {t = 'event', zone = 184, event = 1, why = 'Cermet Door 1: the cutscene with the Delkfutt key (played only at status 2)'},
         }},
        {id = 's4', at = {n = 4, fp = 'return to the bastokan embassy in'},
         done = {
            {t = 'mission', line = 'bastok', eq = 12, completed = true, why = 'mission log: Jeuno completed'},
            {t = 'event', zone = 243, event = 38, why = 'Door: Bastokan Emb. 38: the mission completed'},
         }},
        {id = 's5', kind = 'note', with = 's4', at = {n = 5, fp = 'next you can open the door'}},
        {id = 's6', kind = 'note', with = 's4', at = {n = 6, fp = 'click it to travel to upper'}},
        {id = 's7', kind = 'note', with = 's4', at = {n = 7, fp = 'porphyrion kill this nm then trade'}},
        {id = 's8', kind = 'note', with = 's4', at = {n = 8, fp = 'after using the elevator proceed down'}},
        {id = 's9', kind = 'note', with = 's4', at = {n = 9, fp = 'return to the bastokan embassy in'}},
        {id = 's10', kind = 'note', with = 's4', at = {n = 10, fp = 'sneak invisible status or prism powder'}},
        {id = 's11', kind = 'note', with = 's4', at = {n = 11, fp = 'some form of reraise and warp'}},
        {id = 's12', kind = 'note', with = 's4', at = {n = 12, fp = 'a map of qufim island and'}},
        {id = 's13', kind = 'note', with = 's4', at = {n = 13, fp = 'make your way to port jeuno'}},
        {id = 's14', kind = 'note', with = 's4', at = {n = 14, fp = 'enter lower delkfutt s tower at'}},
        {id = 's15', kind = 'note', with = 's4', at = {n = 15, fp = 'once inside prepare for a long'}},
        {id = 's16', kind = 'note', with = 's4', at = {n = 16, fp = 'floor 1 lower delkfutt s tower'}},
        {id = 's17', kind = 'note', with = 's4', at = {n = 17, fp = 'floor 2'}},
        {id = 's18', kind = 'note', with = 's4', at = {n = 18, fp = 'floor 3'}},
        {id = 's19', kind = 'note', with = 's4', at = {n = 19, fp = 'floor 4 middle delkfutt s tower'}},
        {id = 's20', kind = 'note', with = 's4', at = {n = 20, fp = 'floor 5 half way there'}},
        {id = 's21', kind = 'note', with = 's4', at = {n = 21, fp = 'floor 6'}},
        {id = 's22', kind = 'note', with = 's4', at = {n = 22, fp = 'floor 7'}},
        {id = 's23', kind = 'note', with = 's4', at = {n = 23, fp = 'floor 8'}},
        {id = 's24', kind = 'note', with = 's4', at = {n = 24, fp = 'floor 9'}},
        {id = 's25', kind = 'note', with = 's4', at = {n = 25, fp = 'floor 8 again'}},
        {id = 's26', kind = 'note', with = 's4', at = {n = 26, fp = 'floor 9 again'}},
        {id = 's27', kind = 'note', with = 's4', at = {n = 27, fp = 'floor 10 upper delkfutt s tower'}},
        {id = 's28', kind = 'note', with = 's4', at = {n = 28, fp = 'kill porphyrion and any aggro you'}},
        {id = 's29', kind = 'note', with = 's4', at = {n = 29, fp = 'once you have your key trade'}},
        {id = 's30', kind = 'note', with = 's4', at = {n = 30, fp = 'walk down the long staircase after'}},
        {id = 's31', kind = 'note', with = 's4', at = {n = 31, fp = 'once you reach the basement head'}},
        {id = 's32', kind = 'note', with = 's4', at = {n = 32, fp = 'return to the bastokan embassy in'}},
        {id = 's33', kind = 'note', with = 's4', at = {n = 33, fp = 'you do not have to be'}},
    },
}
