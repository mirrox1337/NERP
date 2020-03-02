Config = {
    Locale = 'sv', -- Just be sure there is a file providing this locale in the locales folder!
    FadeTime = 250, -- When we "fade to black" and back, how long does the fade take?
    InsuranceCostMultiplier = 0.1, -- When a test driven vehicle as gone missing, what does it cost to bring it back? That models order price multiplied by this number.
    SellPriceMultiplier = 1.0, -- When selling a vehicle to the dealership, how much do you get for it? That vehicle models order price multipled by this number.
    Blips = { -- Where should the blips be on the map, and what should they look like?
        {
            Active   = true,
            Location = vector3(-55.330, -1110.266, 25.436),
            Sprite   = 326,
            Scale    = 1.0,
            Color    = 38,
            String   = 'cardealer',
        },
    },
    Termination = { -- What job and rank should people get if they are fired?
        job = 'unemployed',
        rank = 0,
    },
    NewhireRank = { -- What rank do you want newly hired people to have?
        cardealer = 0,
    },
    BossRank = { -- At what rank are boss actions available?
        cardealer = 3,
    },
    Locations = {
        -- Don't edit this if you're not reasonably familiar with what you're doing. It *will* break.
        -- Using this config section it is fully possible to create another location for the cardealer, or even a competin dealership.
        -- Best of luck!
        cardealer = {
            Simeon = {
                Center = vector3(-40.618, -1099.558, 26.422),
                Size   = 100,
                SellVehicle = {
                    Location = vector3(-44.611, -1083.435, 26.698),
                    Range = 3.0,
                    DrawRange = 50.0,
                },
                Actions = {
                    {
                        Location    = vector3(-30.571, -1105.500, 26.396),
                        Scale       = vector3(0.25,0.25,0.25),
                        Rotates     = true,
                        MinGrade    = 0,
                        Range       = 2.0,
                        DrawRange   = 5.0,
                        Model       = 36,
                        Color       = {r=128, g=255, b=128, a=255},
                        Prompt      = 'action_order_vehicle',
                        Event       = 'nerp_bilcenter:request_order_menu',
                        EventData   = {},
                    },
                    {
                        Location    = vector3(-55.431, -1097.361, 26.552),
                        Scale       = vector3(0.25,0.25,0.25),
                        Rotates     = true,
                        MinGrade    = 0,
                        Range       = 1.0,
                        DrawRange   = 8.0,
                        Model       = 29,
                        Color       = {r=255, g=255, b=128, a=255},
                        Prompt      = 'action_sell_vehicle',
                        Event       = 'nerp_bilcenter:request_sales_menu',
                        EventData   = {},
                    },
                    {
                        Location    = vector3(-33.010, -1114.985, 26.460),
                        Scale       = vector3(0.25, 0.25, 0.25),
                        Rotates     = true,
                        MinGrade    = 3,
                        Range       = 2.0,
                        DrawRange   = 10.0,
                        Model       = 31,
                        Color       = {r=255, g=128, b=255, a=255},
                        Prompt      = 'action_boss_menu',
                        Event       = 'nerp_bilcenter:request_boss_menu',
                        EventData   = {},
                    },
                },
                Points = {
                    Cam = {
                        Location = vector3(-43.799, -1096.113, 26.866),
                        Rotation = vector3(-9.515, 0.000, 104.178),
                    },
                    Spawn = {
                        Location = vector3(-49.369, -1097.380, 26.0),
                        Rotation = vector3(-1.189, 0.000, -109.566),
                    },
                },
            },
        },
    },
}
