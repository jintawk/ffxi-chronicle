-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Cut_and_Cauterize_II_(S)). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Cut and Cauterize II (S)',
    title = 'Cut and Cauterize II (S)',
    source = 'https://www.bg-wiki.com/ffxi/Cut_and_Cauterize_II_(S)',
    images = {},
    meta_order = {'Name', 'Campaign Type', 'Starting NPC', 'Campaign Rank', 'Objective', 'Time Limit', 'Recommended Lv.', 'Rewards'},
    meta = {
        ['Name'] = 'Cut and Cauterize II (S)',
        ['Campaign Type'] = '{p:Military training}',
        ['Starting NPC'] = '{n:Rasdinice} - {z:Southern San d\'Oria (S)} - (I-9)',
        ['Campaign Rank'] = '???',
        ['Objective'] = 'Our injured have been evacuated to Everbloom Hollow. Join the Knights of the Iron Ram in East Ronfaure (G-5) and help tend to the wounded.',
        ['Time Limit'] = '30 minutes',
        ['Recommended Lv.'] = 'Any',
        ['Rewards'] = '~1500 {p:Experience Points}{br}~2000 {p:Allied Notes}'
    },
    body = [=[
=2 Walkthrough
* Talk to Rasdinice.
* Travel to East Ronfaure (hug the left wall as soon as you come out).
* Once the party leader has selected to enter, you will be transported into Everbloom Hollow.
* After a few moments, two healer NPCs (Pupil Palliator I and II) will load
** Talk to them to make them follow you.
* The Healers have four options when you talk to them:
** Ask them to heal - the NPCs heal a nearby NPC.
** Change their prioritization - the NPCs will be either more or less likely to cast Poisona / Paralyna
** Offer moral support - this might stop them from running away
** Rest and relax - /heal to recover MP
* The healer AI...
** When asked to heal, they cast {s:Cure II}, {s:III|Cure III}, or {s:IV|Cure IV} (randomly) and can cast {s:Paralyna} / {s:Poisona} if their target is enfeebled.
*** Even in status removal mode, they are not forced to remove statuses and it can take quite a few tries
** When starting or finishing an action, including changing their prioritization or resting, the NPCs can decide they have had enough and run back to the start.
*** They will return to the person with claim on them after they have taken a lap.
** When they try to cast a spell that they do not have the MP for, the NPCs will /heal
*** There is no apparent benefit to forcing the NPCs to rest
* You will need to heal 8 other injured NPCs scattered throughout the maze by talking to the healers and telling them to heal.
** These NPCs spawn with between 40 and 60% HP.
** Their names will turn Green and they will be considered healed when their HP reaches 90% and their status ailments are removed.
** There are four enfeebled NPCs this time.
*** Aragoneu Knight, Royal Knight, Savage Hound Condottiere, and the further Royal Guard (H-8)
* When you have healed 6 of the 8 injured NPCs, the Objective will be complete
** If you leave at this point, you will receive a middling appraisal. You must heal 8/8 for an enthusiastic review.
** If going for a full clear, it is recommended to switch the NPCs to status removal mode and run to the enfeebled NPCs first.
* You must leave via the Dawn Aureola or you will not get credit.
* Return and talk to Rasdinice for your reward.

]=],
}
