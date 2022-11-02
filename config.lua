-- simple config
Config = {}

Config.pedmodel = `cs_carbuyer`
Config.pedlocation = vector4(250.72, -1076.23, 29.29, 164.33) -- set up for https://github.com/leuxum1/courthouse-fivem
Config.pedlocationTarget = vector4(250.12, -1075.98, 28.84, 180.47)      -- optional location for sitting down
Config.distance = 3.0
Config.pedloadrange = 20     --meters
Config.PedMethod = "qb-target"  -- qb-target or mojito_dialogue // remember to change the fxmanifest dependency  'mojito_dialogue' or 'qb-target'
Config.Purchasables = { 
                        ["id_card"] = {
                            label = "ID Card",
                            cost = 50,
                            item = "id_card",
                            icon = "fa-solid fa-id-card",
                        },
                        ["driver_license"] = {
                            label = "Driver License",
                            cost = 50,
                            metadata = "driver",
                            item = "driver_license",
                            icon = "fa-regular fa-id-card",
                        },
                        ["weaponlicense"] = {
                            label = "Weapon License",
                            cost = 50,
                            metadata = "weapon",
                            item = "weaponlicense",
                            icon = "fa-solid fa-person-rifle",
                        }}
