-- fixture: tables written as table blocks (convert.py, Phase 1c): a header row, cells that span rows, a th row header,
-- a band, a link whose own fields hold '|', a cell of one dash, a one-column table
return {
    page = 'Fixture', title = 'Fixture', source = '', images = {}, meta = {},
    body = [==[
=2 Walkthrough
* Speak with the following people:

|^Area|Position|Name
|~r2~{z:Southern San d'Oria}|(K-5)|{n:Daggao}
|(J-9)|{n:Authere}
|~r2~{z:Northern San d'Oria}|(I-9)|{n:Giaunne}
|(J-8)|{n:Anilla}

* Points by skillchain level:

|^~c2~Ribbons
|^Rank|Points
|~h~Bronze|5
|Silver|7
|~hc2~Gold section
|Gold|11
|None|-
|{p:Light|Light (Skillchain)}|{i:Gil|Gil|65535}

|^Augment Set 1
|Accuracy+4
|Attack+4
|Magic Accuracy+4
* Then return.
]==],
}
