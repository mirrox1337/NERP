Config = {}
Config['Debug'] = false -- if this is enabled, synced animations will just spawn a npc that will do the animation with you

Config['pNotify'] = true -- use pNotify for notifications?

Config['SteamWebAPI'] = '963FC18073CE77ABB9F6DF26817AD90A'
Config['DiscordWebhook'] = 'https://discordapp.com/api/webhooks/679390900073529345/hwwpjlX0uA-__V6k4-FKQRrA6p_m4TBp5VPauReHmt51kxW6GiFtFDchng-V9bT1Wt4S'

Config['SelectableButtons'] = { -- find controls here https://docs.fivem.net/docs/game-references/controls/
    {'~INPUT_MULTIPLAYER_INFO~', 20},
    {'~INPUT_VEH_NEXT_RADIO~', 81},
    {'~INPUT_VEH_PREV_RADIO~', 82},
    {'~INPUT_VEH_NEXT_RADIO_TRACK~', 83}, 
    {'~INPUT_VEH_PREV_RADIO_TRACK~', 84}
}

Config['OpenMenu'] = 170 -- button to open menu, set to false to disable hardcoded button opening (e.g if you want to add it to your own menu) 
Config['CancelAnimation'] = 105
-- TriggerEvent('loffe_animations:openMenu') < event to open the menu

Config['PoleDance'] = {
    {['Position'] = vector3(112.60, -1286.76, 28.56), ['Number'] = '3'},
    {['Position'] = vector3(104.18, -1293.94, 29.26), ['Number'] = '1'},
    {['Position'] = vector3(102.24, -1290.54, 29.26), ['Number'] = '2'}
}

Strings = {
    ['Choose_Favorite'] = 'Vilken knapp vill du använda för %s?',
    ['Select_Favorite'] = 'Lägg till en snabbanimation',
    ['Manage_Favorites'] = 'Hantera snabbanimationer',
    ['Close'] = 'Avbryt',
    ['Updated_Favorites'] = 'Uppdaterade snabbanimationer.',
    ['Remove?'] = 'Ta bort %s som snabbanimation?',
    ['Yes'] = 'Ja',
    ['No'] = 'Nej',
    ['Animations'] = 'Animationer',
    ['Synced'] = 'Synkade animationer',
    ['Sync_Request'] = 'Vill du %s %s?',
    ['Pole_Dance'] = '[~r~E~w~] Poledance',
    ['Noone_Close'] = 'Ingen spelare nära.'
}

Config['Synced'] = {
    {
        ['Label'] = 'Anal', 
        ['RequesterLabel'] = 'bli körd i röven av',
        ['LogAnim'] = true,
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'rcmpaparazzo_2', ['Anim'] = 'shag_loop_a', ['Flags'] = 1,
        }, 
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'rcmpaparazzo_2', ['Anim'] = 'shag_loop_poppy', ['Flags'] = 1, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.015,
                ['yP'] = 0.35,
                ['zP'] = 0.0,

                ['xR'] = 0.9,
                ['yR'] = 0.3,
                ['zR'] = 0.0,
            },
        },
    },
    {
        ['Label'] = 'Bli riden (förarsäte)', 
        ['RequesterLabel'] = 'rida av',
        ['LogAnim'] = true,
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'oddjobs@assassinate@vice@sex', ['Anim'] = 'frontseat_carsex_loop_m', ['Flags'] = 1,
        }, 
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'oddjobs@assassinate@vice@sex', ['Anim'] = 'frontseat_carsex_loop_f', ['Flags'] = 1,
        },
    },
    {
        ['Label'] = 'Rid av (förarsäte)', 
        ['RequesterLabel'] = 'bli riden av',
        ['LogAnim'] = true,
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'random@drunk_driver_2', ['Anim'] = 'cardrunksex_loop_f', ['Flags'] = 1,
        }, 
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'random@drunk_driver_2', ['Anim'] = 'cardrunksex_loop_m', ['Flags'] = 1,
        },
    },
    {
        ['Label'] = 'Krama',
        ['RequesterLabel'] = 'krama',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'kisses_guy_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'kisses_guy_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.05,
                ['yP'] = 1.15,
                ['zP'] = -0.05,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'High five',
        ['RequesterLabel'] = 'göra high five med',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'highfive_guy_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'highfive_guy_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = -0.5,
                ['yP'] = 1.25,
                ['zP'] = 0.0,

                ['xR'] = 0.9,
                ['yR'] = 0.3,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Bro hug',
        ['RequesterLabel'] = 'bro hugga',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'hugs_guy_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'hugs_guy_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = -0.025,
                ['yP'] = 1.15,
                ['zP'] = 0.0,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Fistbump',
        ['RequesterLabel'] = 'fistbumpa',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationpaired@f_f_fist_bump', ['Anim'] = 'fist_bump_left', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationpaired@f_f_fist_bump', ['Anim'] = 'fist_bump_right', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = -0.6,
                ['yP'] = 0.9,
                ['zP'] = 0.0,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 270.0,
            }
        }
    },
    {
        ['Label'] = 'Skaka hand (polare)',
        ['RequesterLabel'] = 'skaka hand med',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'handshake_guy_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'handshake_guy_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.0,
                ['yP'] = 1.2,
                ['zP'] = 0.0,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
        ['Label'] = 'Skaka hand (jobb)',
        ['RequesterLabel'] = 'skaka hand med',
        ['Requester'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_common', ['Anim'] = 'givetake1_a', ['Flags'] = 0,
        },
        ['Accepter'] = {
            ['Type'] = 'animation', ['Dict'] = 'mp_common', ['Anim'] = 'givetake1_b', ['Flags'] = 0, ['Attach'] = {
                ['Bone'] = 9816,
                ['xP'] = 0.075,
                ['yP'] = 1.0,
                ['zP'] = 0.0,

                ['xR'] = 0.0,
                ['yR'] = 0.0,
                ['zR'] = 180.0,
            }
        }
    },
    {
    ['Label'] = 'Ge avsugning',
    ['RequesterLabel'] = 'bli avsugen av',
    ['Requester'] = {
        ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'pimpsex_hooker', ['Flags'] = 1, ['Attach'] = {
            ['Bone'] = 9816,
            ['xP'] = 0.0,
            ['yP'] = 0.65,
            ['zP'] = 0.0,

            ['xR'] = 120.0,
            ['yR'] = 0.0,
            ['zR'] = 180.0,
        }
    },
    ['Accepter'] = {
        ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'pimpsex_punter', ['Flags'] = 1,
    },
},
{
    ['Label'] = 'Bli tagen',
    ['RequesterLabel'] = 'ta',
    ['Requester'] = {
        ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'shagloop_hooker', ['Flags'] = 1, ['Attach'] = {
            ['Bone'] = 9816,
            ['xP'] = 0.05,
            ['yP'] = 0.4,
            ['zP'] = 0.0,

            ['xR'] = 120.0,
            ['yR'] = 0.0,
            ['zR'] = 180.0,
        }
    },
    ['Accepter'] = {
        ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'shagloop_pimp', ['Flags'] = 1,
    },
},
}

Config['Animations'] = {
    {
    
        ['Label'] = 'Nödlägen',
        ['Data'] = {
            {['Label'] = 'Bli arresterad', ['Type'] = 'animation', ['Dict'] = 'random@arrests@busted', ['Anim'] = 'idle_a', ['Flags'] = 0},
            {['Label'] = 'Beskjuten', ['Type'] = 'animation', ['Dict'] = 'anim@heists@ornate_bank@hostages@cashier_a@', ['Anim'] = 'flinch_loop_underfire', ['Flags'] = 0},
            {['Label'] = 'Beskjuten: Ligg', ['Type'] = 'animation', ['Dict'] = 'anim@heists@ornate_bank@hostages@ped_a@', ['Anim'] = 'flinch_loop_underfire', ['Flags'] = 0},
            {['Label'] = 'Beskjuten: sitt', ['Type'] = 'animation', ['Dict'] = 'anim@heists@ornate_bank@hostages@cashier_a@', ['Anim'] = 'flinch_loop_underfire', ['Flags'] = 0},
            {['Label'] = 'Ligg ner', ['Type'] = 'animation', ['Dict'] = 'anim@heists@ornate_bank@hostages@ped_a@', ['Anim'] = 'idle', ['Flags'] = 0},
            {['Label'] = 'Rädd', ['Type'] = 'animation', ['Dict'] = 'anim@heists@fleeca_bank@hostages@ped_d@', ['Anim'] = 'idle', ['Flags'] = 0},
            {['Label'] = 'Underlägsen', ['Type'] = 'animation', ['Dict'] = 'amb@code_human_cower_stand@male@react_cowering', ['Anim'] = 'base_right', ['Flags'] = 0},
    
        }    
    },
    {
        
        ['Label'] = 'Förarsätet',
        ['Data'] = {
            {['Label'] = 'Prata med baksätet', ['Type'] = 'animation', ['Dict'] = 'oddjobs@taxi@driver', ['Anim'] = 'leanover_idle', ['Flags'] = 0},
            {['Label'] = 'Ge/Ta genom rutan', ['Type'] = 'animation', ['Dict'] = 'oddjobs@taxi@cyi', ['Anim'] = 'std_hand_off_ps_passenger', ['Flags'] = 0},
            {['Label'] = 'Upp med händerna', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intincarsurrenderstd@ds@', ['Anim'] = 'idle_a', ['Flags'] = 0},
            {['Label'] = 'Träna på gitarren', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intincarair_guitarstd@ds@', ['Anim'] = 'idle_a', ['Flags'] = 0},
            {['Label'] = 'Trumma lite', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intincarair_synthstd@ds@', ['Anim'] = 'idle_a', ['Flags'] = 0},
            {['Label'] = 'Chicken', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intincarchicken_tauntstd@ds@', ['Anim'] = 'idle_a', ['Flags'] = 0},
            {['Label'] = 'Bli avsugen', ['Type'] = 'animation', ['Dict'] = 'oddjobs@towing', ['Anim'] = 'm_blow_job_loop', ['Flags'] = 0},
            {['Label'] = 'Ha sex', ['Type'] = 'animation', ['Dict'] = 'mini@prostitutes@sexlow_veh', ['Anim'] = 'low_car_sex_loop_player', ['Flags'] = 0},
    
        }    
    },
    {
        
        ['Label'] = 'Passagerarsätet',
        ['Data'] = {
            {['Label'] = 'Uttråkad', ['Type'] = 'animation', ['Dict'] = 'amb@code_human_in_car_idles@low@ps@idle_d', ['Anim'] = 'idle_k', ['Flags'] = 0},
            {['Label'] = 'Spy ur bilen', ['Type'] = 'animation', ['Dict'] = 'oddjobs@taxi@tie', ['Anim'] = 'vomit_outside', ['Flags'] = 0},
            {['Label'] = 'Ge avsugning', ['Type'] = 'animation', ['Dict'] = 'oddjobs@towing', ['Anim'] = 'f_blow_job_loop', ['Flags'] = 0},
            {['Label'] = 'Ge avsugning', ['Type'] = 'animation', ['Dict'] = 'mini@prostitutes@sexnorm_veh', ['Anim'] = 'bj_loop_prostitute', ['Flags'] = 0},
            {['Label'] = 'Ha sex', ['Type'] = 'animation', ['Dict'] = 'mini@prostitutes@sexlow_veh', ['Anim'] = 'low_car_sex_loop_female', ['Flags'] = 0},
    
        }    
    },
    {
        
        ['Label'] = 'Gangster',
        ['Data'] = {
            {['Label'] = 'Hotwire', ['Type'] = 'animation', ['Dict'] = 'anim@gangops@facility@servers@', ['Anim'] = 'hotwire', ['Flags'] = 0},
            {['Label'] = 'Sätt på något', ['Type'] = 'animation', ['Dict'] = 'anim@gangops@hanger@fuse_box@', ['Anim'] = 'switch_on', ['Flags'] = 0},
            {['Label'] = 'Gisslan', ['Type'] = 'animation', ['Dict'] = 'anim@gangops@hostage@', ['Anim'] = 'victim_success', ['Flags'] = 0},
            {['Label'] = 'klinka på datorn', ['Type'] = 'animation', ['Dict'] = 'anim@gangops@morgue@office@laptop@', ['Anim'] = 'idle', ['Flags'] = 0},
            {['Label'] = 'Känn på person', ['Type'] = 'animation', ['Dict'] = 'anim@gangops@morgue@table@', ['Anim'] = 'player_search', ['Flags'] = 0},
            {['Label'] = 'Sitt och ha gang talk', ['Type'] = 'animation', ['Dict'] = 'anim@heists@narcotics@funding@gang_chat', ['Anim'] = 'gang_chatting_combined', ['Flags'] = 0},
            {['Label'] = 'Gang shit', ['Type'] = 'animation', ['Dict'] = 'combat@aim_variations@1h@gang', ['Anim'] = 'aim_variation_a', ['Flags'] = 0},
            {['Label'] = 'Gang sign 1', ['Type'] = 'animation', ['Dict'] = 'mp_player_int_uppergang_sign_a', ['Anim'] = 'mp_player_int_gang_sign_a', ['Flags'] = 0},
            {['Label'] = 'Gang sign 2', ['Type'] = 'animation', ['Dict'] = 'mp_player_int_uppergang_sign_b', ['Anim'] = 'mp_player_int_gang_sign_b', ['Flags'] = 0},
            {['Label'] = 'Mitt stora paket', ['Type'] = 'animation', ['Dict'] = 'mp_player_int_uppergrab_crotch', ['Anim'] = 'mp_player_int_grab_crotch', ['Flags'] = 0},
            {['Label'] = 'Peace', ['Type'] = 'animation', ['Dict'] = 'mp_player_int_upperpeace_sign', ['Anim'] = 'mp_player_int_peace_sign', ['Flags'] = 0},
            {['Label'] = 'Irreterad', ['Type'] = 'animation', ['Dict'] = 'oddjobs@towingangryidle_a', ['Anim'] = 'idle_a', ['Flags'] = 0},
    
        }    
    },
    {
        
        ['Label'] = 'Danser',
        ['Data'] = {
            {['Label'] = 'Dans 1 (Finska)', ['Type'] = 'animation', ['Dict'] = 'special_ped@mountain_dancer@monologue_1@monologue_1a', ['Anim'] = 'mtn_dnc_if_you_want_to_get_to_heaven', ['Flags'] = 0},
            {['Label'] = 'Dans 2 (Skaka loss)', ['Type'] = 'animation', ['Dict'] = 'missfam2leadinoutmcs3', ['Anim'] = 'onboat_leadin_tracy', ['Flags'] = 0},
            {['Label'] = 'Dans 3 (Snurra armarna)', ['Type'] = 'animation', ['Dict'] = 'misschinese2_crystalmazemcs1_ig', ['Anim'] = 'dance_loop_tao', ['Flags'] = 0},
            {['Label'] = 'Dans 4 (Krogen)', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_STRIP_WATCH_STAND'},
            {['Label'] = 'Dans 5 (rave)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@black_madonna_entourage@', ['Anim'] = 'hi_dance_facedj_09_v2_male^5', ['Flags'] = 0},
            {['Label'] = 'Dans 6 (barbord)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@club_ambientpeds_transitions@', ['Anim'] = 'trans_li-mi_to_mi-hi_09_v1_male^6', ['Flags'] = 0},
            {['Label'] = 'Dans 7 (chillkrök)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@club_ambientpeds@med-hi_intensity', ['Anim'] = 'mi-hi_amb_club_09_v1_male^1', ['Flags'] = 0},
            {['Label'] = 'Dans 8 (Dance festival)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_facedj@', ['Anim'] = 'hi_dance_facedj_09_v1_male^1', ['Flags'] = 0},
            {['Label'] = 'Dans 9 (galen)', ['Type'] = 'animation', ['Dict'] = 'anim@arena@celeb@podium@no_prop@', ['Anim'] = 'dance_a_1st', ['Flags'] = 0},
            {['Label'] = 'Dans 10 (gang)', ['Type'] = 'animation', ['Dict'] = 'missfbi3_sniping', ['Anim'] = 'dance_m_default', ['Flags'] = 0},
            {['Label'] = 'Dans 11 (akward)', ['Type'] = 'animation', ['Dict'] = 'move_clown@p_m_zero_idles@', ['Anim'] = 'fidget_short_dance', ['Flags'] = 0},
            {['Label'] = 'Dans 12 (Stripptese)', ['Type'] = 'animation', ['Dict'] = 'mp_am_stripper', ['Anim'] = 'lap_dance_girl', ['Flags'] = 0},
            {['Label'] = 'Dans 13 (Stripptese2)', ['Type'] = 'animation', ['Dict'] = 'oddjobs@assassinate@multi@yachttarget@lapdance', ['Anim'] = 'yacht_ld_f', ['Flags'] = 0},
            {['Label'] = 'Dans 14 (Farsan baloo)', ['Type'] = 'animation', ['Dict'] = 'special_ped@mountain_dancer@monologue_2@monologue_2a', ['Anim'] = 'mnt_dnc_angel', ['Flags'] = 0},
            {['Label'] = 'Dans 15 (Snurrande finsk)', ['Type'] = 'animation', ['Dict'] = 'special_ped@mountain_dancer@monologue_3@monologue_3a', ['Anim'] = 'mnt_dnc_buttwag', ['Flags'] = 0},
            {['Label'] = 'Dans 16 (Stepande finsk)', ['Type'] = 'animation', ['Dict'] = 'special_ped@mountain_dancer@monologue_4@monologue_4a', ['Anim'] = 'mnt_dnc_verse', ['Flags'] = 0},
            {['Label'] = 'Dans 17 (Freakout)', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationfemale@freakout', ['Anim'] = 'freakout', ['Flags'] = 0},
            {['Label'] = 'Dans 18 (Dansa till dance)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_groups_transitions@', ['Anim'] = 'trans_dance_crowd_mi_to_li_12_v1_male^2', ['Flags'] = 0},
            {['Label'] = 'Dans 19 (Dansa till dance)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_groups_transitions@', ['Anim'] = 'trans_dance_crowd_mi_to_li_12_v1_male^3', ['Flags'] = 0},
            {['Label'] = 'Dans 20 (Dansa till dance)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_groups_transitions@', ['Anim'] = 'trans_dance_crowd_mi_to_li_12_v1_male^4', ['Flags'] = 0},
            {['Label'] = 'Dans 21 (Dansa till dance)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_groups_transitions@', ['Anim'] = 'trans_dance_crowd_mi_to_li_12_v1_male^5', ['Flags'] = 0},
            {['Label'] = 'Dans 22 (Dansa till dance)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_groups_transitions@', ['Anim'] = 'trans_dance_crowd_mi_to_li_12_v1_male^6', ['Flags'] = 0},
            {['Label'] = 'Dans 23 (Dansa till dance)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity', ['Anim'] = 'trans_dance_crowd_hi_to_li__07_v1_male^1', ['Flags'] = 0},
            {['Label'] = 'Dans 24 (Dansa till dance)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity', ['Anim'] = 'trans_dance_crowd_hi_to_li__07_v1_male^2', ['Flags'] = 0},
            {['Label'] = 'Dans 25 (Dansa till dance)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity', ['Anim'] = 'trans_dance_crowd_hi_to_li__07_v1_male^3', ['Flags'] = 0},
            {['Label'] = 'Dans 26 (Dansa till dance)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity', ['Anim'] = 'trans_dance_crowd_hi_to_li__07_v1_male^4', ['Flags'] = 0},
            {['Label'] = 'Dans 27 (Dansa till dance)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_groups_transitions@from_hi_intensity', ['Anim'] = 'trans_dance_crowd_hi_to_li__07_v1_male^6', ['Flags'] = 0},
            {['Label'] = 'Dans 28 (Dansa till hardstyle)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_single_props_transitions@', ['Anim'] = 'trans_crowd_prop_hi_to_li_09_v1_male^1', ['Flags'] = 0},
            {['Label'] = 'Dans 29 (Dansa till hardstyle)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_single_props_transitions@', ['Anim'] = 'trans_crowd_prop_hi_to_li_09_v1_male^2', ['Flags'] = 0},
            {['Label'] = 'Dans 30 (Dansa till hardstyle)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_single_props_transitions@', ['Anim'] = 'trans_crowd_prop_hi_to_li_09_v1_male^3', ['Flags'] = 0},
            {['Label'] = 'Dans 31 (Dansa till hardstyle)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@dancers@crowddance_single_props_transitions@', ['Anim'] = 'trans_crowd_prop_hi_to_li_09_v1_male^6', ['Flags'] = 0},
            {['Label'] = 'Dans 32 (Dansa till hardstyle)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@lazlow@hi_podium@', ['Anim'] = 'danceidle_hi_06_base_laz', ['Flags'] = 0},
            {['Label'] = 'Dans 33 (Gör vågen)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@lazlow@hi_podium@', ['Anim'] = 'danceidle_li_07_fakedrop_laz', ['Flags'] = 0},
            {['Label'] = 'Dans 34 (Gör roboten)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@lazlow@hi_podium@', ['Anim'] = 'danceidle_mi_15_robot_laz', ['Flags'] = 0},
            {['Label'] = 'Dans 35 (Gör italjenaren)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@lazlow@hi_podium@', ['Anim'] = 'danceidle_mi_17_teapotthrust_laz', ['Flags'] = 0},
            {['Label'] = 'Dans 36 (Sväng loss)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@lazlow@hi_podium@', ['Anim'] = 'danceidle_trans_07_hi_to_li_laz', ['Flags'] = 0},
            {['Label'] = 'Dans 37 (Opa opa)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', ['Anim'] = 'high_center', ['Flags'] = 0},
            {['Label'] = 'Dans 38 (Piña Colada)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', ['Anim'] = 'low_center', ['Flags'] = 0},
            {['Label'] = 'Dans 39 (Chatcha)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_a@', ['Anim'] = 'med_center', ['Flags'] = 0},
            {['Label'] = 'Dans 40 (Logic)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@female@var_b@', ['Anim'] = 'high_center', ['Flags'] = 0},
            {['Label'] = 'Dans 41 (Höga axlar)', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@dance@dance_solo@male@var_b@', ['Anim'] = 'high_center', ['Flags'] = 0},
            {['Label'] = 'Dans 42 (i bil: galet mannen)', ['Type'] = 'animation', ['Dict'] = 'misschinese1crazydance', ['Anim'] = 'crazy_dance_1', ['Flags'] = 0},
            {['Label'] = 'Dans 43 (i bil: det svänger)', ['Type'] = 'animation', ['Dict'] = 'misschinese1crazydance', ['Anim'] = 'crazy_dance_2', ['Flags'] = 0},
    
        }    
    },
    {
        
        ['Label'] = 'Fest',
        ['Data'] = {
            {['Label'] = 'Spela musik', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_MUSICIAN'},
            {['Label'] = 'Dj', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationmale@dj', ['Anim'] = 'dj', ['Flags'] = 0},
            {['Label'] = 'Hinka Pilsner', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_PARTYING'},
            {['Label'] = 'Bomma en fuling', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_SMOKING_POT'},
            {['Label'] = 'Luftgitarr', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationmale@air_guitar', ['Anim'] = 'air_guitar', ['Flags'] = 0},
            {['Label'] = 'Luftjucka', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationfemale@air_shagging', ['Anim'] = 'air_shagging', ['Flags'] = 0},
            {['Label'] = 'Rock\'n\'roll', ['Type'] = 'animation', ['Dict'] = 'mp_player_int_upperrock', ['Anim'] = 'mp_player_int_rock', ['Flags'] = 0},
            {['Label'] = 'Sten, sax, påse', ['Type'] = 'animation', ['Dict'] = 'amb@code_human_in_car_mp_actions@fist_pump@low@ps@base', ['Anim'] = 'idle_a', ['Flags'] = 0},
            {['Label'] = 'Sten', ['Type'] = 'animation', ['Dict'] = 'amb@code_human_in_car_mp_actions@fist_pump@low@ps@base', ['Anim'] = 'enter', ['Flags'] = 0},
            {['Label'] = 'Sax', ['Type'] = 'animation', ['Dict'] = 'amb@code_human_in_car_mp_actions@v_sign@low@ps@base', ['Anim'] = 'idle_a', ['Flags'] = 0},
            {['Label'] = 'Påse', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intupperwave', ['Anim'] = 'idle_a_fp', ['Flags'] = 0},
            {['Label'] = 'Va dj', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@djs@dixon@', ['Anim'] = 'dixn_dance_a_dixon', ['Flags'] = 0},
            {['Label'] = 'Tro man kan dja', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@djs@tale_of_us@', ['Anim'] = 'tou_dance_a_cc', ['Flags'] = 0},
            {['Label'] = 'Man är bartender för kvällen', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@mini@drinking@bar@drink_v2@base', ['Anim'] = 'intro_bartender', ['Flags'] = 0},
            {['Label'] = 'Häller upp en shot', ['Type'] = 'animation', ['Dict'] = 'mini@drinking', ['Anim'] = 'shots_barman_a', ['Flags'] = 0},
            {['Label'] = 'Vinnare', ['Type'] = 'animation', ['Dict'] = 'mini@dartsoutro', ['Anim'] = 'darts_outro_01_guy1', ['Flags'] = 0},
            {['Label'] = 'Förlorare', ['Type'] = 'animation', ['Dict'] = 'mini@dartsoutro', ['Anim'] = 'darts_outro_01_guy2', ['Flags'] = 0},
            {['Label'] = 'Spela synth', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationfemale@air_synth', ['Anim'] = 'air_synth', ['Flags'] = 0},
            {['Label'] = 'Bro love', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationfemale@bro_love', ['Anim'] = 'bro_love', ['Flags'] = 0},
            {['Label'] = 'Gör zombie dansen', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationfemale@cats_cradle', ['Anim'] = 'cats_cradle', ['Flags'] = 0},
            {['Label'] = 'Gör kyckling dansen', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationfemale@chicken_taunt', ['Anim'] = 'chicken_taunt', ['Flags'] = 0},
            {['Label'] = 'Vann ett race', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationfemale@chin_brush', ['Anim'] = 'chin_brush', ['Flags'] = 0},
            {['Label'] = 'Delicato', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationfemale@finger_kiss', ['Anim'] = 'finger_kiss', ['Flags'] = 0},
            {['Label'] = 'Hjärtat klappar', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationfemale@heart_pumping', ['Anim'] = 'heart_pumping', ['Flags'] = 0},
            {['Label'] = 'Jazz händer', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationfemale@jazz_hands', ['Anim'] = 'jazz_hands', ['Flags'] = 0},
            {['Label'] = 'Nu ska vi krossa dem', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationfemale@knuckle_crunch', ['Anim'] = 'knuckle_crunch', ['Flags'] = 0},
            {['Label'] = 'Åhh nej', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationfemale@no_way', ['Anim'] = 'no_way', ['Flags'] = 0},
            {['Label'] = 'Peta näsa', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationfemale@nose_pick', ['Anim'] = 'nose_pick', ['Flags'] = 0},
            {['Label'] = 'Hälsa', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intcelebrationfemale@wave', ['Anim'] = 'wave', ['Flags'] = 0},
            {['Label'] = 'Taggad att dra en lina', ['Type'] = 'animation', ['Dict'] = 'anim@amb@nightclub@peds@', ['Anim'] = 'missfbi3_party_snort_coke_b_male3', ['Flags'] = 0},
    
        }    
    },
    {
        
        ['Label'] = 'Hälsningar',
        ['Data'] = {
            {['Label'] = 'Tjena!', ['Type'] = 'animation', ['Dict'] = 'gestures@m@standing@casual', ['Anim'] = 'gesture_hello', ['Flags'] = 0},
            {['Label'] = 'Skaka hand', ['Type'] = 'animation', ['Dict'] = 'mp_common', ['Anim'] = 'givetake1_a', ['Flags'] = 0},
            {['Label'] = 'Slå händerna samman', ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'handshake_guy_a', ['Flags'] = 0},
            {['Label'] = 'Skaka hand samt krama', ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'hugs_guy_a', ['Flags'] = 0},
            {['Label'] = 'Militärhälsing', ['Type'] = 'animation', ['Dict'] = 'mp_player_int_uppersalute', ['Anim'] = 'mp_player_int_salute', ['Flags'] = 0},
            {['Label'] = 'Boop!', ['Type'] = 'animation', ['Dict'] = 'anim@mp_radio@medium_apment', ['Anim'] = 'action_a_kitchen', ['Flags'] = 0},
            {['Label'] = 'Gangsta', ['Type'] = 'animation', ['Dict'] = 'missfbi3_sniping', ['Anim'] = 'dance_m_default', ['Flags'] = 0},
    
        }    
    },
    {
        
        ['Label'] = 'Sport/Träning',
        ['Data'] = {
            {['Label'] = 'Flexar', ['Type'] = 'animation', ['Dict'] = 'amb@world_human_muscle_flex@arms_at_side@base', ['Anim'] = 'base', ['Flags'] = 0},
            {['Label'] = 'Pumpa stång', ['Type'] = 'scenario', ['Anim'] = 'world_human_muscle_free_weights'},
            {['Label'] = 'Armhävningar', ['Type'] = 'animation', ['Dict'] = 'amb@world_human_push_ups@male@base', ['Anim'] = 'base', ['Flags'] = 0},
            {['Label'] = 'Sit-ups', ['Type'] = 'animation', ['Dict'] = 'amb@world_human_sit_ups@male@base', ['Anim'] = 'base', ['Flags'] = 0},
            {['Label'] = 'Yoga', ['Type'] = 'animation', ['Dict'] = 'amb@world_human_yoga@male@base', ['Anim'] = 'base_a', ['Flags'] = 0},
            {['Label'] = 'Pullups på stång', ['Type'] = 'scenario', ['Anim'] = 'prop_human_muscle_chin_ups'},
            {['Label'] = 'Bänkpress', ['Type'] = 'scenario', ['Anim'] = 'prop_human_seat_muscle_bench_press'},
            {['Label'] = 'Fyfan vad slut jag är!', ['Type'] = 'animation', ['Dict'] = 'amb@world_human_jog_standing@male@idle_b', ['Anim'] = 'idle_d', ['Flags'] = 0},
            {['Label'] = 'Bakåtvolt', ['Type'] = 'animation', ['Dict'] = 'anim@arena@celeb@flat@solo@no_props@', ['Anim'] = 'flip_a_player_a', ['Flags'] = 0},
            {['Label'] = 'Tagga inför hopp', ['Type'] = 'animation', ['Dict'] = 'oddjobs@bailbond_mountain', ['Anim'] = 'base_jump_idle', ['Flags'] = 0},
            {['Label'] = ' - Hoppa', ['Type'] = 'animation', ['Dict'] = 'oddjobs@bailbond_mountain', ['Anim'] = 'base_jump_spot', ['Flags'] = 0},
            {['Label'] = 'Jogga på plats', ['Type'] = 'animation', ['Dict'] = 'mb@world_human_jog_standing@female@base', ['Anim'] = 'base', ['Flags'] = 1},
    
        }    
    },
    {
        
        ['Label'] = 'Jobb',
        ['Data'] = {
            {['Label'] = 'Ta noteringar', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_CLIPBOARD'},
            {['Label'] = 'Anteckning', ['Type'] = 'scenario', ['Anim'] = 'code_human_medic_time_of_death'},
            {['Label'] = 'Polis: Brottsplatsundersökning', ['Type'] = 'animation', ['Dict'] = 'amb@code_human_police_investigate@idle_b', ['Anim'] = 'idle_f', ['Flags'] = 0},
            {['Label'] = 'Polis: Kikare', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_BINOCULARS'},
            {['Label'] = 'Polis: Sysslolös', ['Type'] = 'scenario', ['Anim'] = 'world_human_cop_idles'},
            {['Label'] = 'Polis: Trafikangivelse', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_CAR_PARK_ATTENDANT'},
            {['Label'] = 'Sjukvård: Undersöka', ['Type'] = 'scenario', ['Anim'] = 'CODE_HUMAN_MEDIC_KNEEL'},
            {['Label'] = 'Sjukvård: Bröstpump', ['Type'] = 'animation', ['Dict'] = 'mini@cpr@char_a@cpr_str', ['Anim'] = 'cpr_pumpchest', ['Flags'] = 0},
            {['Label'] = 'Sjukvård: Mun mot mun', ['Type'] = 'animation', ['Dict'] = 'mini@cpr@char_a@cpr_str', ['Anim'] = 'cpr_kol', ['Flags'] = 0},
            {['Label'] = 'Sjukvård: Bröstpump misslyckad', ['Type'] = 'animation', ['Dict'] = 'mini@cpr@char_a@cpr_str', ['Anim'] = 'cpr_fail', ['Flags'] = 0},
            {['Label'] = 'Sjukvård: Bröstpump sucsess', ['Type'] = 'animation', ['Dict'] = 'mini@cpr@char_a@cpr_str', ['Anim'] = 'cpr_success', ['Flags'] = 0},
            {['Label'] = 'Patient: Ligg på rygg', ['Type'] = 'animation', ['Dict'] = 'anim@gangops@morgue@table@', ['Anim'] = 'ko_front', ['Flags'] = 0},
            {['Label'] = 'Mekaniker: Meka motor', ['Type'] = 'animation', ['Dict'] = 'mini@repair', ['Anim'] = 'fixing_a_ped', ['Flags'] = 0},
            {['Label'] = 'Mekaniker: Svetsa', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_WELDING'},
            {['Label'] = 'Trädgård: Gräva med liten spade', ['Type'] = 'scenario', ['Anim'] = 'world_human_gardener_plant'},
            {['Label'] = 'Trädgård: Lövblåsare', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_GARDENER_LEAF_BLOWER'},
            {['Label'] = 'Städning: Borsta', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_JANITOR'},
            {['Label'] = 'Städning: Putsa', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_MAID_CLEAN'},
            {['Label'] = 'Butiksbiträde: Ge ölback', ['Type'] = 'animation', ['Dict'] = 'mp_am_hold_up', ['Anim'] = 'purchase_beerbox_shopkeeper', ['Flags'] = 0},
            {['Label'] = 'Bartender: Hälla upp öl', ['Type'] = 'animation', ['Dict'] = 'mini@drinking', ['Anim'] = 'shots_barman_b', ['Flags'] = 0},
            {['Label'] = 'Journalist: Tag kort', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_PAPARAZZI'},
            {['Label'] = 'Clown: Leka staty', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_HUMAN_STATUE'},
            {['Label'] = 'Uteliggare: Tigg med skylt', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_BUM_FREEWAY'},
            {['Label'] = 'Uteliggare: Ta en tupplur', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_BUM_SLUMPED'},
            {['Label'] = 'Uteliggare: Leta i sopor', ['Type'] = 'scenario', ['Anim'] = 'PROP_HUMAN_BUM_BIN'},
            {['Label'] = 'Bouncer', ['Type'] = 'animation', ['Dict'] = 'mini@strip_club@idles@bouncer@base', ['Anim'] = 'base', ['Flags'] = 0},
            {['Label'] = 'Proffs i golf', ['Type'] = 'animation', ['Dict'] = 'amb@world_human_golf_player@male@base', ['Anim'] = 'base', ['Flags'] = 0},
            {['Label'] = 'Använd hammare', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_HAMMERING'},
            {['Label'] = 'Hallå här är jag!', ['Type'] = 'animation', ['Dict'] = 'misscarsteal2', ['Anim'] = 'come_here_idle_c', ['Flags'] = 0},
            {['Label'] = 'Hacka dator', ['Type'] = 'animation', ['Dict'] = 'mp_prison_break', ['Anim'] = 'hack_loop', ['Flags'] = 0},
            {['Label'] = 'Fiska', ['Type'] = 'scenario', ['Anim'] = 'world_human_stand_fishing'},
            {['Label'] = 'Putta', ['Type'] = 'animation', ['Dict'] = 'missfinale_c2ig_11', ['Anim'] = 'pushcar_offcliff_m', ['Flags'] = 1},
    
        }    
    },
    {
        
        ['Label'] = 'Humor',
        ['Data'] = {
            {['Label'] = 'Klappa', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_CHEERING'},
            {['Label'] = 'Tummenupp!', ['Type'] = 'animation', ['Dict'] = 'mp_action', ['Anim'] = 'thanks_male_06', ['Flags'] = 0},
            {['Label'] = 'Snyggt där!', ['Type'] = 'animation', ['Dict'] = 'gestures@m@standing@casual', ['Anim'] = 'gesture_point', ['Flags'] = 0},
            {['Label'] = 'Följ med!', ['Type'] = 'animation', ['Dict'] = 'gestures@m@standing@casual', ['Anim'] = 'gesture_come_here_soft', ['Flags'] = 0},
            {['Label'] = 'Kom igen då!', ['Type'] = 'animation', ['Dict'] = 'gestures@m@standing@casual', ['Anim'] = 'gesture_bring_it_on', ['Flags'] = 0},
            {['Label'] = 'Pratar du med mig?', ['Type'] = 'animation', ['Dict'] = 'gestures@m@standing@casual', ['Anim'] = 'gesture_me', ['Flags'] = 0},
            {['Label'] = 'I helvete heller!', ['Type'] = 'animation', ['Dict'] = 'anim@am_hold_up@male', ['Anim'] = 'shoplift_high', ['Flags'] = 0},
            {['Label'] = 'Lugna ner dig ', ['Type'] = 'animation', ['Dict'] = 'gestures@m@standing@casual', ['Anim'] = 'gesture_easy_now', ['Flags'] = 0},
            {['Label'] = 'Uppvärmning (slagsmål)', ['Type'] = 'animation', ['Dict'] = 'anim@deathmatch_intros@unarmed', ['Anim'] = 'intro_male_unarmed_e', ['Flags'] = 0},
            {['Label'] = 'Det är inte möjligt!', ['Type'] = 'animation', ['Dict'] = 'gestures@m@standing@casual', ['Anim'] = 'gesture_damn', ['Flags'] = 0},
            {['Label'] = 'Krama', ['Type'] = 'animation', ['Dict'] = 'mp_ped_interaction', ['Anim'] = 'kisses_guy_a', ['Flags'] = 0},
            {['Label'] = 'Förbannad', ['Type'] = 'animation', ['Dict'] = 'oddjobs@towingangryidle_a', ['Anim'] = 'idle_b', ['Flags'] = 0},
            {['Label'] = 'Gråter', ['Type'] = 'animation', ['Dict'] = 'switch@trevor@floyd_crying', ['Anim'] = 'console_wasnt_fun_end_loop_floyd', ['Flags'] = 0},
            {['Label'] = 'Släng kyss♥', ['Type'] = 'animation', ['Dict'] = 'anim@mp_player_intselfieblow_kiss', ['Anim'] = 'exit', ['Flags'] = 0},
    
        }    
    },
    {
        
        ['Label'] = 'Diverse',
        ['Data'] = {
            {['Label'] = 'Sitt på marken', ['Type'] = 'animation', ['Dict'] = 'anim@heists@fleeca_bank@ig_7_jetski_owner', ['Anim'] = 'owner_idle', ['Flags'] = 0},
            {['Label'] = 'Sitt mot en vägg', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_STUPOR'},
            {['Label'] = 'Sitt på marken', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_PICNIC'},
            {['Label'] = 'Sitta och pilla på telefon', ['Type'] = 'animation', ['Dict'] = 'anim@heists@prison_heistunfinished_biztarget_idle', ['Anim'] = 'target_idle', ['Flags'] = 0},
            {['Label'] = 'Sitt på bänk, tänker på livet', ['Type'] = 'animation', ['Dict'] = 'switch@michael@parkbench_smoke_ranger', ['Anim'] = 'parkbench_smoke_ranger_loop', ['Flags'] = 0},
            {['Label'] = 'Sitt på bänk, benen i kors', ['Type'] = 'animation', ['Dict'] = 'missfbi3_party', ['Anim'] = 'snort_coke_a_female', ['Flags'] = 0},
            {['Label'] = 'Sitt på bänk, avslappnad', ['Type'] = 'animation', ['Dict'] = 'switch@michael@on_sofa', ['Anim'] = 'base_michael', ['Flags'] = 0},
            {['Label'] = ': Med kaffe', ['Type'] = 'scenario', ['Anim'] = 'prop_human_seat_bench_drink'},
            {['Label'] = ': Med öl', ['Type'] = 'scenario', ['Anim'] = 'prop_human_seat_bench_drink_beer'},
            {['Label'] = ': Med Mat', ['Type'] = 'scenario', ['Anim'] = 'prop_human_seat_bench_food'},
            {['Label'] = 'Luta dig mot en vägg', ['Type'] = 'animation', ['Dict'] = 'amb@world_human_leaning@male@wall@back@legs_crossed@base', ['Anim'] = 'base', ['Flags'] = 0},
            {['Label'] = 'Luta dig mot en vägg -slumpad', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_LEANING'},
            {['Label'] = 'Häng över räcke', ['Type'] = 'scenario', ['Anim'] = 'prop_human_bum_shopping_cart'},
            {['Label'] = 'Luta dig mot ett räcke', ['Type'] = 'animation', ['Dict'] = 'anim@amb@yacht@rail@standing@male@variant_01@', ['Anim'] = 'base', ['Flags'] = 0},
            {['Label'] = 'Luta dig mot en bardisk', ['Type'] = 'animation', ['Dict'] = 'anim@amb@yacht@rail@standing@male@variant_02@', ['Anim'] = 'base', ['Flags'] = 0},
            {['Label'] = 'Ligga på rygg', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_SUNBATHE_BACK'},
            {['Label'] = 'Ligga på mage', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_SUNBATHE'},
            {['Label'] = 'Drick en kopp kaffe', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_AA_COFFEE'},
            {['Label'] = 'Grilla', ['Type'] = 'scenario', ['Anim'] = 'PROP_HUMAN_BBQ'},
            {['Label'] = 'Titanic', ['Type'] = 'animation', ['Dict'] = 'mini@prostitutes@sexlow_veh', ['Anim'] = 'low_car_bj_to_prop_female', ['Flags'] = 0},
            {['Label'] = 'Händerna upp i luften', ['Type'] = 'animation', ['Dict'] = 'anim@mp_rollarcoaster', ['Anim'] = 'hands_up_idle_a_player_one', ['Flags'] = 0},
            {['Label'] = 'Ta en selfie', ['Type'] = 'scenario', ['Anim'] = 'world_human_tourist_mobile'},
            {['Label'] = 'Filma med telefonen', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_MOBILE_FILM_SHOCKING'},
            {['Label'] = 'Tjuvlyssna (Genom vägg)', ['Type'] = 'animation', ['Dict'] = 'mini@safe_cracking', ['Anim'] = 'idle_base', ['Flags'] = 0},
            {['Label'] = 'Pilla med mobilen', ['Type'] = 'scenario', ['Anim'] = 'world_human_stand_mobile'},
            {['Label'] = 'Vars fan är jag? (karta)', ['Type'] = 'scenario', ['Anim'] = 'world_human_tourist_map'},
            {['Label'] = 'Ont i magen(liggandes)', ['Type'] = 'animation', ['Dict'] = 'combat@damage@writheidle_a', ['Anim'] = 'writhe_idle_b', ['Flags'] = 0},
            {['Label'] = 'Kissnödig', ['Type'] = 'animation', ['Dict'] = 'amb@world_human_prostitute@cokehead@base', ['Anim'] = 'base', ['Flags'] = 0},
            {['Label'] = 'Nervös', ['Type'] = 'animation', ['Dict'] = 'switch@michael@parkbench_smoke_ranger', ['Anim'] = 'ranger_nervous_loop', ['Flags'] = 0},
            {['Label'] = 'Armarna i kors', ['Type'] = 'animation', ['Dict'] = 'amb@world_human_hang_out_street@female_arms_crossed@base', ['Anim'] = 'base', ['Flags'] = 0},
            {['Label'] = 'Lägger i pengar', ['Type'] = 'animation', ['Dict'] = 'anim@amb@clubhouse@jukebox@', ['Anim'] = 'insert_coins', ['Flags'] = 0},
            {['Label'] = 'Stå vid baren', ['Type'] = 'animation', ['Dict'] = 'anim@amb@warehouse@toolbox@', ['Anim'] = 'idle', ['Flags'] = 0},
            {['Label'] = 'Peka på flygplan', ['Type'] = 'animation', ['Dict'] = 'anim@mp_point', ['Anim'] = 'sweep_high_full_behind_left', ['Flags'] = 0},
            {['Label'] = 'Peka på fordon', ['Type'] = 'animation', ['Dict'] = 'anim@mp_radio@garage@high', ['Anim'] = 'idle_a', ['Flags'] = 0},
            {['Label'] = 'Stäng av stora röda knappen', ['Type'] = 'animation', ['Dict'] = 'anim@mp_radio@high_apment', ['Anim'] = 'action_a_bedroom', ['Flags'] = 0},
            {['Label'] = 'Krama snöboll', ['Type'] = 'animation', ['Dict'] = 'anim@mp_snowball', ['Anim'] = 'pickup_snowball', ['Flags'] = 0},
            {['Label'] = 'Håll upp händerna', ['Type'] = 'animation', ['Dict'] = 'mp_country_bank_heist', ['Anim'] = 'guard_handsup_loop', ['Flags'] = 0},
            {['Label'] = 'Klia dig i bakhuvudet', ['Type'] = 'animation', ['Dict'] = 'mp_cp_stolen_tut', ['Anim'] = 'b_think', ['Flags'] = 0},
            {['Label'] = 'Va rädd', ['Type'] = 'animation', ['Dict'] = 'amb@code_human_cower_stand@male@react_cowering', ['Anim'] = 'base_back_left', ['Flags'] = 0},
            {['Label'] = 'Värma sig', ['Type'] = 'animation', ['Dict'] = 'amb@world_human_stand_fire@male@base', ['Anim'] = 'base', ['Flags'] = 0},
            {['Label'] = 'Stå vid en atm', ['Type'] = 'animation', ['Dict'] = 'amb@prop_human_atm@female@exit', ['Anim'] = 'exit', ['Flags'] = 0},
            {['Label'] = 'Duscha', ['Type'] = 'animation', ['Dict'] = 'mp_safehouseshower@male@', ['Anim'] = 'male_shower_enter_into_idle', ['Flags'] = 0},
            {['Label'] = 'Gör rundan', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_BUM_FREEWAY'},
            {['Label'] = 'Reporter: Ta en bild', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_PAPARAZZI'},
    
        }    
    },
    {
        
        ['Label'] = 'Gångstilar',
        ['Data'] = {
            {['Label'] = 'Normal man', ['Type'] = 'walking_style', ['Style'] = 'move_m@generic'},
            {['Label'] = 'Normal kvinna', ['Type'] = 'walking_style', ['Style'] = 'move_f@generic'},
            {['Label'] = 'Deprimerad man', ['Type'] = 'walking_style', ['Style'] = 'move_m@depressed@a'},
            {['Label'] = 'Deprimerad kvinna', ['Type'] = 'walking_style', ['Style'] = 'move_f@depressed@a'},
            {['Label'] = 'Business', ['Type'] = 'walking_style', ['Style'] = 'move_m@business@a'},
            {['Label'] = 'Bestämd', ['Type'] = 'walking_style', ['Style'] = 'move_m@brave@a'},
            {['Label'] = 'Lugn', ['Type'] = 'walking_style', ['Style'] = 'move_m@casual@a'},
            {['Label'] = 'Tung person', ['Type'] = 'walking_style', ['Style'] = 'move_m@fat@a'},
            {['Label'] = 'Hipster', ['Type'] = 'walking_style', ['Style'] = 'move_m@hipster@a'},
            {['Label'] = 'Skadad', ['Type'] = 'walking_style', ['Style'] = 'move_m@injured'},
            {['Label'] = 'Osäker snabb', ['Type'] = 'walking_style', ['Style'] = 'move_m@hurry@a'},
            {['Label'] = 'Hobo', ['Type'] = 'walking_style', ['Style'] = 'move_m@hobo@a'},
            {['Label'] = 'Ledsen', ['Type'] = 'walking_style', ['Style'] = 'move_m@sad@a'},
            {['Label'] = 'Biff', ['Type'] = 'walking_style', ['Style'] = 'move_m@muscle@a'},
            {['Label'] = 'Chokad', ['Type'] = 'walking_style', ['Style'] = 'move_m@shocked@a'},
            {['Label'] = 'Avvikande', ['Type'] = 'walking_style', ['Style'] = 'move_m@shadyped@a'},
            {['Label'] = 'Utmattad', ['Type'] = 'walking_style', ['Style'] = 'move_m@buzzed'},
            {['Label'] = 'Bestämd snabb', ['Type'] = 'walking_style', ['Style'] = 'move_m@hurry_butch@a'},
            {['Label'] = 'Hippie', ['Type'] = 'walking_style', ['Style'] = 'move_m@money'},
            {['Label'] = 'Smygaktig springstil', ['Type'] = 'walking_style', ['Style'] = 'move_m@quick'},
            {['Label'] = 'Tudelu', ['Type'] = 'walking_style', ['Style'] = 'move_f@maneater'},
            {['Label'] = 'Två väskor och högklackat', ['Type'] = 'walking_style', ['Style'] = 'move_f@sassy'},
            {['Label'] = 'Arrogant', ['Type'] = 'walking_style', ['Style'] = 'move_f@arrogant@a'},
            {['Label'] = 'Getto', ['Type'] = 'walking_style', ['Style'] = 'move_m@gangster@generic'},
            {['Label'] = 'Full', ['Type'] = 'walking_style', ['Style'] = 'move_m@drunk@slightlydrunk'},
            {['Label'] = 'Fullare', ['Type'] = 'walking_style', ['Style'] = 'move_m@drunk@moderatedrunk'},
            {['Label'] = 'Fullast', ['Type'] = 'walking_style', ['Style'] = 'move_m@drunk@verydrunk'},
            {['Label'] = 'Jag kan också springa', ['Type'] = 'walking_style', ['Style'] = 'move_m@alien'},
            {['Label'] = 'Kryp', ['Type'] = 'animation', ['Dict'] = 'move_injured_ground', ['Anim'] = 'front_loop', ['Flags'] = 0},
            {['Label'] = 'Kryp 2', ['Type'] = 'animation', ['Dict'] = 'move_crawl', ['Anim'] = 'onfront_fwd', ['Flags'] = 0},
    
        }    
    },
    {
        
        ['Label'] = 'Snusk',
        ['Data'] = {
            {['Label'] = 'Klias på bollarna ', ['Type'] = 'animation', ['Dict'] = 'mp_player_int_uppergrab_crotch', ['Anim'] = 'mp_player_int_grab_crotch', ['Flags'] = 0},
            {['Label'] = 'Vink vink ', ['Type'] = 'animation', ['Dict'] = 'mini@strip_club@idles@stripper', ['Anim'] = 'stripper_idle_02', ['Flags'] = 0},
            {['Label'] = 'Cigarette (Pose) ', ['Type'] = 'scenario', ['Anim'] = 'WORLD_HUMAN_PROSTITUTE_HIGH_CLASS'},
            {['Label'] = 'Bröstfokus ', ['Type'] = 'animation', ['Dict'] = 'mini@strip_club@backroom@', ['Anim'] = 'stripper_b_backroom_idle_b', ['Flags'] = 0},
            {['Label'] = 'Strip Tease 1 ', ['Type'] = 'animation', ['Dict'] = 'mini@strip_club@lap_dance@ld_girl_a_song_a_p1', ['Anim'] = 'ld_girl_a_song_a_p1_f', ['Flags'] = 0},
            {['Label'] = 'Strip Tease 2 ', ['Type'] = 'animation', ['Dict'] = 'mini@strip_club@private_dance@part2', ['Anim'] = 'priv_dance_p2', ['Flags'] = 0},
            {['Label'] = 'Stip Tease 3 ', ['Type'] = 'animation', ['Dict'] = 'mini@strip_club@private_dance@part3', ['Anim'] = 'priv_dance_p3', ['Flags'] = 0},
            {['Label'] = 'Lapdance 1 ', ['Type'] = 'animation', ['Dict'] = 'mini@strip_club@lap_dance@ld_girl_a_song_a_p1', ['Anim'] = 'ld_girl_a_song_a_p1_f_face', ['Flags'] = 0},
            {['Label'] = 'Ta den i räva ', ['Type'] = 'animation', ['Dict'] = 'rcmpaparazzo_2', ['Anim'] = 'shag_loop_poppy', ['Flags'] = 0},
            {['Label'] = 'Tryck den i räva ', ['Type'] = 'animation', ['Dict'] = 'rcmpaparazzo_2', ['Anim'] = 'shag_loop_a', ['Flags'] = 0},
            {['Label'] = 'Kolla på strippor ', ['Type'] = 'animation', ['Dict'] = 'mini@strip_club@leaning@base', ['Anim'] = 'base', ['Flags'] = 0},
            {['Label'] = 'Bli riden i bil ', ['Type'] = 'animation', ['Dict'] = 'oddjobs@assassinate@vice@sex', ['Anim'] = 'frontseat_carsex_loop_m', ['Flags'] = 0},
            {['Label'] = ': Baksäte ', ['Type'] = 'animation', ['Dict'] = 'random@drunk_driver_2', ['Anim'] = 'cardrunksex_loop_m', ['Flags'] = 0},
            {['Label'] = 'Rid en person i bil ', ['Type'] = 'animation', ['Dict'] = 'oddjobs@assassinate@vice@sex', ['Anim'] = 'frontseat_carsex_loop_f', ['Flags'] = 0},
            {['Label'] = ': Baksäte ', ['Type'] = 'animation', ['Dict'] = 'random@drunk_driver_2', ['Anim'] = 'cardrunksex_loop_f', ['Flags'] = 0},
            {['Label'] = 'Polce dance ', ['Type'] = 'animation', ['Dict'] = 'mini@strip_club@pole_dance@pole_dance1', ['Anim'] = 'pd_dance_01', ['Flags'] = 0},
            {['Label'] = 'Ge avsugning ', ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'pimpsex_hooker', ['Flags'] = 0},
            {['Label'] = 'Få avsugning ', ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'pimpsex_punter', ['Flags'] = 0},
            {['Label'] = 'Bli tagen ', ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'shagloop_hooker', ['Flags'] = 0},
            {['Label'] = 'Ta henne ', ['Type'] = 'animation', ['Dict'] = 'misscarsteal2pimpsex', ['Anim'] = 'shagloop_pimp', ['Flags'] = 0},
    
        }    
    },
    
}