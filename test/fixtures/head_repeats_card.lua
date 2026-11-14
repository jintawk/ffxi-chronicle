-- fixture (rule 176): a quest page whose infobox has a Starting NPC with no zone and a Pack, the very words the guide card prints for NPC and FAME
-- (v1 keeps the pack in `fame`); it is no entry of Chronicle's, so the card is the one the test draws it under
return {
    page = 'Fixture', title = 'Fixture', source = '', images = {},
    meta_order = {'Name', 'Starting NPC', 'Pack'},
    meta = {
        ['Name'] = 'Fixture',
        ['Starting NPC'] = 'Voidwatch Officer',
        ['Pack'] = 'Wings of the Goddess',
    },
    body = [==[
=2 Walkthrough
Talk to the officer.
]==],
}
