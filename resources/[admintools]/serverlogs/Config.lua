DiscordWebhookSystemInfos = 'https://discordapp.com/api/webhooks/662664888229036072/SbANYJU9e_9Ox2_Eb60fDYgx0Mwm6Ef96RfO80l4Z_gDECHu7rzHo-ILN8V_Lc_nDCu_'
DiscordWebhookKillinglogs = 'https://discordapp.com/api/webhooks/662664888229036072/SbANYJU9e_9Ox2_Eb60fDYgx0Mwm6Ef96RfO80l4Z_gDECHu7rzHo-ILN8V_Lc_nDCu_'
DiscordWebhookChat = 'https://discordapp.com/api/webhooks/662664888229036072/SbANYJU9e_9Ox2_Eb60fDYgx0Mwm6Ef96RfO80l4Z_gDECHu7rzHo-ILN8V_Lc_nDCu_'

SystemAvatar = 'https://i.imgur.com/rKi1H7l.png'

UserAvatar = 'https://i.imgur.com/rKi1H7l.png'

SystemName = 'NERP - Bot'


--[[ Special Commands formatting
		 *YOUR_TEXT*			--> Make Text Italics in Discord
		**YOUR_TEXT**			--> Make Text Bold in Discord
	   ***YOUR_TEXT***			--> Make Text Italics & Bold in Discord
		__YOUR_TEXT__			--> Underline Text in Discord
	   __*YOUR_TEXT*__			--> Underline Text and make it Italics in Discord
	  __**YOUR_TEXT**__			--> Underline Text and make it Bold in Discord
	 __***YOUR_TEXT***__		--> Underline Text and make it Italics & Bold in Discord
		~~YOUR_TEXT~~			--> Strikethrough Text in Discord
]]
-- Use 'USERNAME_NEEDED_HERE' without the quotes if you need a Users Name in a special command
-- Use 'USERID_NEEDED_HERE' without the quotes if you need a Users ID in a special command


-- These special commands will be printed differently in discord, depending on what you set it to
SpecialCommands = {
				   {'/ooc', '**[OOC]:**'},
				   {'/me', 'Skrev /me '},
				  }

						
-- These blacklisted commands will not be printed in discord
BlacklistedCommands = {
					  }

-- These Commands will use their own webhook
OwnWebhookCommands = {
					  {'/me', 'https://discordapp.com/api/webhooks/664886327937859584/7Dn9ZXutd0o0AHyzp2z9TSHFh_BU69-5b6HuNrfc8nMvLPFnY8DJIaoFwssrbTYC1e4n'},
					  }

-- These Commands will be sent as TTS messages
TTSCommands = {
			  }

