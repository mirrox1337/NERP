resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'ESX Car Thief'

version '1.0.0'

server_scripts {
	'@es_extended/locale.lua',
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua',
	'locales/en.lua',
	'locales/es.lua',
	'locales/fr.lua',
	'server/cooldown.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'config.lua',
	'client/main.lua',
	'locales/en.lua',
	'locales/es.lua',
	'locales/fr.lua'
}

dependency 'es_extended'
