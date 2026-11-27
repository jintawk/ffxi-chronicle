-- Chronicle: how to set each hidden record that gates a Records objective.
--
-- The client gates 72 objectives and 14 sub-categories on 46 records that no menu shows. Their names are the
-- developers' own ("Scenarios 15", "Unlocking Scenarios IX", or none at all), so "Unlocked by the record
-- Scenarios 15" tells a player nothing. This is what the player does instead, one line each, from BG-wiki:
-- the objective's own page, the notes of its section on the Records of Eminence page, and the Ambuscade, Mentor,
-- Escutcheons and Unity Concord pages. ui/screens/robj.lua shows it; test/test_roe.lua fails when the client
-- gates on a hidden record this table does not name (a client update that adds one).
return {
    -- Content (Ambuscade): the primer objectives
    [3996] = 'Complete Stepping into an Ambuscade, then speak with Gorpa-Masorpa in Mhaura (G-9)',
    [3997] = 'Complete Stepping into an Ambuscade, then speak with Gorpa-Masorpa in Mhaura (G-9)',

    -- Other > RoE Quests: Nantoto in Lower Jeuno, once enough unique objectives are complete
    [4000] = '50 unique objectives, then talk to Nantoto in Lower Jeuno (H-8)',
    [4001] = '100 unique objectives, then talk to Nantoto in Lower Jeuno (H-8)',
    [4002] = '103 unique objectives, then talk to Nantoto in Lower Jeuno (H-8)',
    [4003] = '150 unique objectives, then talk to Nantoto in Lower Jeuno (H-8)',
    [4004] = 'Talk to Duberasson in Western Adoulin (H-11) after To Kill Mocking Birds; at 200 unique objectives, choose the White Envelope from Nantoto in Lower Jeuno (H-8)',
    [4005] = '250 unique objectives, then choose the Green Envelope from Nantoto in Lower Jeuno (H-8)',
    [4006] = '300 unique objectives, then choose the Silver Envelope from Nantoto in Lower Jeuno (H-8)',
    [4007] = '349 unique objectives, then choose the Purple Envelope from Nantoto in Lower Jeuno (H-8)',
    [4087] = '393 unique objectives, then choose the Black Envelope from Nantoto in Lower Jeuno (H-8)',
    [4086] = '473 unique objectives, then choose the Blue Envelope from Nantoto in Lower Jeuno (H-8)',
    [4074] = '600 unique objectives, then choose the Gold Envelope from Nantoto in Lower Jeuno (H-8)',
    [4075] = '700 unique objectives, then choose the Yellow Envelope from Nantoto in Lower Jeuno (H-8)',
    [4076] = '800 unique objectives, then choose the Brown Envelope from Nantoto in Lower Jeuno (H-8)',
    [4077] = '900 unique objectives, then choose the Red Envelope from Nantoto in Lower Jeuno (H-8)',
    [4078] = '999 unique objectives, then choose the Rainbow Envelope from Nantoto in Lower Jeuno (H-8)',

    -- Other > RoE Quests 2: Ploh Trishbahk at the Castle Adoulin gates
    [4073] = 'Obtain the Golden Shovel Cordon, then talk to Ploh Trishbahk in Eastern Adoulin (K-9)',
    [4072] = 'Wait a game day after The Ygnas Directive 2, then talk to Ploh Trishbahk in Eastern Adoulin (K-9)',
    [4071] = 'Wait a game day after The Ygnas Directive 4, then talk to Ploh Trishbahk in Eastern Adoulin (K-9)',
    [4070] = 'Wait a game day after The Ygnas Directive 6, then talk to Ploh Trishbahk in Eastern Adoulin (K-9)',

    -- Other > RoE Quests 3: Jamal and Marjory in Ru'Lude Gardens
    [4069] = "Complete Awakening and Dawn, obtain the Bundle of half-inscribed scrolls and Trust: Rainemard, then talk to Jamal in Ru'Lude Gardens (H-5)",
    [4068] = "Redeem the last Ark Angel cipher, zone, then talk to Jamal in Ru'Lude Gardens (H-5)",
    [4067] = "Redeem the last Ark Angel cipher, zone, then talk to Jamal in Ru'Lude Gardens (H-5)",
    [4066] = "Redeem the last Ark Angel cipher, zone, then talk to Jamal in Ru'Lude Gardens (H-5)",
    [4065] = "Redeem the last Ark Angel cipher, zone, then talk to Jamal in Ru'Lude Gardens (H-5)",
    [4056] = "Finish Jamal's five Ark Angel records, hold the Job Breaker and 86 trusts, then talk to Marjory in Ru'Lude Gardens (H-5)",

    -- Other > RoE Quests 4: Elijah in Upper Jeuno, one set per chapter of The Voracious Resurgence
    [4052] = 'Complete The Voracious Resurgence 4-4, then talk to Elijah in Upper Jeuno (G-6)',
    [4051] = 'Complete the next chapter of The Voracious Resurgence, then talk to Elijah in Upper Jeuno (G-6)',
    [4050] = 'Complete the next chapter of The Voracious Resurgence, then talk to Elijah in Upper Jeuno (G-6)',
    [4049] = 'Complete the next chapter of The Voracious Resurgence, then talk to Elijah in Upper Jeuno (G-6)',
    [4048] = 'Complete the next chapter of The Voracious Resurgence, then talk to Elijah in Upper Jeuno (G-6)',
    [4047] = 'Complete the next chapter of The Voracious Resurgence, then talk to Elijah in Upper Jeuno (G-6)',
    [4046] = 'Complete the next chapter of The Voracious Resurgence, then talk to Elijah in Upper Jeuno (G-6)',

    -- Trust Ascension
    [4044] = "Obtain the Celestite Case from Syndella in Ru'Lude Gardens (H-5)",

    -- Tutorial
    [4053] = 'Main job level 30, 180 hours played and Repelling an Ambuscade, then talk to an A.M.A.N. representative',
    [4085] = 'Complete 10 objectives, then visit San d\'Oria, Bastok, Windurst or Adoulin',

    -- Crafting: Escutcheon
    [4057] = 'Reach Expert in Woodworking, then talk to Mewk Chorosap in Port Jeuno (G-8)',
    [4058] = 'Reach Expert in Smithing, then talk to Mewk Chorosap in Port Jeuno (G-8)',
    [4059] = 'Reach Expert in Goldsmithing, then talk to Mewk Chorosap in Port Jeuno (G-8)',
    [4060] = 'Reach Expert in Clothcraft, then talk to Mewk Chorosap in Port Jeuno (G-8)',
    [4061] = 'Reach Expert in Leathercraft, then talk to Mewk Chorosap in Port Jeuno (G-8)',
    [4062] = 'Reach Expert in Bonecraft, then talk to Mewk Chorosap in Port Jeuno (G-8)',
    [4063] = 'Reach Expert in Alchemy, then talk to Mewk Chorosap in Port Jeuno (G-8)',
    [4064] = 'Reach Expert in Cooking, then talk to Mewk Chorosap in Port Jeuno (G-8)',

    -- Fishing (Tenacity)
    [4079] = "Start the quest Thanks for All the Fish; the objectives count only with Lu Shang's Fishing Rod",
}
