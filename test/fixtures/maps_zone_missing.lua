-- fixture: a pictured zone cites a layer none of its pictures carries (rule 78 still asks the pictured zone): Foo Tunnel is pictured as maps 1 and 4, the text sends you to its Map 3
return {
    page = 'Fixture', title = 'Fixture', source = '', images = {'Foo Tunnel-map1.jpg', 'Foo Tunnel-map4.jpg'},
    meta = {},
    body = [==[
=2 Walkthrough
* {z:Foo Tunnel}: (G-9) Map 3
* {z:Gusgen Mines}: Map 3
!Foo Tunnel-map1.jpg||Foo Tunnel map 1
!Foo Tunnel-map4.jpg||Foo Tunnel map 4
]==],
}
