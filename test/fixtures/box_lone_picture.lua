-- fixture: a titled box whose only content is a picture (the wiki's map box, quest other 20): the picture is drawn in the box's width, never
-- floated at the right of an empty box (rule 150)
return {
    page = 'Fixture', title = 'Fixture', source = '',
    images = {'Foo-pic.png'}, meta = {},
    body = [==[
=2 Walkthrough
* Speak to the guard.

[Map with NM Pop Locations
!Foo-pic.png||
]
]==],
}
