resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description 'chrono-jewelry'

version '1.0.0'

client_scripts {
	'@es_extended/locale.lua',
	'locales/sv.lua',
	'config.lua',
	'client/main.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
	'@es_extended/locale.lua',
	'locales/sv.lua',
	'config.lua',
	'server/main.lua'
}

dependencies {
	'es_extended',
	'mythic_notify'
}
