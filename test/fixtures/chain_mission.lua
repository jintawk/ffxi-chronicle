-- fixture: a mission page whose infobox has a real Previous Mission and Next Mission; it is no entry of Chronicle's, so no
-- guide card shows a chain for it and both stay in the header (2026-10-21, rule 67: the header repeated the card's chain)
return {
    page = 'Fixture', title = 'Fixture', source = '', images = {},
    meta_order = {'Name', 'Previous Mission', 'Next Mission'},
    meta = {
        ['Name'] = 'Fixture',
        ['Previous Mission'] = '{M:Fixture One|Fixture One|Fixture One}',
        ['Next Mission'] = '{M:Fixture Two|Fixture Two|Fixture Two}',
    },
    body = [==[
=2 Walkthrough
Talk to the guard.
]==],
}
