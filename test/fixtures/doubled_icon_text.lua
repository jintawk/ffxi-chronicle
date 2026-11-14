-- fixture: a page with a pair of identical icons (rule 171) AND an icon label before the same word in text ("trade" beside "(trade)"):
-- the pair is the wiki's, the other is the layout's doubling, and the check must still catch it.
return {
    page = 'Fixture', title = 'Fixture', source = '', images = {}, meta = {},
    body = [==[
=2 Walkthrough
Found with {@g:Element: Thunder|Thunder}{@g:Element: Thunder|Thunder} weather.
Aggro to {@a:trade} (trade) targets.
]==],
}
