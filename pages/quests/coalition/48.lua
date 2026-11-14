-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Survey:_Ceizak_Battlegrounds). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Survey: Ceizak Battlegrounds',
    title = 'Survey: Ceizak Battlegrounds',
    source = 'https://www.bg-wiki.com/ffxi/Survey:_Ceizak_Battlegrounds',
    images = {},
    meta_order = {'Name', 'Coalition', 'Rank', 'Type', 'Zone', 'Objective'},
    meta = {
        ['Name'] = 'Survey: Ceizak Battlegrounds',
        ['Coalition'] = '{p:Scouts\' Coalition}',
        ['Rank'] = 'Petitioner',
        ['Type'] = 'Land Surveys',
        ['Zone'] = '{z:Ceizak Battlegrounds}',
        ['Objective'] = 'Survey an {p:Ergon Locus} located in {z:Ceizak Battlegrounds} or {z:Yahse Hunting Grounds}.'
    },
    body = [=[
|^~c4~Rewards: EXP/Bayld
|^IMP x1|IMP x2|IMP x3|Treasure
|1000|1800|2400|

* Note that the rewards shown above show the base amount of rewards possible. Surveying Ergon Loci which are more difficult to access will yield additional EXP/Bayld based on the distance from the station and the number of Reives which could potentially block access.

=2 Walkthrough
* Travel to {z:Ceizak Battlegrounds} or {z:Yahse Hunting Grounds} and locate an {p:Ergon Locus}

[Ergon Loci
|^Name|Zone|Position|XP|Notes
|Bud of the Swarm|{z:Ceizak Battlegrounds}|I-8|750|Southeast of Bivouac #2
|Flourishing Island|{z:Ceizak Battlegrounds}|J-10|500|Far south of Frontier Station (SE beach)
|Luminous Isle|{z:Yahse Hunting Grounds}|K-8|500|North of Frontier Station. Requires Key Item {k:"Watercrafting"}
|Immutable Boulder|{z:Yahse Hunting Grounds}|F-5|750|Northwest of Bivouac #2, past True Sight {m:Panopts|Panopt}

]
* Once you've traveled to either zone and located the Ergon Locus, you'll need to examine the Ergon Locus at the right distance

[Time and Positioning Info [1]
|^Ergon Locus|02:00 - 05:59|06:00 - 09:59|10:00 - 13:59|14:00 - 17:59|18:00 - 21:59|22:00 - 01:59
|Bud of the Swarm|1.5 - 1.9|2.0 - 2.4|2.5 - 2.9|3.0 - 3.4|0.5 - 0.9|1.0 - 1.4
|Flourishing Island|1.0 - 1.4|1.5 - 1.9|2.0 - 2.4|2.5 - 2.9|3.0 - 3.4|0.5 - 0.9
|Luminous Isle|2.0 - 2.4|2.5 - 2.9|3.0 - 3.4|0.5 - 0.9|1.0 - 1.4|1.5 - 1.9
|Immutable Boulder|2.5 - 2.9|3.0 - 3.4|0.5 - 0.9|1.0 - 1.4|1.5 - 1.9|2.0 - 2.4

]
* Strategy without knowing the correct distance
** Since the distance is intervals of 0.5 yalms beginning at 0.5, you can use intervals of X.3/X.7 to find the correct distance
** Begin at 0.7 and increment to the next X.3/X.7 increment
*** For instance, 0.7, 1.3, 1.7, 2.3, etc
* Known Distances (Game HR, Yalms)
* Ergon Locus: Bud of the Swarm (Ceizak Battlegrounds I-7, Bivouac #2)
** 0:10, 1.0'
** 0:35, 1.3'
** 0:55, 1.3'
** 1:50, 1.5'
** 2:00, 1.5'
** 2:40, 1.5'
** 3:15, 1.9'
** 3:43, 1.9'
** 4:00, 1.5'
** 4:09, 1.5'
** 4:25, 1.5'
** 4:27, 2.0'
** 4:55, 1.5'
** 5:26, 1.5'
** 5:50, 1.5'
** 6:12, 2.0'
** 6:25, 2.0'
** 6:57, 2.2'
** 7:05, 2.0'
** 8:29, 2.1'
** 8:48, 2.1'
** 8:52, 2.2'
** 9:27, 1.9'
** 9:50, 2.0'
** 10:35, 2.6'
** 11:20, 2.8'
** 12:30, 2.6'
** 13:00, 2.6'
** 13:28, 2.7'
** 13.50, 2.8'
** 14.00, 2.9'
** 14.35, 3.0'
** 14.47, 3.1'
** 15.00, 3.1'
** 15.50, 3'
** 16.32, 3'
** 17.02, 3.3'
** 17.32, 3'
** 17.55, 3'
** 18.00, 1.0'
** 18.25, 0.9'
** 18.48, 0.9'
** 19.45, 0.9'
** 20.25, 0.9'
** 21.15, 1'
** 21.30, 1'
** 21.49, 0.9'
** 21.58, 1'
** 22.10, 1.2'
** 23.05, 1.2'
** 23.20, 1.0'
* Ergon Locus: Flourishing Island (Ceizak Battlegrounds K-10)
** 0:50, 0.5'
** 4:00, 1.2'
** 4.52, 1.3'
** 5:55, 1.2'
** 7.50, 1.8'
** 8.50, 1.7'
** 9.36, 1.7'
** 11.10, 2.1'
** 11:32, 2.0'
** 12:02, 2.2'
** 15:27, 2.7'
** 17:57, 2.7'
** 19:30, 3.1'
** 20:17, 3.3'
** 21:42, 3.4'
** 22:15, 0.7'
** 23:48, 1.0'
* Ergon Locus: Luminous Isle (Yahse Hunting Grounds K-8) [Need Watercraft and Watercrafting]
** 0:10, 1.8'
** 5:29, 2.2'
** 6:20, 2.6'
** 8:55, 2.7'
** 10:20, 3.0'
** 11.33, 2.3'
** 12:19, 3.1'
** 14:20, 1.0'
** 15:00, 0.8'
** 16:45, 0.6'
** 17:27, 0.7'
** 19:25, 1.1'
** 21:00, 1.3'
** 22:36, 1.9'
** 22:47, 1.8'
* Ergon Locus: Immutable Boulder (Yahse Hunting Grounds F-5)
** 00:00, 2.3'
** 01:57, 2.3'
** 03:45, 2.9'
** 05:45, 3.4'
** 06:14, 3.3'
** 08:16, 3.3'
** 08:58, 3.3'
** 10:15, 0.7'
** 11:44, 0.7'
** 12:30, 0.7'
** 15:45, 1.3'
** 20:00, 1.7'
** 22:00, 2.0'

+ {p:https://wiki.ffo.jp/html/28663.html}

]=],
}
