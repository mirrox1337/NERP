-- TriggerEvent('esx_policedog:openMenu') to open menu

Config = {
    Job = 'police',
    Command = 'phund', -- set to false if you dont want to have a command
    Model = 351016938,
    TpDistance = 50.0,
    Sit = {
        dict = 'creatures@rottweiler@amb@world_dog_sitting@base',
        anim = 'base'
    },
    Drugs = {'weed', 'weed_pooch'}, -- add all drugs here for the dog to detect
}

Strings = {
    ['not_police'] = 'Du är ingen Polis!',
    ['menu_title'] = 'Polis Hund',
    ['take_out_remove'] = 'Ta ut / ta bort Polishund.',
    ['deleted_dog'] = 'Ta bort Polishunden.',
    ['spawned_dog'] = 'Ta fram en Polis Hund',
    ['sit_stand'] = 'Be hunden sitta / stå',
    ['no_dog'] = "Du har ingen Polishund!",
    ['dog_dead'] = 'Hunden är död :/',
    ['search_drugs'] = 'Sök närmsta spelare efter droger.',
    ['no_drugs'] = 'Inga droger hittade.', 
    ['drugs_found'] = 'Hittade droger',
    ['dog_too_far'] = 'Hunden är för långt bort!',
    ['attack_closest'] = 'Attackera närmsta spelare.'
}