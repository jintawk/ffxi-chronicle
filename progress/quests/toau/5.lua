-- Step progress for An Empty Vessel (Aht Urhgan quest 5). Data only; see progress/quests/sandoria/27.lua for the format.
-- Evidence: LandSandBoat scripts/quests/ahtUrhgan/An_Empty_Vessel.lua (Waoud 60 is the divination menu: only option 50, a
-- passed test, begins the quest, so 60 is a reach; every later talk needs a Vana'diel day and a zone: 65 plays at Prog 0 and
-- sets Prog 1, 66 plays at Prog 1 and says the clue for the treasure, trading the right item at Prog 1 plays 67 and sets Prog 2,
-- 68 plays at Prog 2; the platform trigger area in Aydeewa Subterrane plays 3 at Prog 2 while the item is held: its menu option 13
-- runs quest:complete (title, Blue Mage unlocked, Mark of Zahak and the job gesture) but option 7 refuses Yasfel and DELETES the
-- quest, so 3 is only a reach and the log's completed bit proves bullet 11; the reward key items are not used). Waoud 69, the
-- "gaze away" cutscene on the last bullet, has no text and its finish only clears a flag on option 1, so the last bullet stays a
-- plain bullet. Waoud 63 and 64 are the wait talks and 78 is the paid divination once completed: none is used. Client event
-- script S4 050_Waoud_01032119.txt (66 say #8823, 68 say #8829). Bullets 2-5 are the divination, 6-9 the clues of the treasure
-- (a note on the trade), 12 the return to Whitegate. Not repeatable.
return {
    title = 'An Empty Vessel',
    completes = 's11',
    known = {{t = 'quest'}},
    steps = {
        {id = 's1', at = {n = 1, fp = 'speak to waoud j 10 top'},
         done = {
            {t = 'quest', current = true, why = 'quest log: accepted (Waoud 60, option 50)'},
            {t = 'event', zone = 50, event = 65, why = 'Waoud 65: his next-day talk, only at Prog 0 while accepted'},
            {t = 'event', zone = 50, event = 66, why = 'Waoud 66: the clue, only at Prog 1'},
            {t = 'chat', re = 'I know not the name of the object, but I do recall some clues', why = 'Waoud 66 (say #8823)'},
         },
         reach = {{t = 'event', zone = 50, event = 60, why = 'Waoud 60 offered (its finish needs option 50)'}}},
        {id = 's2', kind = 'note', with = 's1', at = {n = 2, fp = 'he will offer to give you'}},
        {id = 's3', kind = 'note', with = 's1', at = {n = 3, fp = 'upon success waoud will mention seeing'}},
        {id = 's4', kind = 'note', with = 's1', at = {n = 4, fp = 'below is a listing of the'}},
        {id = 's5', kind = 'note', with = 's1', at = {n = 5, fp = 'right after answering all his questions'}},
        {id = 's6', kind = 'note', with = 's10', at = {n = 6, fp = 'when waoud asks for the treasure'}},
        {id = 's7', kind = 'note', with = 's10', at = {n = 7, fp = 'the treasure i would have you'}},
        {id = 's8', kind = 'note', with = 's10', at = {n = 8, fp = 'the treasure i would have you'}},
        {id = 's9', kind = 'note', with = 's10', at = {n = 9, fp = 'the treasure i would have you'}},
        {id = 's10', at = {n = 10, fp = 'trade him the item and he'},
         done = {
            {t = 'event', zone = 50, event = 67, why = 'Waoud 67: the right item traded, only at Prog 1, sets Prog 2'},
            {t = 'event', zone = 50, event = 68, why = 'Waoud 68: only at Prog 2'},
            {t = 'chat', re = 'My colleague is currently part of an Imperial patrol', why = 'Waoud 68 (say #8829)'},
         },
         reach = {{t = 'event', zone = 50, event = 66, why = 'Waoud 66: the clue, the item is still to be found'}}},
        {id = 's11', at = {n = 11, fp = 'enter aydeewa subterrane at g 7'},
         done = {
            {t = 'quest', completed = true, why = 'quest log: completed (the platform cutscene, option 13)'},
         },
         reach = {{t = 'event', zone = 68, event = 3, why = 'platform trigger area 3 (option 7 refuses and deletes the quest)'}}},
        {id = 's12', kind = 'note', with = 's11', at = {n = 12, fp = 'when the cutscene is over you'}},
    },
}
