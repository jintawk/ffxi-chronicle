-- fixture: two neighbouring cells of one row both begin with the same word (assault 11, Imperial Agent Rescue:
-- "Mamool Ja Warder | Mamool Ja Training Grounds"); at a width where each cell wraps to its first word the row draws
-- "Mamool Mamool" a cell's padding apart. The wiki's two cells, not a word the layout doubled.
return {
    page = 'Fixture', title = 'Fixture', source = '', images = {'Mamool Ja Training Grounds.jpg'}, meta = {},
    body = [==[
!Mamool Ja Training Grounds.jpg|right|Mamool Ja Training Grounds
=2 Enemies
|^Level|Name|Zone|Aggro|Link|Drops|Steal|Spawns
|?|{m:Mamool Ja Warder}|{p:Mamool Ja Training Grounds}|Yes|Yes||None|?
|?|{m:Mamool Ja Warder}|{p:Mamool Ja Training Grounds}|Yes|Yes||None|?
|?|{m:Mamool Ja Warder}|{p:Mamool Ja Training Grounds}|Yes|Yes||None|?
]==],
}
