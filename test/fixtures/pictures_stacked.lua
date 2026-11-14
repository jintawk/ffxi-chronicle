-- fixture: three maps one to a line, a rule between them: the stack of pictures with no text the gap rule exists for
return {
    page = 'Fixture', title = 'Fixture', source = '', images = {'Map1.jpg', 'Map2.jpg', 'Map3.jpg'}, meta = {},
    body = [==[
=2 Maps
!Map1.jpg||
----
!Map2.jpg||
----
!Map3.jpg||
* Then return.
]==],
}
