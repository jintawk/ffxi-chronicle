-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Atop_the_Highest_Mountains). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Atop the Highest Mountains',
    title = 'Atop the Highest Mountains',
    source = 'https://www.bg-wiki.com/ffxi/Atop_the_Highest_Mountains',
    images = {'Xarcabard-map.jpg'},
    meta_order = {'Name', 'Required Fame', 'Level Restriction', 'Starting NPC', 'Pack', 'Title', 'Repeatable', 'Description', 'Previous Quest', 'Next Quest', 'Requirements', 'Rewards'},
    meta = {
        ['Name'] = 'Atop the Highest Mountains',
        ['Required Fame'] = '{p:Jeuno|Category:Jeuno Quests} Fame Level: 1',
        ['Level Restriction'] = 'Level 51',
        ['Starting NPC'] = '{p:Maat}, {z:Ru\'Lude Gardens} (H-5)',
        ['Pack'] = 'None',
        ['Title'] = 'Summit Breaker',
        ['Repeatable'] = '__No__',
        ['Description'] = 'Collect three stones of frigicite from fiend-infested caverns in the north. Bring them to Maat to further expand your innate limits.',
        ['Previous Quest'] = '{q:In Defiant Challenge|In Defiant Challenge|In Defiant Challenge}',
        ['Next Quest'] = '{q:Whence Blows the Wind|Whence Blows the Wind|Whence Blows the Wind}',
        ['Requirements'] = '{k:Round frigicite}{br} {k:Square frigicite}{br} {k:Triangular frigicite}',
        ['Rewards'] = 'Raises level cap to 60.'
    },
    body = [=[
=2 Walkthrough
* Speak to Maat on a level 51 job. He will ask you for three key items guarded by monsters in {z:Xarcabard}.

:* If this is your first time heading to {z:Xarcabard} you may use the {p:Unity} level 125 > Xarcabard warp to get there.

|^Monster|Position|Key Item
|{m:Boreal Tiger}|(I-5)|{k:Round frigicite}
|{m:Boreal Coeurl}|(J-6)|{k:Square frigicite}
|{m:Boreal Hound}|(G-10)|{k:Triangular frigicite}

* The Notorious Monsters stand guard in caves have fairly large aggro range and will respawn within about 5 minutes after being defeated.

:* As of the February 2012 update, the **???** spot will always be present at the far end of the cave, you will receive the key item once you touch it.

::* As a result, you do not need to defeat the Notorious Monsters. You can simply hold them while examining the spots.

:::* These NMs will no longer use draw-in, and you may run away afterwards. They will not chase you for very far. Tested this as a lv 51 on 3/12/24 and the Coeurl at least did Draw-in several times. Will not draw-in if you do not engage.

* You also solo these Notorious Monsters now with relative ease using {p:Trusts|Trust}.

:* Otherwise you may ride through the cave on a {p:Mount} to receive the key items, and then either remount or run out.

* Speak to {p:Maat} once you have all three key items to complete the quest.

!Xarcabard-map.jpg||Xarcabard map
]=],
}
