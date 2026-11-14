-- fixture: a count printed under a map's number with a line break, "Map 2<br />4 Tablets" (asa mission 11): the break keeps the digits apart, the cites are 1 and 2
return {
    page = 'Fixture', title = 'Fixture', source = '', images = {'Foo Temple-map2.jpg', 'Foo Temple-map1.jpg'},
    meta = {},
    body = [==[
=2 Tablets locations in Foo Temple
!Foo Temple-map2.jpg||Foo Temple map 2
Map 2{br}4 Tablets
!Foo Temple-map1.jpg||Foo Temple map 1
Map 1{br}2 Tablets
]==],
}
