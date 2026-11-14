-- fixture: an infobox whose Time Limit is the wiki's own "?" (campaign 214: unknown). The label is short, so the value stands in its
-- column more than 40 px from it (rule 187): the value is the page's, not a line broken down to a "?"
return {
    page = 'Fixture', title = 'Fixture', source = '', images = {},
    meta_order = {'Name', 'Campaign Type', 'Time Limit', 'Recommended Lv.'},
    meta = {
        ['Name'] = 'Fixture',
        ['Campaign Type'] = 'Intel gathering',
        ['Time Limit'] = '?',
        ['Recommended Lv.'] = 'Any',
    },
    body = [==[
=2 Walkthrough
Talk to the officer.
]==],
}
