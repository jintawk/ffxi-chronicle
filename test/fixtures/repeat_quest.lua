-- fixture: a quest page whose infobox says Repeatable "Yes, once a week": not the card's default 'No', so it stays
-- in the header (2026-10-20: a header Repeatable equal to the card's printed value is left out)
return {
    page = 'Fixture', title = 'Fixture', source = '', images = {},
    meta_order = {'Name', 'Repeatable'},
    meta = {
        ['Name'] = 'Fixture',
        ['Repeatable'] = 'Yes, once a week',
    },
    body = [==[
=2 Walkthrough
Talk to the guard.
]==],
}
