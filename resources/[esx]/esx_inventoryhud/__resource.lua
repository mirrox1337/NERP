resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

description "ESX Inventory HUD"

version "1.1"

ui_page "html/ui.html"

client_scripts {
  "@es_extended/locale.lua",
  "client/main.lua",
  "client/shop.lua",
  "client/trunk.lua",
  "client/property.lua",
  "client/motels.lua",
  "client/beds.lua",
  "client/player.lua",
  "locales/cs.lua",
  "locales/sv.lua",
  "locales/fr.lua",
  "config.lua"
}

server_scripts {
  "@es_extended/locale.lua",
  "@async/async.lua",
  "@mysql-async/lib/MySQL.lua",
  "config.lua",
  "server/main.lua",
  "locales/cs.lua",
  "locales/sv.lua",
  "locales/fr.lua",
}

files {
  "html/ui.html",
  "html/css/ui.css",
  "html/css/jquery-ui.css",
  "html/js/inventory.js",
  "html/js/config.js",
  -- JS LOCALES
  "html/locales/cs.js",
  "html/locales/sv.js",
  "html/locales/fr.js",
  -- IMAGES
  "html/img/bullet.png",
  -- ICONS
  'html/img/items/*.png',
}