-- fixture: sections that are only a heading and a picture (asa 8: "Map 1", "Map 2"), and a section whose picture has a few short label
-- lines beside it (asa 11): the next heading opens with a picture of its own, so it starts below the picture of the section before it,
-- not beside it (rule 130)
return {
    page = 'Fixture', title = 'Fixture', source = '',
    images = {'Foo-map1.jpg', 'Foo-map2.jpg', 'Foo-map3.jpg', 'Foo-map4.jpg'}, meta = {},
    body = [==[
=2 Walkthrough
Collect the saps in the canal, then return to the fountain.
=2 Sap crystals
=3 Map 1
!Foo-map1.jpg||Foo map 1
=3 Map 2
!Foo-map2.jpg||Foo map 2
=2 Tablets in Foo
!Foo-map3.jpg||Foo map 3
Map 3{br}4 Tablets
Survival Guide
=2 Tablets in Bar
!Foo-map4.jpg||Foo map 4
Map 4{br}2 Tablets
Unity Warp
]==],
}
