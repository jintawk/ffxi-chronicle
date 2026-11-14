-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Blood_and_Glory). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Blood and Glory',
    title = 'Blood and Glory',
    source = 'https://www.bg-wiki.com/ffxi/Blood_and_Glory',
    images = {'Broken Latent.png'},
    meta_order = {'Name', 'Required Fame', 'Level Restriction', 'Starting NPC', 'Pack', 'Title', 'Repeatable', 'Description', 'Previous Quest', 'Next Quest', 'Rewards'},
    meta = {
        ['Name'] = 'Blood and Glory',
        ['Required Fame'] = '{p:Windurst|Category:Windurst Quests} Fame Level: __Unknown__',
        ['Level Restriction'] = 'Level {p:Staff} skill 230+, Level 71',
        ['Starting NPC'] = '{p:Shantotto} - {z:Windurst Walls} (K-7)',
        ['Pack'] = 'None',
        ['Title'] = 'None',
        ['Repeatable'] = '__No__',
        ['Description'] = 'Doctor Shantotto has recruited you into her staff-wielding team for the coming contest. Practice your skills with the staff you have been given until you\'ve reduced it to splinters. What lies ahead? Glory and honor? Or blood and broken bones...?',
        ['Previous Quest'] = 'None',
        ['Next Quest'] = 'None',
        ['Rewards'] = '{p:Retribution} weapon skill'
    },
    body = [=[
=2 Walkthrough
* You cannot start this quest if you have another {q:Weapon Skill Quest|WSNM|Weapon Skill Quest} active. You must return to the person that gave said quest and quit it to start another.
* Speaking with {p:Shantotto} will grant you the key item {k:Weapons Training Guide|Weapon training guide} as well as the {p:Pole of Trials}. You will need to break the latent on the {p:Pole of Trials} before completing the rest of the quest.

:* Breaking the Latent

::* With the {p:Pole of Trials} equipped in your Main hand, fight experience-yielding mobs ("Incredibly Easy Prey" or higher) and perform {p:Weapon Skills|Category:Weapon Skills} or close {p:Skillchains|Category:Skillchain} to accumulate 300 "Trial Points".

|^Skillchain Level|Points
|No Skillchain|5
|Level 1|7
|Level 2|9
|Level 3|11

::* You know you have enough points when the latent breaks. You will know it is done when the weapon's elemental resistances disappear from your active resistances (colored dots below the gear grid, but above the selected item description). **The item's description text will never change**.

!Broken Latent.png||
* Trade the {p:Pole of Trials} back to {p:Shantotto}. This will give you the key item {k:Map to the Annals of Truth}. You will be instructed to travel to {z:Ifrit's Cauldron}.
* Take Ifrit's Cauldron HP #1 to map 7. Run south then north to fall off the lip at J-4. Then run south to transition M at J-8. Then north to the ???.
* Alternatively, if you don't have the HP.

:* Take {i:silent oil|Silent Oil|4165}, {i:prism powder|Prism Powder|4164} and an {i:ice cluster|Ice Cluster|4105} and head to {z:Yhoator Jungle} (I-5/6). Enter {z:Ifrit's Cauldron} directly to the north.
:* Inside {z:Ifrit's Cauldron}, follow the path to the first junction and go north. Cool the Flame Spout with the {i:ice cluster|Ice Cluster|4105} and continue west along the path until you arrive at a large circular room. Go south along the ledge and drop down at (I-7/8).
:* Once you drop, there will be a tunnel to your southeast. Go in. The ??? to spawn the NM is in the center of the bridge directly north. Clear away the bats and the bomb if you need to before spawning the NM.

* This fight is against {m:Cailleach Bheur}, a skeleton. It is a {p:Black Mage} weak to {p:Fire} and {p:Light} attacks. Once you kill it, re-examine the ??? to receive the key item {k:Annals of Truth}.
* Go back and speak with {p:Shantotto} to receive your reward.

]=],
}
