description 'wille-smoke'

version '1.0.0'

server_scripts {

  '@es_extended/locale.lua',
  'locales/en.lua',
  'server/main.lua',
  'config.lua'

}

client_scripts {

  '@es_extended/locale.lua',
  'locales/en.lua',
  'config.lua',
  'client/main.lua'

}
