-- fixture: a quest page whose infobox has a Rewards row the card does not show (the entry is not Chronicle's), so it stays in
-- the header; the self-test tells the drawing the card has a reward and requires the page to catch the loss
return {
    page = 'Fixture', title = 'Fixture', source = '', images = {},
    meta_order = {'Name', 'Rewards'},
    meta = {
        ['Name'] = 'Fixture',
        ['Rewards'] = '500 gil',
    },
    body = [==[
=2 Walkthrough
Talk to the guard.
]==],
}
