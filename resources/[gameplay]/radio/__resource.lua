resource_manifest_version "44febabe-d386-4d18-afbe-5e627f4af937"

-- Example custom radios
supersede_radio "RADIO_02_POP" { url = "http://edge-bauersefm-01-cr.sharp-stream.com/nrj_instreamtest_se_mp3", volume = 0.2, name = "[NRJ]" }
supersede_radio "RADIO_04_PUNK" { url = "http://edge-bauersefm-04-cr.sharp-stream.com/mixmegapol_instream_se_mp3", volume = 0.2, name = "[Mix Megapol]" }
supersede_radio "RADIO_01_CLASS_ROCK" { url = "http://edge-bauersefm-02-gos1.sharp-stream.com/rockklassiker_instream_se_mp3", volume = 0.2, name = "[Rock Klassiker]" }
supersede_radio "RADIO_03_HIPHOP_NEW" { url = "http://fm02-ice.stream.khz.se/fm02_mp3", volume = 0.2, name = "[Bandit Rock]" }
supersede_radio "RADIO_06_COUNTRY" { url = "http://wr15-ice.stream.khz.se/wr15_mp3", volume = 0.2, name = "[Dansbands Favoriter]" }
supersede_radio "RADIO_05_TALK_01" { url = "http://wr11-ice.stream.khz.se/wr11_mp3", volume = 0.2, name = "[Bandit Classics]" }
supersede_radio "RADIO_20_THELAB" { url = "http://wr03-ice.stream.khz.se/wr03_mp3", volume = 0.2, name = "[Bandit Metal]" }
supersede_radio "RADIO_07_DANCE_01" { url = "http://wr13-ice.stream.khz.se/wr13_mp3", volume = 0.2, name = "[Svenska Favoriter]" }
supersede_radio "RADIO_13_JAZZ" { url = "https://http-live.sr.se/p1-mp3-192", volume = 0.2, name = "[Sveriges Radio P1]" }
supersede_radio "RADIO_12_REGGAE" { url = "https://http-live.sr.se/p4varmland-mp3-192", volume = 0.2, name = "[SR P4 Värmland]" }


files {
	"index.html"
}

ui_page "index.html"

client_scripts {
	"data.js",
	"client.js"
}
