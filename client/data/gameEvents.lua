---@class GameEvents
local GameEvents = {

    [`EVENT_NETWORK_PICKUP_RESPAWNED`] = {
        name = "EVENT_NETWORK_PICKUP_RESPAWNED",
        hash = "0x52982BAE",
        datasize = 2,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "pickup entity id" },
            [1] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_STAT_VALUE_CHANGED`] = {
        name = "EVENT_STAT_VALUE_CHANGED",
        hash = "0xCF3B2D41",
        datasize = 2,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "stat value type hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/stat_values.lua) )" },
            [1] = { type = "int", data = "unknown" },

        }
    },
    [`EVENT_NETWORK_SESSION_EVENT`] = {
        name = "EVENT_NETWORK_SESSION_EVENT",
        hash = "0x62D903F9",
        datasize = 10,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "unknown (??? session event type)" },
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "unknown" },

        }
    },
    [`EVENT_NETWORK_INCAPACITATED_ENTITY`] = {
        name = "EVENT_NETWORK_INCAPACITATED_ENTITY",
        hash = "0x284E1EC8",
        datasize = 4,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "VictimEntityId" },
            [1] = { type = "int", data = "Damager entity id" },
            [2] = { type = "int", data = "WeaponUsed hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )" },
            [3] = { type = "float", data = "Damage" },
        }
    },
    [`EVENT_IMPENDING_SAMPLE_PROMPT`] = {
        name = "EVENT_IMPENDING_SAMPLE_PROMPT",
        hash = "0xD396D3E5",
        datasize = 2,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "unknown" },
            [1] = { type = "int", data = "inventory item hash" },
        }
    },
    [`EVENT_RAN_OVER_PED`] = {
        name = "EVENT_RAN_OVER_PED",
        hash = "0x14B1352F",
        datasize = 2,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "unknown" },
            [1] = { type = "int", data = "ped id that was ran over" },
        }
    },
    [`EVENT_LOOT_COMPLETE`] = {
        name = "EVENT_LOOT_COMPLETE",
        hash = "0x52063E5B",
        datasize = 3,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "looterId" },
            [1] = { type = "int", data = "Looted entity id" },
            [2] = { type = "int", data = "isLootSuccess" },
        }
    },
    [`EVENT_NETWORK_AWARD_CLAIMED`] = {
        name = "EVENT_NETWORK_AWARD_CLAIMED",
        hash = "0x67D36B9D",
        datasize = 12,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "request id" },
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown (??? result code [list](#award-claimed-result-codes))" },
            [5] = { type = "int", data = "unknown (??? award hash [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/awards.lua))" },
            [6] = { type = "int", data = "unknown (??? awarded xp amount)" },
            [7] = { type = "int", data = "unknown (??? awarded rank amount)" },
            [8] = { type = "int", data = "unknown (??? awarded cash amount)" },
            [9] = { type = "int", data = "unknown (??? awarded gold amount)" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "unknown" },

        }
    },
    [`EVENT_SCENARIO_DESTROY_PROP`] = {
        name = "EVENT_SCENARIO_DESTROY_PROP",
        hash = "0xCDB85C02",
        datasize = 2,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "iScriptUID" },
            [1] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_CALCULATE_LOOT`] = {
        name = "EVENT_CALCULATE_LOOT",
        hash = "0x834F764A",
        datasize = 26,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "unknown" },
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "inventory item hash" },
            [3] = { type = "int", data = "consumable action hash" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "unknown" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "unknown" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "unknown" },
            [23] = { type = "int", data = "looter entity id" },
            [24] = { type = "int", data = "looted entity id" },
            [25] = { type = "int", data = "unknown" },

        }
    },
    [`EVENT_NETWORK_POSSE_EX_ADMIN_DISBANDED`] = {
        name = "EVENT_NETWORK_POSSE_EX_ADMIN_DISBANDED",
        hash = "0x879925A5",
        datasize = 9,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "unknown" },
            [1] = { type = "int", data = "unknown (??? posse name)" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },

        }
    },
    [`EVENT_NETWORK_PICKUP_COLLECTION_FAILED`] = {
        name = "EVENT_NETWORK_PICKUP_COLLECTION_FAILED",
        hash = "0x5CF6549E",
        datasize = 3,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "unknown" },
            [1] = { type = "int", data = "player id" },
            [2] = { type = "int", data = "pickup type hash  ( [list](https://github.com/femga/rdr3_discoveries/blob/master/objects/pickup_list.lua))" },
        }
    },
    [`EVENT_SHOCKING_WITNESS_REPORTING`] = {
        name = "EVENT_SHOCKING_WITNESS_REPORTING",
        hash = "0xD8F0302C",
        datasize = 3,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "unknown" },
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_CRIME_WITNESSED`] = {
        name = "EVENT_CRIME_WITNESSED",
        hash = "0xE770188C",
        datasize = 3,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "witness entity id" },
            [1] = { type = "int", data = "crime type hash" },
            [2] = { type = "int", data = "criminal entity id" },
        }
    },
    [`EVENT_PED_SEEN_DEAD_PED`] = {
        name = "EVENT_PED_SEEN_DEAD_PED",
        hash = "0x0AA2F724",
        datasize = 2,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "witness entity id" },
            [1] = { type = "int", data = "dead ped entity id" },
        }
    },
    [`EVENT_PLAYER_DEATH`] = {
        name = "EVENT_PLAYER_DEATH",
        hash = "0xC57D86A4",
        datasize = 2,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "victim entity id" },
            [1] = { type = "int", data = "killer entity id" },
        }
    },
    [`EVENT_CRIME_REPORTED`] = {
        name = "EVENT_CRIME_REPORTED",
        hash = "0xCE863CA3",
        datasize = 3,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "witness entity id" },
            [1] = { type = "int", data = "crime type hash" },
            [2] = { type = "int", data = "criminal entity id" },
        }
    },
    -----------------------------------------------------------


    [`EVENT_CARRIABLE_VEHICLE_STOW_COMPLETE`] = {
        name = "EVENT_CARRIABLE_VEHICLE_STOW_COMPLETE",
        hash = "0x33AFBD35",
        datasize = 3,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "unknown" },
            [1] = { type = "int", data = "vehicle entity id" },
            [2] = { type = "int", data = "isItemToAddCancelled" },
        }
    },
    [`EVENT_CHALLENGE_GOAL_COMPLETE`] = {
        name = "EVENT_CHALLENGE_GOAL_COMPLETE",
        hash = "0x50870403",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "challenge goal hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/challenge_goals.lua))" }
        }
    },
    [`EVENT_CHALLENGE_GOAL_UPDATE`] = {
        name = "EVENT_CHALLENGE_GOAL_UPDATE",
        hash = "0x63813030",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "challenge goal hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/challenge_goals.lua))" }
        }
    },
    [`EVENT_PLAYER_MOUNT_WILD_HORSE`] = {
        name = "EVENT_PLAYER_MOUNT_WILD_HORSE",
        hash = "0x9BB8CEB6",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "wild horse ped id" }
        }
    },
    [`EVENT_CARRIABLE_UPDATE_CARRY_STATE`] = {
        name = "EVENT_CARRIABLE_UPDATE_CARRY_STATE",
        hash = "0x48061112",
        datasize = 5,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "CarriableEntityId" },
            [1] = { type = "int", data = "PerpitratorEntityId" },
            [2] = { type = "int", data = "CarrierEntityId" },
            [3] = { type = "int", data = "IsOnHorse" },
            [4] = { type = "int", data = "IsOnGround" },
        }
    },
    [`EVENT_UI_ITEM_INSPECT_ACTIONED`] = {
        name = "EVENT_UI_ITEM_INSPECT_ACTIONED",
        hash = "0xEB5D3754",
        datasize = 6,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "unknown" },
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown (??? FitsSlot hash)" },
            [5] = { type = "int", data = "unknown" },

        }
    },
    [`EVENT_PED_HAT_KNOCKED_OFF`] = {
        name = "EVENT_PED_HAT_KNOCKED_OFF",
        hash = "0x790E0287",
        datasize = 2,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "ped id" },
            [1] = { type = "int", data = "hat entity id" },
        }
    },
    [`EVENT_NETWORK_DAMAGE_ENTITY`] = {
        name = "EVENT_NETWORK_DAMAGE_ENTITY",
        hash = "0xB195FBBC",
        datasize = 32,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "damaged entity id" },
            [1] = { type = "int", data = "killer entity id" },
            [2] = { type = "float", data = "Damage" },
            [3] = { type = "int", data = "isVictimDestroyed" },
            [4] = { type = "int", data = "isVictimIncapacitated" },
            [5] = { type = "int", data = "WeaponUsed hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )" },
            [6] = { type = "int", data = "AmmoUsed hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/ammo_types.lua) )" },
            [7] = { type = "int", data = "InstigatedWeaponUsed" },
            [8] = { type = "float", data = "VictimSpeed" },
            [9] = { type = "float", data = "DamagerSpeed" },
            [10] = { type = "int", data = "IsResponsibleForCollision" },
            [11] = { type = "int", data = "IsHeadShot" },
            [12] = { type = "int", data = "IsWithMeleeWeapon" },
            [13] = { type = "int", data = "IsVictimExecuted" },
            [14] = { type = "int", data = "VictimBledOut" },
            [15] = { type = "int", data = "DamagerWasScopedIn" },
            [16] = { type = "int", data = "DamagerSpecialAbilityActive" },
            [17] = { type = "int", data = "VictimHogtied" },
            [18] = { type = "int", data = "VictimMounted" },
            [19] = { type = "int", data = "VictimInVehicle" },
            [20] = { type = "int", data = "VictimInCover" },
            [21] = { type = "int", data = "DamagerShotLastBullet" },
            [22] = { type = "int", data = "VictimKilledByStealth" },
            [23] = { type = "int", data = "VictimKilledByTakedown" },
            [24] = { type = "int", data = "VictimKnockedOut" },
            [25] = { type = "int", data = "isVictimTranquilized" },
            [26] = { type = "int", data = "VictimKilledByStandardMelee" },
            [27] = { type = "int", data = "VictimMissionEntity" },
            [28] = { type = "int", data = "VictimFleeing" },
            [29] = { type = "int", data = "VictimInCombat" },
            [30] = { type = "int", data = "unknown" },
            [31] = { type = "int", data = "IsSuicide" },

        }
    },
    [`EVENT_ENTITY_DAMAGED`] = {
        name = "EVENT_ENTITY_DAMAGED",
        hash = "0x18010D37",
        datasize = 9,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "damaged entity id" },
            [1] = { type = "int", data = "object (or ped id) that caused damage to the entity " },
            [2] = { type = "int", data = "weaponHash that damaged the entity ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )" },
            [3] = { type = "int", data = "ammo hash that damaged the entity ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/ammo_types.lua) )" },
            [4] = { type = "float", data = "damage amount" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "float", data = "entity coord x" },
            [7] = { type = "float", data = "entity coord y" },
            [8] = { type = "float", data = "entity coord z" },
        }
    },
    [`EVENT_NETWORK_POSSE_MEMBER_DISBANDED`] = {
        name = "EVENT_NETWORK_POSSE_MEMBER_DISBANDED",
        hash = "0x9B197E61",
        datasize = 23,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "posse id" },
            [1] = { type = "int", data = "unknown (??? posse name)" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "network gamer handle" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "unknown" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_NETWORK_PLAYER_LEFT_SCRIPT`] = {
        name = "EVENT_NETWORK_PLAYER_LEFT_SCRIPT",
        hash = "0xE5EC5018",
        datasize = 41,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "unknown (??? leaving PlayerName)" },
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown (??? Player id)" },
            [9] = { type = "int", data = "unknown" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "NumThreads" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "unknown" },
            [23] = { type = "int", data = "unknown" },
            [24] = { type = "int", data = "unknown" },
            [25] = { type = "int", data = "unknown" },
            [26] = { type = "int", data = "unknown" },
            [27] = { type = "int", data = "unknown" },
            [28] = { type = "int", data = "unknown" },
            [29] = { type = "int", data = "unknown" },
            [30] = { type = "int", data = "unknown" },
            [31] = { type = "int", data = "unknown" },
            [32] = { type = "int", data = "unknown" },
            [33] = { type = "int", data = "unknown" },
            [34] = { type = "int", data = "unknown" },
            [35] = { type = "int", data = "unknown" },
            [36] = { type = "int", data = "unknown" },
            [37] = { type = "int", data = "unknown" },
            [38] = { type = "int", data = "unknown" },
            [39] = { type = "int", data = "unknown" },
            [40] = { type = "int", data = "participant id" },
        }
    },
    [`EVENT_NETWORK_POSSE_JOINED`] = {
        name = "EVENT_NETWORK_POSSE_JOINED",
        hash = "0x4B982DFD",
        datasize = 2,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "isSuccess" },
            [1] = { type = "int", data = "posse id" },
        }
    },
    [`EVENT_HELP_TEXT_REQUEST`] = {
        name = "EVENT_HELP_TEXT_REQUEST",
        hash = "0xC25C9274",
        datasize = 4,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "unknown" },
            [1] = { type = "int", data = "tutorial flag hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/tutorial_flags.lua) )" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "inventory item hash" },
        }
    },
    [`EVENT_HITCH_ANIMAL`] = {
        name = "EVENT_HITCH_ANIMAL",
        hash = "0x9D8ECCC2",
        datasize = 4,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "rider ped id" },
            [1] = { type = "int", data = "mount ped id" },
            [2] = { type = "int", data = "isAnimalHitched" },
            [3] = { type = "int", data = "hitching type id" },
        }
    },
    [`EVENT_NETWORK_LOOT_CLAIMED`] = {
        name = "EVENT_NETWORK_LOOT_CLAIMED",
        hash = "0x08679A08",
        datasize = 9,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "request id" },
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown (??? result code  [list](#award-claimed-result-codes) )" },
            [5] = { type = "int", data = "unknown (??? loot entity model hash)" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "status" },
            [8] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_NETWORK_POSSE_DISBANDED`] = {
        name = "EVENT_NETWORK_POSSE_DISBANDED",
        hash = "0xE6E2A693",
        datasize = 2,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "isSuccess" },
            [1] = { type = "int", data = "posse id" },

        }
    },
    [`EVENT_PED_WHISTLE`] = {
        name = "EVENT_PED_WHISTLE",
        hash = "0x4F1BB748",
        datasize = 2,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "whistler ped id" },
            [1] = { type = "int", data = "whistle type ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/aud_ped_whistle_types.lua))" },

        }
    },
    [`EVENT_NETWORK_PLAYER_JOIN_SCRIPT`] = {
        name = "EVENT_NETWORK_PLAYER_JOIN_SCRIPT",
        hash = "0x88B9994B",
        datasize = 41,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "unknown (??? joining PlayerName)" },
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown (??? Player id)" },
            [9] = { type = "int", data = "unknown" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "NumThreads" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "unknown" },
            [23] = { type = "int", data = "unknown" },
            [24] = { type = "int", data = "unknown" },
            [25] = { type = "int", data = "unknown" },
            [26] = { type = "int", data = "unknown" },
            [27] = { type = "int", data = "unknown" },
            [28] = { type = "int", data = "unknown" },
            [29] = { type = "int", data = "unknown" },
            [30] = { type = "int", data = "unknown" },
            [31] = { type = "int", data = "unknown" },
            [32] = { type = "int", data = "unknown" },
            [33] = { type = "int", data = "unknown" },
            [34] = { type = "int", data = "unknown" },
            [35] = { type = "int", data = "unknown" },
            [36] = { type = "int", data = "unknown" },
            [37] = { type = "int", data = "unknown" },
            [38] = { type = "int", data = "unknown" },
            [39] = { type = "int", data = "unknown" },
            [40] = { type = "int", data = "participant id" },
        }
    },

    [`EVENT_ITEM_PROMPT_INFO_REQUEST`] = {
        name = "EVENT_ITEM_PROMPT_INFO_REQUEST",
        hash = "0x7D1EF05A",
        datasize = 2,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "inventory item hash" },
            [1] = { type = "int", data = "entity id, requesting prompt info" },

        }
    },
    [`EVENT_PICKUP_CARRIABLE`] = {
        name = "EVENT_PICKUP_CARRIABLE",
        hash = "0xD7092502",
        datasize = 4,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "carrier ped id" },
            [1] = { type = "int", data = "carriable entity id" },
            [2] = { type = "int", data = "isPickupDoneFromParent" },
            [3] = { type = "int", data = "carrier mount ped id (parent id)" },
        }
    },
    [`EVENT_NETWORK_PROJECTILE_NO_DAMAGE_IMPACT`] = {
        name = "EVENT_NETWORK_PROJECTILE_NO_DAMAGE_IMPACT",
        hash = "0x7AAC9471",
        datasize = 2,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "ped id" },
            [1] = { type = "int", data = "AmmoUsed hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/ammo_types.lua))" },
        }
    },
    [`EVENT_NETWORK_POSSE_LEFT`] = {
        name = "EVENT_NETWORK_POSSE_LEFT",
        hash = "0xEDA331CC",
        datasize = 1,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "posse id" },
        }
    },
    [`EVENT_VEHICLE_DESTROYED`] = {
        name = "EVENT_VEHICLE_DESTROYED",
        hash = "0xB69B22C7",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "unknown (??? destroyed vehicle id)" },
        }
    },
    [`EVENT_NETWORK_PED_HAT_SHOT_OFF`] = {
        name = "EVENT_NETWORK_PED_HAT_SHOT_OFF",
        hash = "0x5006F91B",
        datasize = 3,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "VictimEntityId" },
            [1] = { type = "int", data = "DamagerEntityId" },
            [2] = { type = "int", data = "UsedWeapon hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua))" },
        }
    },
    [`EVENT_LOOT_VALIDATION_FAIL`] = {
        name = "EVENT_LOOT_VALIDATION_FAIL",
        hash = "0xA608435E",
        datasize = 2,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "fail reason id ( [list](#event_loot_validation_fail-fail-reason-ids) )" },
            [1] = { type = "int", data = "looted_entity" },
        }
    },
    [`EVENT_NETWORK_POSSE_MEMBER_LEFT`] = {
        name = "EVENT_NETWORK_POSSE_MEMBER_LEFT",
        hash = "0x3E7223EA",
        datasize = 23,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "posse id" },
            [1] = { type = "int", data = "unknown (??? posse name)" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "network gamer handle" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "unknown" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_NETWORK_POSSE_MEMBER_JOINED`] = {
        name = "EVENT_NETWORK_POSSE_MEMBER_JOINED",
        hash = "0x6D1F9D8B",
        datasize = 23,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "posse id" },
            [1] = { type = "int", data = "unknown (??? posse name)" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "network gamer handle" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "unknown" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "unknown" },

        }
    },
    [`EVENT_NETWORK_SESSION_MERGE_START`] = {
        name = "EVENT_NETWORK_SESSION_MERGE_START",
        hash = "0xCCDFACF7",
        datasize = 1,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "session message id ( [list](#event_network_session_merge_start-message-ids))" },
        }
    },
    [`EVENT_NETWORK_PLAYER_COLLECTED_PICKUP`] = {
        name = "EVENT_NETWORK_PLAYER_COLLECTED_PICKUP",
        hash = "0xE4EE4E45",
        datasize = 8,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "collected entity id" },
            [1] = { type = "int", data = "collector player id" },
            [2] = { type = "int", data = "pickup type hash  ( [list](https://github.com/femga/rdr3_discoveries/blob/master/objects/pickup_list.lua) )" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "pickup entity model hash  ( [list](https://github.com/femga/rdr3_discoveries/blob/master/objects/object_list.lua) )" },
            [5] = { type = "int", data = "pickup ammo amount" },
            [6] = { type = "int", data = "pickup ammo type hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/ammo_types.lua) )" },
            [7] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_UI_QUICK_ITEM_USED`] = {
        name = "EVENT_UI_QUICK_ITEM_USED",
        hash = "0xB47644FA",
        datasize = 6,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "unknown" },
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown (??? FitsSlot hash)" },
            [5] = { type = "int", data = "entity id, item was used for" },

        }
    },
    [`EVENT_PLAYER_HAT_KNOCKED_OFF`] = {
        name = "EVENT_PLAYER_HAT_KNOCKED_OFF",
        hash = "0xB34C8368",
        datasize = 5,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "player ped id" },
            [1] = { type = "int", data = "ped id who threw off player hat" },
            [2] = { type = "int", data = "hat entity id" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_PLAYER_HORSE_AGITATED_BY_ANIMAL`] = {
        name = "EVENT_PLAYER_HORSE_AGITATED_BY_ANIMAL",
        hash = "0x62AE6A25",
        datasize = 4,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "horse ped id" },
            [1] = { type = "int", data = "agitated animal" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_NETWORK_PERMISSION_CHECK_RESULT`] = {
        name = "EVENT_NETWORK_PERMISSION_CHECK_RESULT",
        hash = "0xA693E56E",
        datasize = 2,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "unknown (??? PermissionsRequestID)" },
            [1] = { type = "int", data = "unknown (??? check result)" },
        }
    },
    [`EVENT_NETWORK_LASSO_DETACH`] = {
        name = "EVENT_NETWORK_LASSO_DETACH",
        hash = "0x81C6F372",
        datasize = 2,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "VictimEntityId" },
            [1] = { type = "int", data = "PerpitratorEntityId" },

        }
    },
    [`EVENT_PLACE_CARRIABLE_ONTO_PARENT`] = {
        name = "EVENT_PLACE_CARRIABLE_ONTO_PARENT",
        hash = "0x4086BF1A",
        datasize = 6,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "perpitrator entity id" },
            [1] = { type = "int", data = "carriable entity id" },
            [2] = { type = "int", data = "carrier id(parent id)" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "isCarriedEntityAPelt" },
            [5] = { type = "int", data = "inventory item hash" },
        }
    },
    -- seems to fire when killing annesburg guards with crime_assault as type
    [`EVENT_CRIME_CONFIRMED`] = {
        name = "EVENT_CRIME_CONFIRMED",
        hash = "0x72B20426",
        datasize = 3,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "crime type hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/crime_types.lua) )" },
            [1] = { type = "int", data = "criminal ped id" },
            [2] = { type = "int", data = "witness" },

        }
    },
    [`EVENT_PED_ANIMAL_INTERACTION`] = {
        name = "EVENT_PED_ANIMAL_INTERACTION",
        hash = "0xB5B9BAB4",
        datasize = 3,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "ped id" },
            [1] = { type = "int", data = "animal ped id" },
            [2] = { type = "int", data = "interaction type hash" },
        }
    },
    [`EVENT_PED_CREATED`] = {
        name = "EVENT_PED_CREATED",
        hash = "0x2BDD985F",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "ped id that was created" },
        }
    },
    [`EVENT_PED_DESTROYED`] = {
        name = "EVENT_PED_DESTROYED",
        hash = "0x60F35A24",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "??? destroyed ped id" },
        }
    },
    [`EVENT_NETWORK_POSSE_MEMBER_KICKED`] = {
        name = "EVENT_NETWORK_POSSE_MEMBER_KICKED",
        hash = "0x0A8ADAD0",
        datasize = 23,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "posse id" },
            [1] = { type = "int", data = "unknown (??? posse name)" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "network gamer handle" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "unknown" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "unknown" },

        }
    },
    [`EVENT_NETWORK_POSSE_MEMBER_SET_ACTIVE`] = {
        name = "EVENT_NETWORK_POSSE_MEMBER_SET_ACTIVE",
        hash = "0xA1EA9FA3",
        datasize = 23,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "posse id" },
            [1] = { type = "int", data = "unknown (??? posse name)" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "network gamer handle" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "unknown" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "unknown" },

        }
    },
    [`EVENT_LOOT`] = {
        name = "EVENT_LOOT",
        hash = "0xA5E4EAF7",
        datasize = 36,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "nNumGivenRewards" },
            [1] = { type = "int", data = "nRewardHash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/loot_rewards.lua) )" },
            [2] = { type = "int", data = "inventory item hash" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "unknown" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "unknown" },
            [12] = { type = "int", data = "nNum" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "weaponhash( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )" },
            [23] = { type = "int", data = "unknown" },
            [24] = { type = "int", data = "unknown" },
            [25] = { type = "int", data = "unknown" },
            [26] = { type = "int", data = "LooterId" },
            [27] = { type = "int", data = "LootedId" },
            [28] = { type = "int", data = "Looted entity model" },
            [29] = { type = "int", data = "LootedCompositeHashid" },
            [30] = { type = "int", data = "unknown" },
            [31] = { type = "int", data = "unknown" },
            [32] = { type = "int", data = "unknown" },
            [33] = { type = "int", data = "unknown" },
            [34] = { type = "int", data = "unknown" },
            [35] = { type = "int", data = "unknown " },

        }
    },
    [`EVENT_PLAYER_ESCALATED_PED`] = {
        name = "EVENT_PLAYER_ESCALATED_PED",
        hash = "0x93B7032F",
        datasize = 2,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "player ped id" },
            [1] = { type = "int", data = "escalated ped id" },

        }
    },
    [`EVENT_NETWORK_VEHICLE_LOOTED`] = {
        name = "EVENT_NETWORK_VEHICLE_LOOTED",
        hash = "0xCB3F3CF3",
        datasize = 3,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "looter ped id" },
            [1] = { type = "int", data = "looted vehicle id" },
            [2] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_ENTITY_BROKEN`] = {
        name = "EVENT_ENTITY_BROKEN",
        hash = "0xED53F1A6",
        datasize = 9,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "broken entity id" },
            [1] = { type = "int", data = "unknown " },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "float", data = "unknown(??? damage amount)" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "float", data = "entity coord x" },
            [7] = { type = "float", data = "entity coord y" },
            [8] = { type = "float", data = "entity coord z" },
        }
    },
    [`EVENT_SCENARIO_ADD_PED`] = {
        name = "EVENT_SCENARIO_ADD_PED",
        hash = "0xFD5137A4",
        datasize = 2,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "iScriptUID" },
            [1] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_HORSE_BROKEN`] = {
        name = "EVENT_HORSE_BROKEN",
        hash = "0x0D078005",
        datasize = 3,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "rider ped id" },
            [1] = { type = "int", data = "broken horse ped id" },
            [2] = { type = "int", data = "HorseBrokenEventTypeId ( [list](#horse-broken-event-type-ids))" },
        }
    },
    [`EVENT_CHALLENGE_REWARD`] = {
        name = "EVENT_CHALLENGE_REWARD",
        hash = "0xDB3269D0",
        datasize = 3,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "challenge reward hash" },
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_NETWORK_PED_DISARMED`] = {
        name = "EVENT_NETWORK_PED_DISARMED",
        hash = "0x6AE2133B",
        datasize = 3,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "VictimEntityId" },
            [1] = { type = "int", data = "DamagerEntityId" },
            [2] = { type = "int", data = "UsedWeapon hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua))" },

        }
    },
    [`EVENT_NETWORK_GANG`] = {
        name = "EVENT_NETWORK_GANG",
        hash = "0xD954ECD1",
        datasize = 18,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "unknown (??? GangId)" },
            [1] = { type = "int", data = "GangEventType id  ( [list](#gangeventtype-ids) )" },
            [2] = { type = "int", data = "sender network GamerHandle" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "unknown" },
            [10] = { type = "int", data = "unknown (??? remote player name)" },
            [11] = { type = "int", data = "unknown" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_NETWORK_CREW_LEFT`] = {
        name = "EVENT_NETWORK_CREW_LEFT",
        hash = "0x4731D758",
        datasize = 2,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "left crew id" },
            [1] = { type = "int", data = "unknown" },

        }
    },
    [`EVENT_NETWORK_VEHICLE_UNDRIVABLE`] = {
        name = "EVENT_NETWORK_VEHICLE_UNDRIVABLE",
        hash = "0x6D3625B6",
        datasize = 3,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "vehicle entity id" },
            [1] = { type = "int", data = "Damager entity id" },
            [2] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_NETWORK_PLAYER_MISSED_SHOT`] = {
        name = "EVENT_NETWORK_PLAYER_MISSED_SHOT",
        hash = "0x60ED0108",
        datasize = 9,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "shooter id" },
            [1] = { type = "int", data = "UsedWeapon hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_NETWORK_PLAYER_JOIN_SESSION`] = {
        name = "EVENT_NETWORK_PLAYER_JOIN_SESSION",
        hash = "0xA7A83D00",
        datasize = 10,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "unknown (??? player name)" },
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "player id" },
            [9] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_NETWORK_CREW_RANK_CHANGE`] = {
        name = "EVENT_NETWORK_CREW_RANK_CHANGE",
        hash = "0xB203E1F6",
        datasize = 7,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "crew id" },
            [1] = { type = "int", data = "rank order" },
            [2] = { type = "int", data = "promotion" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_NETWORK_BULLET_IMPACTED_MULTIPLE_PEDS`] = {
        name = "EVENT_NETWORK_BULLET_IMPACTED_MULTIPLE_PEDS",
        hash = "0x7801F196",
        datasize = 4,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "shooter ped id" },
            [1] = { type = "int", data = "NumImpacted" },
            [2] = { type = "int", data = "NumKilled" },
            [3] = { type = "int", data = "NumIncapacitated" },
        }
    },
    [`EVENT_ENTITY_HOGTIED`] = {
        name = "EVENT_ENTITY_HOGTIED",
        hash = "0x6AFC39AD",
        datasize = 3,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "hogtied entity id" },
            [1] = { type = "int", data = "hogtier ped id" },
            [2] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_NETWORK_PROJECTILE_ATTACHED`] = {
        name = "EVENT_NETWORK_PROJECTILE_ATTACHED",
        hash = "0x86A33F16",
        datasize = 6,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "damager entity id" },
            [1] = { type = "int", data = "victim entity id" },
            [2] = { type = "float", data = "projectile hit coord x" },
            [3] = { type = "float", data = "projectile hit coord y" },
            [4] = { type = "float", data = "projectile hit coord z" },
            [5] = { type = "int", data = "weaponhash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua))" },
        }
    },
    [`EVENT_NETWORK_HUB_UPDATE`] = {
        name = "EVENT_NETWORK_HUB_UPDATE",
        hash = "0x1B07E312",
        datasize = 1,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "updateHash" },
        }
    },
    [`EVENT_NETWORK_CASHINVENTORY_TRANSACTION`] = {
        name = "EVENT_NETWORK_CASHINVENTORY_TRANSACTION",
        hash = "0x67315C9F",
        datasize = 6,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "transaction id" },
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "failed" },
            [3] = { type = "int", data = "result code" },
            [4] = { type = "int", data = "items amount" },
            [5] = { type = "int", data = "action hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/cashinventory_transition_actions.lua))" },
        }
    },
    [`EVENT_LOOT_PLANT_START`] = {
        name = "EVENT_LOOT_PLANT_START",
        hash = "0x61C22F58",
        datasize = 36,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "NumGivenRewards" },
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "unknown" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "unknown" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "unknown" },
            [23] = { type = "int", data = "OriginalTargetSpawnLocation" },
            [24] = { type = "int", data = "unknown" },
            [25] = { type = "int", data = "unknown" },
            [26] = { type = "int", data = "LooterId" },
            [27] = { type = "int", data = "LootedId" },
            [28] = { type = "int", data = "unknown" },
            [29] = { type = "int", data = "LootedCompositeHashId" },
            [30] = { type = "int", data = "LootedPedStatHashName" },
            [31] = { type = "int", data = "LootedEntityWasAnimal" },
            [32] = { type = "int", data = "LootedEntityWasBird" },
            [33] = { type = "int", data = "unknown" },
            [34] = { type = "int", data = "LootingBehaviorType" },
            [35] = { type = "int", data = "unknown " },

        }
    },
    [`EVENT_NETWORK_PLAYER_LEFT_SESSION`] = {
        name = "EVENT_NETWORK_PLAYER_LEFT_SESSION",
        hash = "0x652D7388",
        datasize = 10,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "unknown (??? player name)" },
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "player id" },
            [9] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_SHOT_FIRED_WHIZZED_BY`] = {
        name = "EVENT_SHOT_FIRED_WHIZZED_BY",
        hash = "0xBE4F7341",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "entity id that was shot" },
        }
    },
    [`EVENT_TRIGGERED_ANIMAL_WRITHE`] = {
        name = "EVENT_TRIGGERED_ANIMAL_WRITHE",
        hash = "0x6A5A17E5",
        datasize = 2,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "animal ped id" },
            [1] = { type = "int", data = "ped id who damaged animal" },
        }
    },
    [`EVENT_VEHICLE_CREATED`] = {
        name = "EVENT_VEHICLE_CREATED",
        hash = "0x90F48BEB",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "vehicle id that was created" },
        }
    },
    [`EVENT_NETWORK_POSSE_DATA_CHANGED`] = {
        name = "EVENT_NETWORK_POSSE_DATA_CHANGED",
        hash = "0x18C53154",
        datasize = 2,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "unknown" },
            [1] = { type = "int", data = "unknown" },

        }
    },
    [`EVENT_REVIVE_ENTITY`] = {
        name = "EVENT_REVIVE_ENTITY",
        hash = "0x5C9AF519",
        datasize = 3,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "VictimEntityId" },
            [1] = { type = "int", data = "reviver ped id" },
            [2] = { type = "int", data = "used inventory item hash" },
        }
    },
    [`EVENT_NETWORK_CREW_DISBANDED`] = {
        name = "EVENT_NETWORK_CREW_DISBANDED",
        hash = "0x7E0A062E",
        datasize = 2,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "isDisbandingSuccessful" },
            [1] = { type = "int", data = "unknown" },

        }
    },
    [`EVENT_PLAYER_COLLECTED_AMBIENT_PICKUP`] = {
        name = "EVENT_PLAYER_COLLECTED_AMBIENT_PICKUP",
        hash = "0xF5628A90",
        datasize = 8,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "pickup name hash" },
            [1] = { type = "int", data = "unknown (??? pickup entity id)" },
            [2] = { type = "int", data = "player id" },
            [3] = { type = "int", data = "pickup model hash" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "collected inventory item quantity" },
            [7] = { type = "int", data = "inventory item hash" },

        }
    },
    [`EVENT_NETWORK_LASSO_ATTACH`] = {
        name = "EVENT_NETWORK_LASSO_ATTACH",
        hash = "0xFA3003C2",
        datasize = 2,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "VictimEntityId" },
            [1] = { type = "int", data = "PerpitratorEntityId" },

        }
    },
    [`EVENT_NETWORK_PLAYER_COLLECTED_PORTABLE_PICKUP`] = {
        name = "EVENT_NETWORK_PLAYER_COLLECTED_PORTABLE_PICKUP",
        hash = "0x4BF0B846",
        datasize = 3,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "collected pickup network id" },
            [1] = { type = "int", data = "player id" },
            [2] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_NETWORK_GANG_WAYPOINT_CHANGED`] = {
        name = "EVENT_NETWORK_GANG_WAYPOINT_CHANGED",
        hash = "0x2877E9E5",
        datasize = 3,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "Gang Waypoint Changing type id ( [list](#gang-waypoint-changing-type-ids) )" },
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_CARRIABLE_PROMPT_INFO_REQUEST`] = {
        name = "EVENT_CARRIABLE_PROMPT_INFO_REQUEST",
        hash = "0xDD49DDE5",
        datasize = 6,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "CarriableEntityId" },
            [1] = { type = "int", data = "carry action id ( [list](#carry-action-ids) )" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "vehicle entity id (parent id)" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_NETWORK_POSSE_EX_INACTIVE_DISBANDED`] = {
        name = "EVENT_NETWORK_POSSE_EX_INACTIVE_DISBANDED",
        hash = "0x2F900E05",
        datasize = 10,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "unknown" },
            [1] = { type = "int", data = "unknown (??? posse name)" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "unknown" },

        }
    },
    [`EVENT_NETWORK_REVIVED_ENTITY`] = {
        name = "EVENT_NETWORK_REVIVED_ENTITY",
        hash = "0xBA291CB5",
        datasize = 2,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "Victim entity id" },
            [1] = { type = "int", data = "Reviver entity id" },

        }
    },
    [`EVENT_ENTITY_DESTROYED`] = {
        name = "EVENT_ENTITY_DESTROYED",
        hash = "0x7FDA4C5A",
        datasize = 9,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "destroyed entity id" },
            [1] = { type = "int", data = "object (or ped id) that caused damage to the entity" },
            [2] = { type = "int", data = "weaponHash that damaged the entity  ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )" },
            [3] = { type = "int", data = "ammo hash that damaged the entity ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/ammo_types.lua) )" },
            [4] = { type = "float", data = "damage amount" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "float", data = "entity coord x" },
            [7] = { type = "float", data = "entity coord y" },
            [8] = { type = "float", data = "entity coord z" },

        }
    },
    [`EVENT_ENTITY_DISARMED`] = {
        name = "EVENT_ENTITY_DISARMED",
        hash = "0x42617404",
        datasize = 4,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "victim entity id" },
            [1] = { type = "int", data = "damager entity id" },
            [2] = { type = "int", data = "weaponHash that damaged the entity  ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )" },
            [3] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_CARRIABLE_VEHICLE_STOW_START`] = {
        name = "EVENT_CARRIABLE_VEHICLE_STOW_START",
        hash = "0xB5FAD423",
        datasize = 5,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "unknown" },
            [1] = { type = "int", data = "carriable entity id" },
            [2] = { type = "int", data = "vehicle entity id" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_NETWORK_HOGTIE_END`] = {
        name = "EVENT_NETWORK_HOGTIE_END",
        hash = "0xC931881D",
        datasize = 2,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "VictimEntityId" },
            [1] = { type = "int", data = "PerpitratorEntityId" },
        }
    },
    [`EVENT_NETWORK_SESSION_MERGE_END`] = {
        name = "EVENT_NETWORK_SESSION_MERGE_END",
        hash = "0x81A6657A",
        datasize = 1,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "session message id ( [list](#event_network_session_merge_end-message-ids))" },
        }
    },
    [`EVENT_SHOT_FIRED_BULLET_IMPACT`] = {
        name = "EVENT_SHOT_FIRED_BULLET_IMPACT",
        hash = "0xA62B9EBA",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "entity id that bullet hit" },
        }
    },
    [`EVENT_NETWORK_PLAYER_DROPPED_PORTABLE_PICKUP`] = {
        name = "EVENT_NETWORK_PLAYER_DROPPED_PORTABLE_PICKUP",
        hash = "0xCDB2BA3C",
        datasize = 3,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "collected pickup network id" },
            [1] = { type = "int", data = "player id" },
            [2] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_INVENTORY_ITEM_REMOVED`] = {
        name = "EVENT_INVENTORY_ITEM_REMOVED",
        hash = "0x59B9C9D6",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "inventory item hash" },
        }
    },
    [`EVENT_NETWORK_POSSE_LEADER_SET_ACTIVE`] = {
        name = "EVENT_NETWORK_POSSE_LEADER_SET_ACTIVE",
        hash = "0x01608EBF",
        datasize = 23,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "posse id" },
            [1] = { type = "int", data = "unknown (??? posse name)" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "network gamer handle" },
            [10] = { type = "int", data = "unknown" },
            [11] = { type = "int", data = "unknown" },
            [12] = { type = "int", data = "unknown" },
            [13] = { type = "int", data = "unknown" },
            [14] = { type = "int", data = "unknown" },
            [15] = { type = "int", data = "unknown" },
            [16] = { type = "int", data = "unknown" },
            [17] = { type = "int", data = "unknown" },
            [18] = { type = "int", data = "unknown" },
            [19] = { type = "int", data = "unknown" },
            [20] = { type = "int", data = "unknown" },
            [21] = { type = "int", data = "unknown" },
            [22] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_BUCKED_OFF`] = {
        name = "EVENT_BUCKED_OFF",
        hash = "0x54772845",
        datasize = 3,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "rider id" },
            [1] = { type = 'int', data = "mount id" },
            [2] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_NETWORK_MINIGAME_REQUEST_COMPLETE`] = {
        name = "EVENT_NETWORK_MINIGAME_REQUEST_COMPLETE",
        hash = "0xBCDF4734",
        datasize = 6,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "seatRequestData0" },
            [1] = { type = "int", data = "seatRequestData1" },
            [2] = { type = "int", data = "seatRequestData2" },
            [3] = { type = "int", data = "seatRequestData3" },
            [4] = { type = "int", data = "isSuccess" },
            [5] = { type = "int", data = "MinigameErrorCodeHash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/AI/EVENTS/minigame_error_codes.lua ))" },

        }
    },
    [`EVENT_HOGTIED_ENTITY_PICKED_UP`] = {
        name = "EVENT_HOGTIED_ENTITY_PICKED_UP",
        hash = "0x15101E7B",
        datasize = 2,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "hogtied ped id" },
            [1] = { type = "int", data = "carrier ped id" },
        }
    },
    [`EVENT_PLAYER_HAT_EQUIPPED`] = {
        name = "EVENT_PLAYER_HAT_EQUIPPED",
        hash = "0xE9FEE6C5",
        datasize = 10,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "player ped id" },
            [1] = { type = "int", data = "hat entity id" },
            [2] = { type = "int", data = "hat drawble hash" },
            [3] = { type = "int", data = "hat albedo hash" },
            [4] = { type = "int", data = "hat normal hash" },
            [5] = { type = "int", data = "hat material hash" },
            [6] = { type = "int", data = "hat palette hash" },
            [7] = { type = "int", data = "hat tint1" },
            [8] = { type = "int", data = "hat tint2" },
            [9] = { type = "int", data = "hat tint3" },
        }
    },
    -- fires after killing cops
    [`EVENT_NETWORK_BOUNTY_REQUEST_COMPLETE`] = {
        name = "EVENT_NETWORK_BOUNTY_REQUEST_COMPLETE",
        hash = "0x64FA8E3A",
        datasize = 7,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "unknown (??? request id)" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "Result code" },
            [5] = { type = "int", data = "Total Value" },
            [6] = { type = "int", data = "Pay Off Value" },

        }
    },
    [`EVENT_NETWORK_CREW_CREATION`] = {
        name = "EVENT_NETWORK_CREW_CREATION",
        hash = "0x499AE7E3",
        datasize = 10,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "isCreationSuccessful" },
            [1] = { type = "int", data = "crew id" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "unknown" },

        }
    },
    [`EVENT_NETWORK_CREW_INVITE_RECEIVED`] = {
        name = "EVENT_NETWORK_CREW_INVITE_RECEIVED",
        hash = "0x3D51F81E",
        datasize = 11,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "id" },
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "unknown" },
            [10] = { type = "int", data = "hasMessage" },

        }
    },
    [`EVENT_DAILY_CHALLENGE_STREAK_COMPLETED`] = {
        name = "EVENT_DAILY_CHALLENGE_STREAK_COMPLETED",
        hash = "0xBC9A051D",
        datasize = 1,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "unknown (???isDailyChallengeStreakCompleted)" },
        }
    },
    [`EVENT_NETWORK_CREW_KICKED`] = {
        name = "EVENT_NETWORK_CREW_KICKED",
        hash = "0x2CE2329B",
        datasize = 2,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "crew id" },
            [1] = { type = "int", data = "primary" },
        }
    },
    [`EVENT_INVENTORY_ITEM_PICKED_UP`] = {
        name = "EVENT_INVENTORY_ITEM_PICKED_UP",
        hash = "0x40702B55",
        datasize = 5,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "inventory item hash" },
            [1] = { type = "int", data = "picked up entity model " },
            [2] = { type = "int", data = "isItemWasUsed" },
            [3] = { type = "int", data = "isItemWasBought" },
            [4] = { type = "int", data = "picked up entity id" },

        }
    },
    [`EVENT_PLAYER_PROMPT_TRIGGERED`] = {
        name = "EVENT_PLAYER_PROMPT_TRIGGERED",
        hash = "0x52AE9189",
        datasize = 10,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "prompt type id ( [list](#prompt-type-ids) )" },
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "target entity id" },
            [3] = { type = "int", data = "unknown (??? discovered inventory item)" },
            [4] = { type = "float", data = "player ped coord x" },
            [5] = { type = "float", data = "player ped coord y" },
            [6] = { type = "float", data = "player ped coord z" },
            [7] = { type = "int", data = "discoverable entity type id ( [list](#discoverable-entity-type-ids) )" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "kit_emote_action hash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/animations/kit_emotes_list.lua))" },

        }
    },
    [`EVENT_MISS_INTENDED_TARGET`] = {
        name = "EVENT_MISS_INTENDED_TARGET",
        hash = "0xDE1126F3",
        datasize = 3,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "shooter ped id" },
            [1] = { type = "int", data = "entity id that was shot" },
            [2] = { type = "int", data = "weaponhash ( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua))" },

        }
    },
    [`EVENT_NETWORK_POSSE_CREATED`] = {
        name = "EVENT_NETWORK_POSSE_CREATED",
        hash = "0xF22CF2CB",
        datasize = 10,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "isSuccess" },
            [1] = { type = "int", data = "posse id" },
            [2] = { type = "int", data = "unknown (??? posse name)" },
            [3] = { type = "int", data = "unknown" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "unknown" },
            [9] = { type = "int", data = "unknown" },

        }
    },
    [`EVENT_OBJECT_INTERACTION`] = {
        name = "EVENT_OBJECT_INTERACTION",
        hash = "0x98D68310",
        datasize = 10,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "ped id" },
            [1] = { type = "int", data = "interaction entity id " },
            [2] = { type = "int", data = "inventory item hash" },
            [3] = { type = "int", data = "inventory item quantity" },
            [4] = { type = "int", data = "unknown" },
            [5] = { type = "int", data = "unknown" },
            [6] = { type = "int", data = "unknown" },
            [7] = { type = "int", data = "unknown" },
            [8] = { type = "int", data = "scenario point id" },
            [9] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_SCENARIO_REMOVE_PED`] = {
        name = "EVENT_SCENARIO_REMOVE_PED",
        hash = "0xE4C3E578",
        datasize = 2,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "iScriptUID" },
            [1] = { type = "int", data = "unknown" },

        }
    },
    [`EVENT_HEADSHOT_BLOCKED_BY_HAT`] = {
        name = "EVENT_HEADSHOT_BLOCKED_BY_HAT",
        hash = "0x4578A51D",
        datasize = 2,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "Victim entity id" },
            [1] = { type = "int", data = "Inflictor entity id" },
        }
    },
    [`EVENT_MOUNT_OVERSPURRED`] = {
        name = "EVENT_MOUNT_OVERSPURRED",
        hash = "0x61A674E4",
        datasize = 6,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "rider id" },
            [1] = { type = "int", data = "mount id" },
            [2] = { type = "float", data = "unknown (??? horse rage amount)" },
            [3] = { type = "int", data = "the number of times the horse has overspurred" },
            [4] = { type = "int", data = "maximum number or times the horse can be overspurred before buck off rider" },
            [5] = { type = "int", data = "unknown" },

        }
    },
    [`EVENT_NETWORK_CREW_JOINED`] = {
        name = "EVENT_NETWORK_CREW_JOINED",
        hash = "0xB197C705",
        datasize = 2,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "unknown" },
            [1] = { type = "int", data = "unknown" },
        }
    },
    [`EVENT_CONTAINER_INTERACTION`] = {
        name = "EVENT_CONTAINER_INTERACTION",
        hash = "0x5096DA63",
        datasize = 4,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "searcher ped id" },
            [1] = { type = "int", data = "searched entity id" },
            [2] = { type = "int", data = "unknown" },
            [3] = { type = "int", data = "isContainerClosed after interaction" },
        }
    },
    -- for example shooting at oil lamps
    [`EVENT_ENTITY_EXPLOSION`] = {
        name = "EVENT_ENTITY_EXPLOSION",
        hash = "0xF79F5B8B",
        datasize = 6,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "ped id who did explosion" },
            [1] = { type = "int", data = "unknown" },
            [2] = { type = "int", data = "weaponhash( [list](https://github.com/femga/rdr3_discoveries/blob/master/weapons/weapons.lua) )" },
            [3] = { type = "float", data = "explosion coord x" },
            [4] = { type = "float", data = "explosion coord y" },
            [5] = { type = "float", data = "explosion coord z" },
        }
    },
    [`EVENT_NETWORK_HOGTIE_BEGIN`] = {
        name = "EVENT_NETWORK_HOGTIE_BEGIN",
        hash = "0xC07A32C7",
        datasize = 2,
        group = 1,
        dataelements = {
            [0] = { type = "int", data = "VictimEntityId" },
            [1] = { type = "int", data = "PerpitratorEntityId" },
        }
    },
    [`EVENT_CALM_PED`] = {
        name = "EVENT_CALM_PED",
        hash = "0x89AB08C3",
        datasize = 4,
        group = 0,
        dataelements = {
            [0] = { type = "int", data = "calmer ped id" },
            [1] = { type = "int", data = "mount ped id" },
            [2] = { type = "int", data = "CalmTypeId ( [list](#calm-type-ids) )" },
            [3] = { type = "int", data = "isFullyCalmed" },

        }
    },

    -- no data size  events? most of these are not triggered by default ?
    [`EVENT_ACQUAINTANCE_PED_DISLIKE`] = {
        name = "EVENT_ACQUAINTANCE_PED_DISLIKE",
        hash = "0x89F02B9A",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ACQUAINTANCE_PED_HATE`] = {
        name = "EVENT_ACQUAINTANCE_PED_HATE",
        hash = "0x19FBE63B",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ACQUAINTANCE_PED_LIKE`] = {
        name = "EVENT_ACQUAINTANCE_PED_LIKE",
        hash = "0x95FCABC8",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ACQUAINTANCE_PED_RESPECT`] = {
        name = "EVENT_ACQUAINTANCE_PED_RESPECT",
        hash = "0xE7BDBBA5",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ACQUAINTANCE_PED_WANTED`] = {
        name = "EVENT_ACQUAINTANCE_PED_WANTED",
        hash = "0x1E739F07",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ACQUAINTANCE_PED_DISGUISE`] = {
        name = "EVENT_ACQUAINTANCE_PED_DISGUISE",
        hash = "0x6761671F",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ACQUAINTANCE_PED_DEAD`] = {
        name = "EVENT_ACQUAINTANCE_PED_DEAD",
        hash = "0xF4438C35",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ACQUAINTANCE_PED_THIEF`] = {
        name = "EVENT_ACQUAINTANCE_PED_THIEF",
        hash = "0x7A39BCD6",
        datasize = 0,
        group = 0,
    },
    [`EVENT_AMBIENT_THREAT_LEVEL_MAXED`] = {
        name = "EVENT_AMBIENT_THREAT_LEVEL_MAXED",
        hash = "0x6FB8CE47",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ANIMAL_DETECTED_PREY`] = {
        name = "EVENT_ANIMAL_DETECTED_PREY",
        hash = "0xFDFCDD8C",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ANIMAL_DETECTED_PREDATOR`] = {
        name = "EVENT_ANIMAL_DETECTED_PREDATOR",
        hash = "0x5C1D9E3A",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ANIMAL_DETECTED_THREAT`] = {
        name = "EVENT_ANIMAL_DETECTED_THREAT",
        hash = "0x55278F54",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ANIMAL_DETECTED_TRAIN`] = {
        name = "EVENT_ANIMAL_DETECTED_TRAIN",
        hash = "0x22107C24",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ANIMAL_PROVOKED`] = {
        name = "EVENT_ANIMAL_PROVOKED",
        hash = "0x7EF1D354",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PLAYER_IN_CLOSE_PROXIMITY_TO_HORSE`] = {
        name = "EVENT_PLAYER_IN_CLOSE_PROXIMITY_TO_HORSE",
        hash = "0x4E3837CD",
        datasize = 0,
        group = 0,
    },
    [`EVENT_COMMUNICATE_EVENT`] = {
        name = "EVENT_COMMUNICATE_EVENT",
        hash = "0x0C3BCD61",
        datasize = 0,
        group = 0,
    },
    [`EVENT_COP_CAR_BEING_STOLEN`] = {
        name = "EVENT_COP_CAR_BEING_STOLEN",
        hash = "0x5C49FE85",
        datasize = 0,
        group = 0,
    },
    [`EVENT_DAMAGE`] = {
        name = "EVENT_DAMAGE",
        hash = "0xC5AC88F7",
        datasize = 0,
        group = 0,
    },
    [`EVENT_DEAD_PED_FOUND`] = {
        name = "EVENT_DEAD_PED_FOUND",
        hash = "0x5EC44E23",
        datasize = 0,
        group = 0,
    },
    [`EVENT_DRAFT_ANIMAL_DETACHED_FROM_VEHICLE`] = {
        name = "EVENT_DRAFT_ANIMAL_DETACHED_FROM_VEHICLE",
        hash = "0xDCE400E2",
        datasize = 0,
        group = 0,
    },
    [`EVENT_DRAGGED_OUT_CAR`] = {
        name = "EVENT_DRAGGED_OUT_CAR",
        hash = "0x1A6C0A46",
        datasize = 0,
        group = 0,
    },
    [`EVENT_DUMMY_CONVERSION`] = {
        name = "EVENT_DUMMY_CONVERSION",
        hash = "0xEE54986F",
        datasize = 0,
        group = 0,
    },
    [`EVENT_EXPLOSION`] = {
        name = "EVENT_EXPLOSION",
        hash = "0x759AE323",
        datasize = 0,
        group = 0,
    },
    [`EVENT_EXPLOSION_HEARD`] = {
        name = "EVENT_EXPLOSION_HEARD",
        hash = "0xF7954F48",
        datasize = 0,
        group = 0,
    },
    [`EVENT_FIRE_NEARBY`] = {
        name = "EVENT_FIRE_NEARBY",
        hash = "0x528A4C04",
        datasize = 0,
        group = 0,
    },
    [`EVENT_FOOT_STEP_HEARD`] = {
        name = "EVENT_FOOT_STEP_HEARD",
        hash = "0xE5FB6FB3",
        datasize = 0,
        group = 0,
    },
    [`EVENT_GET_OUT_OF_WATER`] = {
        name = "EVENT_GET_OUT_OF_WATER",
        hash = "0x5D9A0C92",
        datasize = 0,
        group = 0,
    },
    [`EVENT_GIVE_PED_TASK`] = {
        name = "EVENT_GIVE_PED_TASK",
        hash = "0x74312E71",
        datasize = 0,
        group = 0,
    },
    [`EVENT_GUN_AIMED_AT`] = {
        name = "EVENT_GUN_AIMED_AT",
        hash = "0x096906A2",
        datasize = 0,
        group = 0,
    },
    [`EVENT_INJURED_CRY_FOR_HELP`] = {
        name = "EVENT_INJURED_CRY_FOR_HELP",
        hash = "0x2336D225",
        datasize = 0,
        group = 0,
    },
    [`EVENT_INJURED_RIDER`] = {
        name = "EVENT_INJURED_RIDER",
        hash = "0xF00A0D83",
        datasize = 0,
        group = 0,
    },
    [`EVENT_INJURED_DRIVER`] = {
        name = "EVENT_INJURED_DRIVER",
        hash = "0xE4545337",
        datasize = 0,
        group = 0,
    },
    [`EVENT_INJURED_OWNER`] = {
        name = "EVENT_INJURED_OWNER",
        hash = "0x1478EFD3",
        datasize = 0,
        group = 0,
    },
    [`EVENT_CRIME_CRY_FOR_HELP`] = {
        name = "EVENT_CRIME_CRY_FOR_HELP",
        hash = "0xA6A917B2",
        datasize = 0,
        group = 0,
    },
    [`EVENT_IN_AIR`] = {
        name = "EVENT_IN_AIR",
        hash = "0x33F4E093",
        datasize = 0,
        group = 0,
    },
    [`EVENT_IN_WATER`] = {
        name = "EVENT_IN_WATER",
        hash = "0x5BAEEBD0",
        datasize = 0,
        group = 0,
    },
    [`EVENT_INCAPACITATED`] = {
        name = "EVENT_INCAPACITATED",
        hash = "0x737BB735",
        datasize = 0,
        group = 0,
    },
    [`EVENT_KNOCKEDOUT`] = {
        name = "EVENT_KNOCKEDOUT",
        hash = "0xAAB956CC",
        datasize = 0,
        group = 0,
    },
    [`EVENT_LASSO_HIT`] = {
        name = "EVENT_LASSO_HIT",
        hash = "0xDC649C5F",
        datasize = 0,
        group = 0,
    },
    [`EVENT_LEADER_ENTERED_CAR_AS_DRIVER`] = {
        name = "EVENT_LEADER_ENTERED_CAR_AS_DRIVER",
        hash = "0xFEC2C77B",
        datasize = 0,
        group = 0,
    },
    [`EVENT_LEADER_ENTERED_COVER`] = {
        name = "EVENT_LEADER_ENTERED_COVER",
        hash = "0x9B29C3AA",
        datasize = 0,
        group = 0,
    },
    [`EVENT_LEADER_EXITED_CAR_AS_DRIVER`] = {
        name = "EVENT_LEADER_EXITED_CAR_AS_DRIVER",
        hash = "0xFBE1BD43",
        datasize = 0,
        group = 0,
    },
    [`EVENT_LEADER_HOLSTERED_WEAPON`] = {
        name = "EVENT_LEADER_HOLSTERED_WEAPON",
        hash = "0x498E3C84",
        datasize = 0,
        group = 0,
    },
    [`EVENT_LEADER_LEFT_COVER`] = {
        name = "EVENT_LEADER_LEFT_COVER",
        hash = "0x46E90A03",
        datasize = 0,
        group = 0,
    },
    [`EVENT_LEADER_UNHOLSTERED_WEAPON`] = {
        name = "EVENT_LEADER_UNHOLSTERED_WEAPON",
        hash = "0xE3B83A2C",
        datasize = 0,
        group = 0,
    },
    [`EVENT_MELEE_ACTION`] = {
        name = "EVENT_MELEE_ACTION",
        hash = "0x71B212BD",
        datasize = 0,
        group = 0,
    },
    [`EVENT_MOUNTED_COLLISION`] = {
        name = "EVENT_MOUNTED_COLLISION",
        hash = "0x3DAAE95B",
        datasize = 0,
        group = 0,
    },
    [`EVENT_MUST_LEAVE_BOAT`] = {
        name = "EVENT_MUST_LEAVE_BOAT",
        hash = "0x1EF1314F",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NEW_TASK`] = {
        name = "EVENT_NEW_TASK",
        hash = "0x3C92FE30",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NONE`] = {
        name = "EVENT_NONE",
        hash = "0x122B9F0B",
        datasize = 0,
        group = 0,
    },
    [`EVENT_OBJECT_COLLISION`] = {
        name = "EVENT_OBJECT_COLLISION",
        hash = "0xC941871B",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ON_FIRE`] = {
        name = "EVENT_ON_FIRE",
        hash = "0x090A2CD5",
        datasize = 0,
        group = 0,
    },
    [`EVENT_OPEN_DOOR`] = {
        name = "EVENT_OPEN_DOOR",
        hash = "0x71C874AC",
        datasize = 0,
        group = 0,
    },
    [`EVENT_SHOVE_PED`] = {
        name = "EVENT_SHOVE_PED",
        hash = "0x3BF92E25",
        datasize = 0,
        group = 0,
    },
    [`EVENT_VEHICLE_WAITING_ON_PED_TO_MOVE_AWAY`] = {
        name = "EVENT_VEHICLE_WAITING_ON_PED_TO_MOVE_AWAY",
        hash = "0xCA3065D3",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PED_COLLISION_WITH_PED`] = {
        name = "EVENT_PED_COLLISION_WITH_PED",
        hash = "0x8E8CAFE1",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PED_COLLISION_WITH_PLAYER`] = {
        name = "EVENT_PED_COLLISION_WITH_PLAYER",
        hash = "0xAB4087DA",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PED_ENTERED_MY_VEHICLE`] = {
        name = "EVENT_PED_ENTERED_MY_VEHICLE",
        hash = "0xCF6A7DF9",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PED_JACKING_MY_VEHICLE`] = {
        name = "EVENT_PED_JACKING_MY_VEHICLE",
        hash = "0x8F2C7B5D",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PLAYER_COLLISION_WITH_PED`] = {
        name = "EVENT_PLAYER_COLLISION_WITH_PED",
        hash = "0x12F893C4",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PLAYER_APPROACHED`] = {
        name = "EVENT_PLAYER_APPROACHED",
        hash = "0x880C5B5C",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PLAYER_ON_ROOFTOP`] = {
        name = "EVENT_PLAYER_ON_ROOFTOP",
        hash = "0x50A7F350",
        datasize = 0,
        group = 0,
    },
    [`EVENT_POTENTIAL_BE_WALKED_INTO`] = {
        name = "EVENT_POTENTIAL_BE_WALKED_INTO",
        hash = "0xC7894DF9",
        datasize = 0,
        group = 0,
    },
    [`EVENT_POTENTIAL_BLAST`] = {
        name = "EVENT_POTENTIAL_BLAST",
        hash = "0x26C4368E",
        datasize = 0,
        group = 0,
    },
    [`EVENT_POTENTIAL_GET_RUN_OVER`] = {
        name = "EVENT_POTENTIAL_GET_RUN_OVER",
        hash = "0xE36E5C71",
        datasize = 0,
        group = 0,
    },
    [`EVENT_POTENTIAL_WALK_INTO_FIRE`] = {
        name = "EVENT_POTENTIAL_WALK_INTO_FIRE",
        hash = "0xC619BE76",
        datasize = 0,
        group = 0,
    },
    [`EVENT_POTENTIAL_WALK_INTO_OBJECT`] = {
        name = "EVENT_POTENTIAL_WALK_INTO_OBJECT",
        hash = "0x76DF39D5",
        datasize = 0,
        group = 0,
    },
    [`EVENT_POTENTIAL_WALK_INTO_VEHICLE`] = {
        name = "EVENT_POTENTIAL_WALK_INTO_VEHICLE",
        hash = "0x7C53B7B0",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PROVIDING_COVER`] = {
        name = "EVENT_PROVIDING_COVER",
        hash = "0xEE65D5C7",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PULLED_FROM_MOUNT`] = {
        name = "EVENT_PULLED_FROM_MOUNT",
        hash = "0x2AFDF363",
        datasize = 0,
        group = 0,
    },
    [`EVENT_RADIO_TARGET_POSITION`] = {
        name = "EVENT_RADIO_TARGET_POSITION",
        hash = "0x5C766D71",
        datasize = 0,
        group = 0,
    },
    [`EVENT_RESPONDED_TO_THREAT`] = {
        name = "EVENT_RESPONDED_TO_THREAT",
        hash = "0xCB32A96F",
        datasize = 0,
        group = 0,
    },
    [`EVENT_INCOMING_THREAT`] = {
        name = "EVENT_INCOMING_THREAT",
        hash = "0x40070D77",
        datasize = 0,
        group = 0,
    },
    [`EVENT_REVIVED`] = {
        name = "EVENT_REVIVED",
        hash = "0x8368EC21",
        datasize = 0,
        group = 0,
    },
    [`EVENT_SCRIPT_COMMAND`] = {
        name = "EVENT_SCRIPT_COMMAND",
        hash = "0x0F513B99",
        datasize = 0,
        group = 0,
    },
    [`EVENT_LASSO_WHIZZED_BY`] = {
        name = "EVENT_LASSO_WHIZZED_BY",
        hash = "0xB8D864EB",
        datasize = 0,
        group = 0,
    },
    [`EVENT_SHOT_FIRED`] = {
        name = "EVENT_SHOT_FIRED",
        hash = "0xDCF8FE39",
        datasize = 0,
        group = 0,
    },
    [`EVENT_POTENTIAL_CRIME`] = {
        name = "EVENT_POTENTIAL_CRIME",
        hash = "0xC3B89B1B",
        datasize = 0,
        group = 0,
    },
    [`EVENT_POTENTIAL_THREAT_APPROACHING`] = {
        name = "EVENT_POTENTIAL_THREAT_APPROACHING",
        hash = "0xCC3D4DA0",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ARMED_PED_APPROACHING`] = {
        name = "EVENT_ARMED_PED_APPROACHING",
        hash = "0x36BFB752",
        datasize = 0,
        group = 0,
    },
    [`EVENT_SHOT_FIRED_BASE`] = {
        name = "EVENT_SHOT_FIRED_BASE",
        hash = "0xC47973BD",
        datasize = 0,
        group = 0,
    },
    [`EVENT_FRIENDLY_AIMED_AT`] = {
        name = "EVENT_FRIENDLY_AIMED_AT",
        hash = "0xF2BDB4D3",
        datasize = 0,
        group = 0,
    },
    [`EVENT_SHOUT_TARGET_POSITION`] = {
        name = "EVENT_SHOUT_TARGET_POSITION",
        hash = "0xE4CBAC49",
        datasize = 0,
        group = 0,
    },
    [`EVENT_STUCK_IN_AIR`] = {
        name = "EVENT_STUCK_IN_AIR",
        hash = "0xD8A57B9E",
        datasize = 0,
        group = 0,
    },
    [`EVENT_SUSPICIOUS_ACTIVITY`] = {
        name = "EVENT_SUSPICIOUS_ACTIVITY",
        hash = "0x16A4F041",
        datasize = 0,
        group = 0,
    },
    [`EVENT_UNIDENTIFIED_PED`] = {
        name = "EVENT_UNIDENTIFIED_PED",
        hash = "0x687E3ABA",
        datasize = 0,
        group = 0,
    },
    [`EVENT_VEHICLE_COLLISION`] = {
        name = "EVENT_VEHICLE_COLLISION",
        hash = "0x3F844EF0",
        datasize = 0,
        group = 0,
    },
    [`EVENT_VEHICLE_DAMAGE_WEAPON`] = {
        name = "EVENT_VEHICLE_DAMAGE_WEAPON",
        hash = "0xFAE8B02A",
        datasize = 0,
        group = 0,
    },
    [`EVENT_VEHICLE_ON_FIRE`] = {
        name = "EVENT_VEHICLE_ON_FIRE",
        hash = "0x935EEB9E",
        datasize = 0,
        group = 0,
    },
    [`EVENT_WHISTLING_HEARD`] = {
        name = "EVENT_WHISTLING_HEARD",
        hash = "0xC12C246E",
        datasize = 0,
        group = 0,
    },
    [`EVENT_DISTURBANCE`] = {
        name = "EVENT_DISTURBANCE",
        hash = "0x2DEA4697",
        datasize = 0,
        group = 0,
    },
    [`EVENT_WITHIN_GUN_COMBAT_AREA`] = {
        name = "EVENT_WITHIN_GUN_COMBAT_AREA",
        hash = "0x81076D3B",
        datasize = 0,
        group = 0,
    },
    [`EVENT_WITHIN_LAW_RESPONSE_AREA`] = {
        name = "EVENT_WITHIN_LAW_RESPONSE_AREA",
        hash = "0xC6BC3DB5",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PLAYER_UNABLE_TO_ENTER_VEHICLE`] = {
        name = "EVENT_PLAYER_UNABLE_TO_ENTER_VEHICLE",
        hash = "0xBB10C8A0",
        datasize = 0,
        group = 0,
    },
    [`EVENT_SHOT_FIRED_WHIZZED_BY_ENTITY`] = {
        name = "EVENT_SHOT_FIRED_WHIZZED_BY_ENTITY",
        hash = "0x8F3BEB7E",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PED_RAN_OVER_SCRIPT`] = {
        name = "EVENT_PED_RAN_OVER_SCRIPT",
        hash = "0xECCE2D62",
        datasize = 0,
        group = 0,
    },
    [`EVENT_CUT_FREE`] = {
        name = "EVENT_CUT_FREE",
        hash = "0x11A2B93C",
        datasize = 0,
        group = 0,
    },
    [`EVENT_HOGTIED`] = {
        name = "EVENT_HOGTIED",
        hash = "0x4B782E94",
        datasize = 0,
        group = 0,
    },
    [`EVENT_HORSE_STARTED_BREAKING`] = {
        name = "EVENT_HORSE_STARTED_BREAKING",
        hash = "0xE201BC38",
        datasize = 0,
        group = 0,
    },
    [`EVENT_BEING_LOOTED`] = {
        name = "EVENT_BEING_LOOTED",
        hash = "0xA277CDEE",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_SCRIPT_EVENT`] = {
        name = "EVENT_NETWORK_SCRIPT_EVENT",
        hash = "0xE1BAF876",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_NETWORK_BAIL`] = {
        name = "EVENT_NETWORK_NETWORK_BAIL",
        hash = "0x75CB3E0C",
        datasize = 0,
        group = 0,
    },
    [`EVENT_TEXT_MESSAGE_RECEIVED`] = {
        name = "EVENT_TEXT_MESSAGE_RECEIVED",
        hash = "0x2CC152B4",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_PED_LEFT_BEHIND`] = {
        name = "EVENT_NETWORK_PED_LEFT_BEHIND",
        hash = "0x6C26D9C7",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_EMAIL_RECEIVED`] = {
        name = "EVENT_NETWORK_EMAIL_RECEIVED",
        hash = "0xEBC756E7",
        datasize = 0,
        group = 0,
    },
    [`EVENT_UNIT_TEST_SCENARIO_EXIT`] = {
        name = "EVENT_UNIT_TEST_SCENARIO_EXIT",
        hash = "0xB6C5B407",
        datasize = 0,
        group = 0,
    },
    [`EVENT_HEARD_DEAD_PED_COLLISION`] = {
        name = "EVENT_HEARD_DEAD_PED_COLLISION",
        hash = "0x19C1F20F",
        datasize = 0,
        group = 0,
    },
    [`EVENT_RECOVER_AFTER_KNOCKOUT`] = {
        name = "EVENT_RECOVER_AFTER_KNOCKOUT",
        hash = "0xD93DDEDA",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PRE_MELEE_KILL`] = {
        name = "EVENT_PRE_MELEE_KILL",
        hash = "0x3114B476",
        datasize = 0,
        group = 0,
    },
    [`EVENT_SEEN_TERRIFIED_PED`] = {
        name = "EVENT_SEEN_TERRIFIED_PED",
        hash = "0xBB1EEFDA",
        datasize = 0,
        group = 0,
    },
    [`EVENT_MOUNT_DAMAGED_BY_PLAYER`] = {
        name = "EVENT_MOUNT_DAMAGED_BY_PLAYER",
        hash = "0x86EF65CE",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NEARBY_AMBIENT_THREAT`] = {
        name = "EVENT_NEARBY_AMBIENT_THREAT",
        hash = "0x597F9DCD",
        datasize = 0,
        group = 0,
    },
    [`EVENT_CALM_HORSE`] = {
        name = "EVENT_CALM_HORSE",
        hash = "0x81174BE7",
        datasize = 0,
        group = 0,
    },
    [`EVENT_CALL_FOR_COVER`] = {
        name = "EVENT_CALL_FOR_COVER",
        hash = "0x8B162B76",
        datasize = 0,
        group = 0,
    },
    [`EVENT_CAR_UNDRIVEABLE`] = {
        name = "EVENT_CAR_UNDRIVEABLE",
        hash = "0x77FAED6A",
        datasize = 0,
        group = 0,
    },
    [`EVENT_CLIMB_LADDER_ON_ROUTE`] = {
        name = "EVENT_CLIMB_LADDER_ON_ROUTE",
        hash = "0x0ADCEADB",
        datasize = 0,
        group = 0,
    },
    [`EVENT_CLIMB_NAVMESH_ON_ROUTE`] = {
        name = "EVENT_CLIMB_NAVMESH_ON_ROUTE",
        hash = "0x5E935DEC",
        datasize = 0,
        group = 0,
    },
    [`EVENT_COMBAT_TAUNT`] = {
        name = "EVENT_COMBAT_TAUNT",
        hash = "0x18AC17CE",
        datasize = 0,
        group = 0,
    },
    [`EVENT_FLUSH_TASKS`] = {
        name = "EVENT_FLUSH_TASKS",
        hash = "0x79F3063B",
        datasize = 0,
        group = 0,
    },
    [`EVENT_CLEAR_PED_TASKS`] = {
        name = "EVENT_CLEAR_PED_TASKS",
        hash = "0xE5D2FD49",
        datasize = 0,
        group = 0,
    },
    [`EVENT_HITCHING_POST`] = {
        name = "EVENT_HITCHING_POST",
        hash = "0xF1A5E555",
        datasize = 0,
        group = 0,
    },
    [`EVENT_CATCH_ITEM`] = {
        name = "EVENT_CATCH_ITEM",
        hash = "0x817E147F",
        datasize = 0,
        group = 0,
    },
    [`EVENT_LOCKED_DOOR`] = {
        name = "EVENT_LOCKED_DOOR",
        hash = "0x2DE2BE7E",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PEER_WINDOW`] = {
        name = "EVENT_PEER_WINDOW",
        hash = "0x37CFEF6E",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PED_TO_CHASE`] = {
        name = "EVENT_PED_TO_CHASE",
        hash = "0x475BB9A6",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PED_TO_FLEE`] = {
        name = "EVENT_PED_TO_FLEE",
        hash = "0xB32F55C7",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PERSCHAR_PED_SPAWNED`] = {
        name = "EVENT_PERSCHAR_PED_SPAWNED",
        hash = "0xA44CD273",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PLAYER_ANTAGONIZED_PED`] = {
        name = "EVENT_PLAYER_ANTAGONIZED_PED",
        hash = "0x6BFF0006",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PLAYER_GREETED_PED`] = {
        name = "EVENT_PLAYER_GREETED_PED",
        hash = "0x12AB59DE",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PLAYER_STRIPPED_WEAPON`] = {
        name = "EVENT_PLAYER_STRIPPED_WEAPON",
        hash = "0xB1C5FC59",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PLAYER_HAT_REMOVED_AT_SHOP`] = {
        name = "EVENT_PLAYER_HAT_REMOVED_AT_SHOP",
        hash = "0x1DB4E259",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PLAYER_LOCK_ON_TARGET`] = {
        name = "EVENT_PLAYER_LOCK_ON_TARGET",
        hash = "0xFAF53A91",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PLAYER_LOOK_FOCUS`] = {
        name = "EVENT_PLAYER_LOOK_FOCUS",
        hash = "0x461B885F",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PLAYER_SIM_UPDATE`] = {
        name = "EVENT_PLAYER_SIM_UPDATE",
        hash = "0x18BCBD4D",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PLAYER_ROBBED_PED`] = {
        name = "EVENT_PLAYER_ROBBED_PED",
        hash = "0x319BB142",
        datasize = 0,
        group = 0,
    },
    [`EVENT_REACTION_COMBAT_VICTORY`] = {
        name = "EVENT_REACTION_COMBAT_VICTORY",
        hash = "0xC2F56A5B",
        datasize = 0,
        group = 0,
    },
    [`EVENT_REACTION_INVESTIGATE_DEAD_PED`] = {
        name = "EVENT_REACTION_INVESTIGATE_DEAD_PED",
        hash = "0xE973A181",
        datasize = 0,
        group = 0,
    },
    [`EVENT_REACTION_INVESTIGATE_THREAT`] = {
        name = "EVENT_REACTION_INVESTIGATE_THREAT",
        hash = "0x280860F0",
        datasize = 0,
        group = 0,
    },
    [`EVENT_SHOUT_BLOCKING_LOS`] = {
        name = "EVENT_SHOUT_BLOCKING_LOS",
        hash = "0x476EB02F",
        datasize = 0,
        group = 0,
    },
    [`EVENT_STATIC_COUNT_REACHED_MAX`] = {
        name = "EVENT_STATIC_COUNT_REACHED_MAX",
        hash = "0xD32F6C76",
        datasize = 0,
        group = 0,
    },
    [`EVENT_SWITCH_2_NM_TASK`] = {
        name = "EVENT_SWITCH_2_NM_TASK",
        hash = "0x85A6257F",
        datasize = 0,
        group = 0,
    },
    [`EVENT_SCENARIO_FORCE_ACTION`] = {
        name = "EVENT_SCENARIO_FORCE_ACTION",
        hash = "0x7947C4E9",
        datasize = 0,
        group = 0,
    },
    [`EVENT_TRANSITION_TO_HOGTIED`] = {
        name = "EVENT_TRANSITION_TO_HOGTIED",
        hash = "0xFC687901",
        datasize = 0,
        group = 0,
    },
    [`EVENT_GET_UP`] = {
        name = "EVENT_GET_UP",
        hash = "0x1F689142",
        datasize = 0,
        group = 0,
    },
    [`EVENT_MOUNT_REACTION`] = {
        name = "EVENT_MOUNT_REACTION",
        hash = "0xC649563F",
        datasize = 0,
        group = 0,
    },
    [`EVENT_SADDLE_TRANSFER`] = {
        name = "EVENT_SADDLE_TRANSFER",
        hash = "0xE472E75C",
        datasize = 0,
        group = 0,
    },
    [`EVENT_START_CONVERSATION`] = {
        name = "EVENT_START_CONVERSATION",
        hash = "0x043D3DFB",
        datasize = 0,
        group = 0,
    },
    [`EVENT_STOP_CONVERSATION`] = {
        name = "EVENT_STOP_CONVERSATION",
        hash = "0x627F9E9D",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PLAYER_DEBUG_TELEPORTED`] = {
        name = "EVENT_PLAYER_DEBUG_TELEPORTED",
        hash = "0x57D685CA",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PICKUP_SPAWNED`] = {
        name = "EVENT_PICKUP_SPAWNED",
        hash = "0xCA9EF433",
        datasize = 0,
        group = 0,
    },
    [`EVENT_DEBUG_SETUP_CUTSCENE_WORLD_STATE`] = {
        name = "EVENT_DEBUG_SETUP_CUTSCENE_WORLD_STATE",
        hash = "0x8C8C49F3",
        datasize = 0,
        group = 0,
    },
    [`EVENT_WAIT_FOR_INTERACTION`] = {
        name = "EVENT_WAIT_FOR_INTERACTION",
        hash = "0xAE1E92AB",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_PLAYER_SPAWN`] = {
        name = "EVENT_NETWORK_PLAYER_SPAWN",
        hash = "0x557C3D18",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_EXTENDED_INVITE`] = {
        name = "EVENT_NETWORK_EXTENDED_INVITE",
        hash = "0x42D31CDC",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_PLAYER_SIGNED_OFFLINE`] = {
        name = "EVENT_NETWORK_PLAYER_SIGNED_OFFLINE",
        hash = "0x50C9BFCC",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_PLAYER_SIGNED_ONLINE`] = {
        name = "EVENT_NETWORK_PLAYER_SIGNED_ONLINE",
        hash = "0xAE251598",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_SIGN_IN_STATE_CHANGED`] = {
        name = "EVENT_NETWORK_SIGN_IN_STATE_CHANGED",
        hash = "0x09C19B90",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_SIGN_IN_START_NEW_GAME`] = {
        name = "EVENT_NETWORK_SIGN_IN_START_NEW_GAME",
        hash = "0x0E4D4F11",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_NETWORK_ROS_CHANGED`] = {
        name = "EVENT_NETWORK_NETWORK_ROS_CHANGED",
        hash = "0x9B5B1221",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_BAIL_DECISION_PENDING`] = {
        name = "EVENT_NETWORK_BAIL_DECISION_PENDING",
        hash = "0xE09BB134",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_BAIL_DECISION_MADE`] = {
        name = "EVENT_NETWORK_BAIL_DECISION_MADE",
        hash = "0x29C8C2A6",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_HOST_MIGRATION`] = {
        name = "EVENT_NETWORK_HOST_MIGRATION",
        hash = "0xE41EF3B6",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_IS_VOLUME_EMPTY_RESULT`] = {
        name = "EVENT_NETWORK_IS_VOLUME_EMPTY_RESULT",
        hash = "0x3B5BF49F",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_CHEAT_TRIGGERED`] = {
        name = "EVENT_NETWORK_CHEAT_TRIGGERED",
        hash = "0x213D6AA3",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_KNOCKEDOUT_ENTITY`] = {
        name = "EVENT_NETWORK_KNOCKEDOUT_ENTITY",
        hash = "0xF9620AF0",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_PLAYER_ARREST`] = {
        name = "EVENT_NETWORK_PLAYER_ARREST",
        hash = "0x7FBD0577",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_TIMED_EXPLOSION`] = {
        name = "EVENT_NETWORK_TIMED_EXPLOSION",
        hash = "0x62FEA86A",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_PRIMARY_CREW_CHANGED`] = {
        name = "EVENT_NETWORK_PRIMARY_CREW_CHANGED",
        hash = "0x51E05B98",
        datasize = 0,
        group = 0,
    },
    [`EVENT_VOICE_SESSION_STARTED`] = {
        name = "EVENT_VOICE_SESSION_STARTED",
        hash = "0x3FB676E5",
        datasize = 0,
        group = 0,
    },
    [`EVENT_VOICE_SESSION_ENDED`] = {
        name = "EVENT_VOICE_SESSION_ENDED",
        hash = "0xF235438B",
        datasize = 0,
        group = 0,
    },
    [`EVENT_VOICE_CONNECTION_REQUESTED`] = {
        name = "EVENT_VOICE_CONNECTION_REQUESTED",
        hash = "0x11A01600",
        datasize = 0,
        group = 0,
    },
    [`EVENT_VOICE_CONNECTION_RESPONSE`] = {
        name = "EVENT_VOICE_CONNECTION_RESPONSE",
        hash = "0x3A6E29EF",
        datasize = 0,
        group = 0,
    },
    [`EVENT_VOICE_CONNECTION_TERMINATED`] = {
        name = "EVENT_VOICE_CONNECTION_TERMINATED",
        hash = "0x8E72FBDF",
        datasize = 0,
        group = 0,
    },
    [`EVENT_CLOUD_FILE_RESPONSE`] = {
        name = "EVENT_CLOUD_FILE_RESPONSE",
        hash = "0x35ED96A4",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_PRESENCE_STAT_UPDATE`] = {
        name = "EVENT_NETWORK_PRESENCE_STAT_UPDATE",
        hash = "0x545C9E04",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_INBOX_MSGS_RCVD`] = {
        name = "EVENT_NETWORK_INBOX_MSGS_RCVD",
        hash = "0x7DB392ED",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_ATTEMPT_HOST_MIGRATION`] = {
        name = "EVENT_NETWORK_ATTEMPT_HOST_MIGRATION",
        hash = "0xA7731B41",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_INCREMENT_STAT`] = {
        name = "EVENT_NETWORK_INCREMENT_STAT",
        hash = "0x20841BF8",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_ROCKSTAR_INVITE_RECEIVED`] = {
        name = "EVENT_NETWORK_ROCKSTAR_INVITE_RECEIVED",
        hash = "0xD4C53951",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_ROCKSTAR_INVITE_REMOVED`] = {
        name = "EVENT_NETWORK_ROCKSTAR_INVITE_REMOVED",
        hash = "0x205FAA36",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_PLATFORM_INVITE_ACCEPTED`] = {
        name = "EVENT_NETWORK_PLATFORM_INVITE_ACCEPTED",
        hash = "0x8311ED1F",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_INVITE_RESULT`] = {
        name = "EVENT_NETWORK_INVITE_RESULT",
        hash = "0x35EAC033",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_INVITE_RESPONSE`] = {
        name = "EVENT_NETWORK_INVITE_RESPONSE",
        hash = "0x304251BC",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_JOIN_REQUEST_TIMED_OUT`] = {
        name = "EVENT_NETWORK_JOIN_REQUEST_TIMED_OUT",
        hash = "0x1EC5572A",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_INVITE_UNAVAILABLE`] = {
        name = "EVENT_NETWORK_INVITE_UNAVAILABLE",
        hash = "0x6EE28EDE",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_CASH_TRANSACTION_LOG`] = {
        name = "EVENT_NETWORK_CASH_TRANSACTION_LOG",
        hash = "0x6CEB0A79",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_PRESENCE_TRIGGER`] = {
        name = "EVENT_NETWORK_PRESENCE_TRIGGER",
        hash = "0x70B03D99",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_PRESENCE_EMAIL`] = {
        name = "EVENT_NETWORK_PRESENCE_EMAIL",
        hash = "0xC43CE9FC",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_SPECTATE_LOCAL`] = {
        name = "EVENT_NETWORK_SPECTATE_LOCAL",
        hash = "0xB0FB6B46",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_CLOUD_EVENT`] = {
        name = "EVENT_NETWORK_CLOUD_EVENT",
        hash = "0xD72D7FF2",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_CASHINVENTORY_DELETE_CHAR`] = {
        name = "EVENT_NETWORK_CASHINVENTORY_DELETE_CHAR",
        hash = "0x1AA41F78",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_APP_LAUNCHED`] = {
        name = "EVENT_NETWORK_APP_LAUNCHED",
        hash = "0x22FE0161",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_ONLINE_PERMISSIONS_UPDATED`] = {
        name = "EVENT_NETWORK_ONLINE_PERMISSIONS_UPDATED",
        hash = "0x3D394467",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_SYSTEM_SERVICE_EVENT`] = {
        name = "EVENT_NETWORK_SYSTEM_SERVICE_EVENT",
        hash = "0x92BF8ECE",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_REQUEST_DELAY`] = {
        name = "EVENT_NETWORK_REQUEST_DELAY",
        hash = "0x61248240",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_SOCIAL_CLUB_ACCOUNT_LINKED`] = {
        name = "EVENT_NETWORK_SOCIAL_CLUB_ACCOUNT_LINKED",
        hash = "0x22F1E1BD",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_SCADMIN_PLAYER_UPDATED`] = {
        name = "EVENT_NETWORK_SCADMIN_PLAYER_UPDATED",
        hash = "0xCB80313C",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_SCADMIN_RECEIVED_CASH`] = {
        name = "EVENT_NETWORK_SCADMIN_RECEIVED_CASH",
        hash = "0xD9B72352",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_CREW_INVITE_REQUEST_RECEIVED`] = {
        name = "EVENT_NETWORK_CREW_INVITE_REQUEST_RECEIVED",
        hash = "0x82D148BA",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_DRAG_PED`] = {
        name = "EVENT_NETWORK_DRAG_PED",
        hash = "0xA848D485",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_DROP_PED`] = {
        name = "EVENT_NETWORK_DROP_PED",
        hash = "0x66F1310D",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_DEBUG_TOGGLE_MP`] = {
        name = "EVENT_NETWORK_DEBUG_TOGGLE_MP",
        hash = "0x66E08C82",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_POSSE_KICKED`] = {
        name = "EVENT_NETWORK_POSSE_KICKED",
        hash = "0x7AABE18D",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_POSSE_DATA_OR_MEMBERSHIP_CHANGED`] = {
        name = "EVENT_NETWORK_POSSE_DATA_OR_MEMBERSHIP_CHANGED",
        hash = "0x97BCB3FC",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_POSSE_PRESENCE_REQUEST_COMPLETE`] = {
        name = "EVENT_NETWORK_POSSE_PRESENCE_REQUEST_COMPLETE",
        hash = "0x0E241A54",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_POSSE_STATS_READ_COMPLETE`] = {
        name = "EVENT_NETWORK_POSSE_STATS_READ_COMPLETE",
        hash = "0xA5CF57F3",
        datasize = 0,
        group = 0,
    },
    [`EVENT_SCENARIO_RELEASE_BUTTON`] = {
        name = "EVENT_SCENARIO_RELEASE_BUTTON",
        hash = "0xE26D7A2C",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_CASHINVENTORY_NOTIFICATION`] = {
        name = "EVENT_NETWORK_CASHINVENTORY_NOTIFICATION",
        hash = "0xC88EF5AD",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ERRORS_UNKNOWN_ERROR`] = {
        name = "EVENT_ERRORS_UNKNOWN_ERROR",
        hash = "0xC91372B0",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ERRORS_ARRAY_OVERFLOW`] = {
        name = "EVENT_ERRORS_ARRAY_OVERFLOW",
        hash = "0xC4D48E35",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ERRORS_INSTRUCTION_LIMIT`] = {
        name = "EVENT_ERRORS_INSTRUCTION_LIMIT",
        hash = "0x17A9CE16",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ERRORS_STACK_OVERFLOW`] = {
        name = "EVENT_ERRORS_STACK_OVERFLOW",
        hash = "0x777D36AC",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ERRORS_GLOBAL_BLOCK_INACCESSIBLE`] = {
        name = "EVENT_ERRORS_GLOBAL_BLOCK_INACCESSIBLE",
        hash = "0xC3D00F55",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ERRORS_GLOBAL_BLOCK_NOT_RESIDENT`] = {
        name = "EVENT_ERRORS_GLOBAL_BLOCK_NOT_RESIDENT",
        hash = "0x3D5296DC",
        datasize = 0,
        group = 0,
    },
    [`EVENT_INTERACTION`] = {
        name = "EVENT_INTERACTION",
        hash = "0x8464037C",
        datasize = 0,
        group = 0,
    },
    [`EVENT_INTERACTION_ACTION`] = {
        name = "EVENT_INTERACTION_ACTION",
        hash = "0x490A6D76",
        datasize = 0,
        group = 0,
    },
    [`EVENT_REACTION_ANALYSIS_ACTION`] = {
        name = "EVENT_REACTION_ANALYSIS_ACTION",
        hash = "0xDF2629CB",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ANIMAL_RESPONDED_TO_THREAT`] = {
        name = "EVENT_ANIMAL_RESPONDED_TO_THREAT",
        hash = "0x8D637C64",
        datasize = 0,
        group = 0,
    },
    [`EVENT_ANIMAL_TAMING_CALLOUT`] = {
        name = "EVENT_ANIMAL_TAMING_CALLOUT",
        hash = "0x52348D75",
        datasize = 0,
        group = 0,
    },
    [`EVENT_CALL_FOR_BACKUP`] = {
        name = "EVENT_CALL_FOR_BACKUP",
        hash = "0xEF5F96FC",
        datasize = 0,
        group = 0,
    },
    [`EVENT_DEATH`] = {
        name = "EVENT_DEATH",
        hash = "0xAEEF7F93",
        datasize = 0,
        group = 0,
    },
    [`EVENT_HELP_AMBIENT_FRIEND`] = {
        name = "EVENT_HELP_AMBIENT_FRIEND",
        hash = "0xEFFF65EE",
        datasize = 0,
        group = 0,
    },
    [`EVENT_LASSO_DETACHED`] = {
        name = "EVENT_LASSO_DETACHED",
        hash = "0xA25B08DF",
        datasize = 0,
        group = 0,
    },
    [`EVENT_BOLAS_HIT`] = {
        name = "EVENT_BOLAS_HIT",
        hash = "0x2286D516",
        datasize = 0,
        group = 0,
    },
    [`EVENT_PED_ON_VEHICLE_ROOF`] = {
        name = "EVENT_PED_ON_VEHICLE_ROOF",
        hash = "0x10767997",
        datasize = 0,
        group = 0,
    },
    [`EVENT_RIDER_DISMOUNTED`] = {
        name = "EVENT_RIDER_DISMOUNTED",
        hash = "0x349C4D9F",
        datasize = 0,
        group = 0,
    },
    [`EVENT_WON_APPROACH_ELECTION`] = {
        name = "EVENT_WON_APPROACH_ELECTION",
        hash = "0x10DAC8DD",
        datasize = 0,
        group = 0,
    },
    [`EVENT_OWNED_ENTITY_INTERACTION`] = {
        name = "EVENT_OWNED_ENTITY_INTERACTION",
        hash = "0x4BD7CC32",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_NOMINATED_GET_UPCOMING_CONTENT_RESPONSE`] = {
        name = "EVENT_NETWORK_NOMINATED_GET_UPCOMING_CONTENT_RESPONSE",
        hash = "0x655328B8",
        datasize = 0,
        group = 0,
    },
    [`EVENT_NETWORK_NOMINATED_GO_TO_NEXT_CONTENT_RESPONSE`] = {
        name = "EVENT_NETWORK_NOMINATED_GO_TO_NEXT_CONTENT_RESPONSE",
        hash = "0x5EB1371E",
        datasize = 0,
        group = 0,
    }

}

return {
    GameEvents = GameEvents
}
