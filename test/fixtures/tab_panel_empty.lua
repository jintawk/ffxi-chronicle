-- fixture: a page whose tab panels carry an infobox of a Name and a Reward "None" only. A fixture has no entry, so its card has
-- nothing (it prints "--" for the reward): both fields are left out and no box is drawn (cop 530, 2026-10-20: a panel's box
-- repeated the card; one with nothing left must not be an empty frame)
return {
    page = 'Fixture', title = 'Fixture', source = '', images = {},
    meta_order = {'Name'},
    meta = {
        ['Name'] = 'Fixture',
    },
    body = [==[
=2 Walkthrough
Pick a path.
@tabs
@tab First|(one)
@head Name|First
@head Rewards|None
Text of the first path.
@tab Second|(two)
@head Name|Second
@head Rewards|None
Text of the second path.
@end
]==],
}
