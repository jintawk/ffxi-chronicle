-- fixture: a quest page whose infobox has a real Previous Quest and Next Quest; it is no entry of Chronicle's, so no
-- guide card shows a chain for it and both stay in the header (2026-10-19)
return {
    page = 'Fixture', title = 'Fixture', source = '', images = {},
    meta_order = {'Name', 'Previous Quest', 'Next Quest'},
    meta = {
        ['Name'] = 'Fixture',
        ['Previous Quest'] = '{q:Fixture One|Fixture One|Fixture One}',
        ['Next Quest'] = '{q:Fixture Two|Fixture Two|Fixture Two}',
    },
    body = [==[
=2 Walkthrough
Talk to the guard.
]==],
}
