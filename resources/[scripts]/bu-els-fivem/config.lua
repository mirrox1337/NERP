vcf_files = {
	"POLICE.xml",
	"POLICE2.xml",
	"POLICE3.xml",
	"POLICE4.xml",
	"AMBULANCE2.xml",
	"AMBULANCE.xml",
	"FBI.xml",
	"SHERIFF.xml",
	"SHERIFF2.xml",
	"xc90pol.xml",
	"v60civ.xml",
	"xc90n.xml",
	"v60.xml",
	"policet2.xml",
	"policet3.xml",
	"police19.xml",
	"PRANGER.xml",
	"police3.xml",
	"policevw.xml",
	"POLICEOLD2.xml",
	"POLICEB.xml",
	"dinghy.xml",
	"polvw6.xml",
	"UTILLITRUCK3.xml",
	"POLICET.xml",
	"FLATBED.xml",
	"civxc90.xml",
    "civbmw.xml",
    "polxc90.xml",
}

pattern_files = {
	"WIGWAG.xml",
	"WIGWAG3.xml",
	"FAST.xml",
	"COMPLEX.xml",
	"BACKFOURTH.xml",
	"BACKFOURTH2.xml",
	"T_ADVIS_RIGHT_LEFT.xml",
	"T_ADVIS_LEFT_RIGHT.xml",
	"T_ADVIS_BACKFOURTH.xml",
    "WIGWAG5.xml"
}

modelsWithTrafficAdvisor = {
	"FBI2",
}

modelsWithFireSiren = {
    "FIRETRUK",
}


modelsWithAmbWarnSiren = {   
    "AMBULANCE",
    "AMBULANCE2",
}

stagethreewithsiren = false
playButtonPressSounds = true
vehicleStageThreeAdvisor = {
    "FBI3",
}


vehicleSyncDistance = 350
envirementLightBrightness = 0.2

build = "master"

shared = {
	horn = 86,
}

keyboard = {
	modifyKey = 132,
	stageChange = 85,
	guiKey = 213,
	takedown = 245,
	siren = {
		tone_one = 157,
		tone_two = 158,
		tone_three = 160,
		dual_toggle = 164,
		dual_one = 165,
		dual_two = 159,
		dual_three = 161,
	},
	pattern = {
		primary = 246,
		secondary = 304,
		advisor = 183,
	},
}

controller = {
	modifyKey = 73,
	stageChange = 80,
	takedown = 74,
	siren = {
		tone_one = 173,
		tone_two = 85,
--		tone_three = 172,
	},
}