-- fixture (rule 179): two tab panels, each a quest infobox whose Required Fame is "Other Fame Level: Unknown" and whose Rewards is "Support Job"
-- or "Support Jobs" (quest other 24 under a card with FAME "Other" and REWARD "Support Jobs"); the Description is each panel's own. It is no
-- entry of Chronicle's, so the card is the one the test draws it under
return {
    page = 'Fixture', title = '', source = '', images = {},
    meta_order = {},
    meta = {

    },
    body = [==[
@tabs
@tab First|
@head Name|First
@head Required Fame|{p:Other|Category:Other Quests} Fame Level: __Unknown__
@head Description|The first quest's own words.
@head Rewards|{p:Support Jobs|Support Job}
Text of the first quest.
@tab Second|
@head Name|Second
@head Required Fame|{p:Other|Category:Other Quests} Fame Level: __Unknown__
@head Description|The second quest's own words.
@head Rewards|{p:Support Job}
Text of the second quest.
@end
]==],
}
