-- fixture: a table cell whose bracket follows a link with no space (assault 25: `{m:Old Troll} ({p:RNG})`). The column is never narrower than the
-- run "(RNG)" the flow keeps on one line, so the closing bracket does not wrap alone
return {
    page = 'Fixture', title = 'Fixture', source = '', images = {'Lebros Cavern.jpg'}, meta = {},
    body = [==[
!Lebros Cavern.jpg|right|Lebros Cavern
=2 Enemies
|^Level|Name|Zone|Aggro|Link|Drops|Steal|Spawns
|Tough-Very Tough|{m:Old Troll} ({p:RNG})|{p:Lebros Cavern}|Yes|Yes||None|8
]==],
}
