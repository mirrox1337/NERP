Citizen.CreateThread(function()
  while true do
    Citizen.Wait(1)
    -- här hittar ni sidan till lägga till fler vapen här nere som npc ej kan droppa längre (https://pastebin.com/8EuSv2r1)
    RemoveAllPickupsOfType(0xC2AF8B50) -- carbine rifle
    RemoveAllPickupsOfType(0xD93F3079) -- pistol
    RemoveAllPickupsOfType(0xA9355DCD) -- pumpshotgun
    RemoveAllPickupsOfType(0xD919B569) -- ak47
    RemoveAllPickupsOfType(0xB8F73C4B) -- smg
    RemoveAllPickupsOfType(0x631B3559) -- bat
    RemoveAllPickupsOfType(0x8C0F737B) -- combatpistol
    RemoveAllPickupsOfType(0x69C100F4) -- glofklubba
    RemoveAllPickupsOfType(0x6DFF6B70) -- microsmg
    RemoveAllPickupsOfType(0xB0769393) -- sns pistol
  end
end)