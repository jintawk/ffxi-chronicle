-- fixture (rule 178): a page of two tab panels, each a quest infobox whose Pack is the card's FAME, whose Rewards is a key-item icon and the name
-- the card's REWARD prints with a "[Key Item]" tag, and whose Level Restriction says "None" (quest wotg 69); the Description is each panel's own.
-- It is no entry of Chronicle's, so the card is the one the test draws it under
return {
    page = 'Fixture', title = '', source = '', images = {},
    meta_order = {},
    meta = {

    },
    body = [==[
@tabs
@tab First|
@head Name|First
@head Level Restriction|None
@head Pack|Wings of the Goddess
@head Description|The first path's own words.
@head Rewards|{@k} {k:Large memory fragment|Large memory fragment (4)}
Text of the first path.
@tab Second|
@head Name|Second
@head Level Restriction|None
@head Pack|Wings of the Goddess
@head Description|The second path's own words.
@head Rewards|{@k}{k:Large memory fragment|Large memory fragment (4)}
Text of the second path.
@end
]==],
}
