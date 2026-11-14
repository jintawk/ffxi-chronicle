-- fixture: an assault page's infobox with an Objective and the Mission Orders paragraph (rule 126); it is no entry of Chronicle's, so
-- its card prints nothing for them unless the self-test says the card's description is the same words
return {
    page = 'Fixture', title = 'Fixture', source = '', images = {},
    meta_order = {'Name', 'Objective', 'Mission Orders', 'Time Limit'},
    meta = {
        ['Name'] = 'Fixture',
        ['Objective'] = 'Collect ahtapot',
        ['Mission Orders'] = 'To increase production of special nighttime camouflage, the marines require a secretion.',
        ['Time Limit'] = '30 minutes',
    },
    body = [==[
=2 Walkthrough
Talk to the guard.
]==],
}
