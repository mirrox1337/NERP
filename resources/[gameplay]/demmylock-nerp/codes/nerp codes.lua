--[[
    This is where I place the default codes during development.
    The idea is that the server I cooperate with in the development of demmylock
    will override these codes in their codes/ directory, so their codes remain
    a secret. I don't think they'd want their codes openly displayed on GitHub!
--]]

AddCodes('Bennys', {_default = '8365'})
AddCodes('Bolingbroke', {_default = '3571'})
AddCodes('Gentlemen', {
    _default = '6548',
    ['Isboxen'] = '*44#',
    ['Kontoret'] = '8005',
})
AddCodes('Lost MC',{
    _default = '7878',
    ['Grinden'] = '7878',
    ['Till verkstaden'] = {'7878'},
    ['Till klubben'] = {'7878'},
})
AddCodes('Mekonomen', {_default = '9632'})
AddCodes('Mission Row', {
    _default = '5924',
    ['Polischefen'] = '0891',
    ['Cell 1'] = '0102',
    ['Cell 2'] = '0240',
    ['Cell 3'] = '1003',
    ['Vapenlager'] = '#59#',
    ['Bevisförvar'] = '2413',
})
AddCodes('Playboy Mansion', {
    _default='6472',
    ['Stuvad kanin'] = '2841',
    ['Kontoret'] = '3954',
})
AddCodes('Playboy Perimeter', {_default = '4824'})
AddCodes('Sheriff Paleto', {_default='1191'})
AddCodes('Sheriff Sandy', {_default='1911'})
AddCodes('Sjukhuset', {_default = '5439'})
AddCodes('Tvättaren', {
    ['Ingång'] = {'4592'},
})

-- Adding *new* codes below here, just to be nice to Mike. HI MIKE!
-- I'll put dates on it so it's easy to see what was added when.

-- 2020-02-20
AddCodes('Madrazo Ranch', {
    _default='2269',
    ['Källaren'] = '2269',
    ['Lagret'] = '2269',
})

-- 2020-02-21
AddCodes('Bilcenter', {
    _default = '1277',
    ['Chefskontoret'] = '1377',
})
