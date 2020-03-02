# esx_Securitas

### Requirements
* Auto mode
  * [esx_billing](https://github.com/FXServer-ESX/fxserver-esx_billing)

* Player management (boss actions and armory with buyable weapons)
  * [esx_society](https://github.com/FXServer-ESX/fxserver-esx_society)
  * [esx_datastore](https://github.com/FXServer-ESX/fxserver-esx_datastore)

* ESX Identity Support
  * [esx_identity](https://github.com/ESX-Org/esx_identity)

* ESX License Support
  * [esx_license](https://github.com/ESX-Org/esx_license)
  
  ### LICENSE
Du får mer än gärna ändra vad du vill i scriptet men du får INTE sälja vidare scriptet eller ladda upp det på nytt, hänvisa folket hit istället.

## Download & Installation

### Using [fvm](https://github.com/qlaffont/fvm-installer)
```
fvm install --save --folder=esx esx-org/esx_Securitas
```

### Using Git
```
cd resources
git clone https://github.com/kebban100/esx_Securitas [esx]/esx_Securitas
```

### Manually
- Download https://github.com/kebban100/esx_Securitas/archive/master.zip
- Put it in the `[esx]` directory


## Installation
- Import `esx_Securitas.sql` in your database
- Add this in your server.cfg :

```
start esx_Securitas
```
-  * If you want player management you have to set `Config.EnablePlayerManagement` to `true` in `config.lua`
   * If you want armory management you have to set `Config.EnableArmoryManagement` to `true` in `config.lua`
   * If you want license management you have to set `Config.EnableLicenses` to `true` in `config.lua`
