-- fixture: a heading beside a picture that is not its own, where the wiki's own layout is two columns and rule 130 leaves it alone: the
-- page's lead picture with a heading that opens with a picture beside it (Assault pages: Enemies, Notes), a subsection under the section that holds the picture, and a
-- section that opens with text rather than a picture
return {
    page = 'Fixture', title = 'Fixture', source = '',
    images = {'Lead-map.jpg', 'Foo-map1.jpg'}, meta = {},
    body = [==[
!Lead-map.jpg|right|Lead map
=2 Enemies
Two guards stand at the gate.
=2 Walkthrough
!Foo-map1.jpg||Foo map 1
=3 The great hall
Cross it.
=2 Leaving
Take the stairs down and turn east at the bottom.
]==],
}
