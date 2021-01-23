return {

    --[[ Developer swords ]]
    {
        Name = "TestSword", -- Name reference for loop

        -- Sword defaults
        Defaults = {
            Rarity = "Common", -- Rarity of the item
            Damage = 1, -- Default damage
            StrengthMin = 0, -- The minimum strength level
            StrengthBoost = 1.3 -- This will boost damage if the players strength is greater than minimum
        },

        ModelName = "Test Sword", -- Name pointing to an asset
        DropRate = 0 -- 0 to signal it will not drop
    }

    --[[ Special swords ]]

    --[[ Player swords ]]
}