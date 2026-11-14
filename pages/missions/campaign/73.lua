-- Chronicle walkthrough page, generated from BG-wiki
-- (https://www.bg-wiki.com/ffxi/Cut_and_Cauterize_III_(S)). Text and pictures: BG-wiki contributors. Do not edit.
return {
    page = 'Cut and Cauterize III (S)',
    title = 'Cut and Cauterize III (S)',
    source = 'https://www.bg-wiki.com/ffxi/Cut_and_Cauterize_III_(S)',
    images = {},
    meta_order = {'Name', 'Campaign Type', 'Starting NPC', 'Campaign Rank', 'Objective', 'Time Limit', 'Recommended Lv.', 'Rewards'},
    meta = {
        ['Name'] = 'Cut and Cauterize III (S)',
        ['Campaign Type'] = '{p:Military training}',
        ['Starting NPC'] = '{n:Rasdinice} - {z:Southern San d\'Oria (S)} - (I-9)',
        ['Campaign Rank'] = '???',
        ['Objective'] = 'Our injured have been evacuated to Everbloom Hollow. Join the Knights of the Iron Ram in East Ronfaure (G-5) and help tend to the wounded.',
        ['Time Limit'] = '30 minutes',
        ['Recommended Lv.'] = 'Any',
        ['Rewards'] = '~2500 {p:Experience Points}{br}~3500 {p:Allied Notes}'
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
** Offer moral support
*** Healer morale constantly decays (possibly only when in range of the NPCs messages).
*** You want to use this every 5 or so Cures, or after they /heal.
*** If you use it too frequently, it won't have any effect.
*** If the NPC runs away, they will return to the start of the zone until you use this.
**** You can use this right when they start to run away and then they will just touch the starting point and turn around and return to you.
*** If the NPC runs away, you will get a depressed message when you use this for the rest of the run and it might not work.
*** Pupil Palliator II's morale seems to decay faster than I.
** Rest and relax - /heal to recover MP. This seems to be faster than if they run out of MP and are forced to rest.
* The healer AI...
** When asked to heal, they cast {s:Cure II}, {s:III|Cure III}, or {s:IV|Cure IV} (randomly) and can cast {s:Paralyna} / {s:Poisona} if their target is enfeebled.
*** Even in status removal mode, they are not forced to remove statuses and it can take quite a few tries
** When starting or finishing an action, including changing their prioritization or resting, the NPCs can decide they have had enough and run back to the start.
*** They will return to the person with claim on them after they have taken a lap.
** When they try to cast a spell that they do not have the MP for, the NPCs will /heal
*** They seem to recover MP slower this way than if you ask them to /heal.
* You will need to heal 10 other injured NPCs scattered throughout the maze by talking to the healers and telling them to heal.
** These NPCs spawn with between 40 and 60% HP.
** Their names will turn Green and they will be considered healed when their HP reaches 95% and their status ailments are removed.
*** NPCs can either be Poisoned or Paralyzed.
*** NPCs cannot die from poison.
** There are six enfeebled NPCs this time.
*** Norvallen Knight (South H-8)
*** Aragoneu Knight (South H-8)
*** Scarlet Boar Esquire (South I-8)
*** Royal Guard (North H-8)
*** Royal Knight (North I-8)
*** Savage Hound Condottiere (North I-8)
* When you have healed 8 of the 10 injured NPCs, the Objective will be complete
** If you leave at this point, you will receive a middling appraisal. You must heal all of the NPCs for an enthusiastic review.
** If going for a full clear, it is recommended to switch the NPCs to status removal mode and run to the enfeebled NPCs first.
* You must leave via the Dawn Aureola or you will not get credit.
* Return and talk to Rasdinice for your reward.

]=],
}
