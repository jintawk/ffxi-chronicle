-- fixture: the Enemies table of the Assault pages (assault 17, 29, 1): eight columns, which do not fit a 480 px window even at their
-- narrowest. Drawn run on it read as raw bars between the cells; rule 121 draws a card per row (the name, then Label value pairs), empty
-- cells left out, a row with plain-text name (29) and a drop with an item icon (1) included
return {
    page = 'Fixture', title = 'Fixture', source = '', images = {}, meta = {},
    body = [=[
=2 Enemies
|^Level|Name|Zone|Aggro|Link|Drops|Steal|Spawns
|?|{m:Bluethunder Kaqool Ja}|{p:Mamool Ja Training Grounds}|Yes|Yes||None|1
|?|{m:Molted Bugard}|{p:Mamool Ja Training Grounds}|Yes|No||None|?
|Easy Prey|Vulcanian Bomb|{p:Lebros Cavern}|Yes|Yes|None|None|20
|Tough|{m:Jorporbor the Hellraker} ({p:DRK})|{p:Lebros Cavern}|Yes|Yes|None|None|1
|Varies|{m:Leujaoam Worm}|{p:Leujaoam Sanctum}|Yes|Yes|{i:Earth Crystal|Earth Crystal|4099}|None|15
=2 Walkthrough
Defeat them all.
]=],
}
