-- fixture: the Enemies table of assault 2 (and 3): eight columns, two rows. At a 440 px window it fits when the cells give up their margin
-- (2 px a side); squeezed, the header words touch ("Link Drops", "Steal Spawns") and "Too Weak", "Mineral Worm" and "Leujaoam Sanctum"
-- wrap. Rule 124: a grid of more than five columns does not squeeze, it is a card per row.
return {
    page = 'Fixture', title = 'Fixture', source = '', images = {}, meta = {},
    body = [=[
=2 Enemies
|^Level|Name|Zone|Aggro|Link|Drops|Steal|Spawns
|Too Weak|Mineral Worm|{p:Leujaoam Sanctum}|Yes|Yes||None|Varies
|T-VT|{m:Qiqirn Miner}|{p:Leujaoam Sanctum}|Yes*|Yes||None|?

=3 Notes
* Mineral Worms have a chance of spawning upon an unsuccessful mining attempt.
* Qiqirn Miners will become hostile after an Orichalcum Ore has been mined.
]=],
}
