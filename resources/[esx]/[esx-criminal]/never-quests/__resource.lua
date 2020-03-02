ui_page {
	'html/index.html'
}

files {
	'html/index.html',
	'html/background.jpg',
	'html/Bender.woff',
	'html/minigame.js',
	'html/style.css',
}

client_scripts {
	'utils.lua',
	'@es_extended/client/wrapper.lua',
	'client/markers.lua',
	'client/mysql.lua',
	'client/notifications.lua',
	'client/main.lua',
	'client/quests/quest.lua',
	'client/quests/don-vito-1.lua',
	'client/quests/don-vito-2.lua',
	'client/quests/don-vito-3.lua',
	'client/quests/don-vito-4.lua',
	'client/quests/maggan-1.lua',
	'client/quests/maggan-2.lua',
	'client/quests/maggan-3.lua',
	'client/quests/maggan-4.lua'
}

server_scripts {
	'utils.lua',
    '@mysql-async/lib/MySQL.lua',
	'server/main.lua',
	'server/cooldowns.lua'
}