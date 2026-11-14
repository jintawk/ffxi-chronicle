-- fixture: map pictures each followed by two short lines (their overlay labels, asa 11): each picture floated at the right is taller than
-- the text beside it, so the next one waits below it and the pictures fall further behind their text with every map
return {
    page = 'Fixture', title = 'Fixture', source = '',
    images = {'Foo-map1.jpg', 'Foo-map2.jpg', 'Foo-map3.jpg', 'Foo-map4.jpg', 'Foo-map5.jpg'}, meta = {},
    body = [==[
=2 Tablets in Foo
!Foo-map1.jpg||Foo map 1
Map 1{br}4 Tablets
Survival Guide
!Foo-map2.jpg||Foo map 2
Map 2{br}2 Tablets
Unity Warp
!Foo-map3.jpg||Foo map 3
Map 3{br}1 Tablet
Unity Warp
!Foo-map4.jpg||Foo map 4
Map 4{br}1 Tablet
Unity Warp
!Foo-map5.jpg||Foo map 5
Map 5{br}7 Tablets
Unity Warp
]==],
}
