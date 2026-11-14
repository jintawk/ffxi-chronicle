-- fixture: a dungeon list whose map numbers are layers of different zones, only some zones pictured (adoulin mission 112): 'Gusgen Mines: Map 3' has no picture to carry a 3
return {
    page = 'Fixture', title = 'Fixture', source = '', images = {'Foo Tunnel-map1.jpg', 'Foo Tunnel-map4.jpg'},
    meta = {},
    body = [==[
=2 Walkthrough
* {z:Gusgen Mines}: Last map, NW corner (G-7) Map 3
** Go down to Map 3 and look south.
* {z:Foo Tunnel}: (G-9) Map 4, ({m:Jammer Leech} spot)
* {z:Palborough Mines}: (J-8) Map 2
* {z:Foo Tunnel} (G-9) Map 4 Map 1 - Map 4
* Take the portal to {z:Palborough Mines} and then {z:Foo Tunnel} (Map 1)
** Child of a pictured zone: Map 4 again.
!Foo Tunnel-map1.jpg||Foo Tunnel map 1
!Foo Tunnel-map4.jpg||Foo Tunnel map 4
]==],
}
