
------
-- InteractSound by Scott
-- Verstion: v0.0.1
------

-- Manifest Version
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

-- Client Scripts
client_script 'client/main.lua'

-- Server Scripts
server_script 'server/main.lua'

-- NUI Default Page
ui_page('client/html/index.html')

-- Files needed for NUI
-- DON'T FORGET TO ADD THE SOUND FILES TO THIS!
files({
    'client/html/index.html',
    -- Begin Sound Files Here...
    -- client/html/sounds/ ... .oggdonvito_1
    'client/html/sounds/donvito_1.ogg',
    'client/html/sounds/donvito_2.ogg',
    'client/html/sounds/donvito_3.ogg',
    'client/html/sounds/donvito_4.ogg',
    'client/html/sounds/maggan_1.ogg',
    'client/html/sounds/maggan_2.ogg',
    'client/html/sounds/maggan_3.ogg',
    'client/html/sounds/maggan_4.ogg',
    'client/html/sounds/heart.ogg',
    'clinet/html/sounds/cell.ogg',
    'client/html/sounds/vakt.ogg',
    'client/html/soudns/lockpick.ogg',
    'client/html/sounds/cuffs.ogg'
})
