-- fixture: maps whose labels carry the wiki's file ids (map 11, map 12), under a text that cites a game layer ("Map 2"): nothing to demand
return {
    page = 'Fixture', title = 'Fixture', source = '', images = {'Foo-map11.jpg', 'Foo-map12.jpg'},
    meta = {},
    body = [==[
=2 Walkthrough
* Run through where the wall was to enter Map 2.
!Foo-map11.jpg||Foo map 11
!Foo-map12.jpg||Foo map 12
]==],
}
