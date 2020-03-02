name 'Never Ending RolePlay Bilcenter'
description 'Köpa bil? KÖPA BIL!'
author 'Demonen'

fx_version 'adamant'
games { 'gta5' }

dependencies   { 'es_extended', 'mysql-async', 'esx_society', 'esx_addonaccount', 'esx_billing' }
shared_scripts { 'config.lua', '@es_extended/locale.lua', 'locales/*.lua', 'code/sh_bilcenter.lua' }
server_scripts { '@mysql-async/lib/MySQL.lua', 'code/sv_bilcenter.lua' }
client_scripts { 'code/cl_bilcenter.lua' }
