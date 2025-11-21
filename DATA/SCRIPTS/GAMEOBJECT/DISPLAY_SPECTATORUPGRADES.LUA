-- Spectator upgrade display for SoaFE
-- spawns the appropriate dummy upgrade for the Spectator Faction
-- Is attached to a proper Upgrade, and will be activated when that Upgrade is activated (completes building)
--
-- Revision: 1.1 - Date: 2022/04/10
--
-- Authors: Nikomer   (Nikomer#1313 on Discord) | Revision by Galyana
--
-- REQUIRES:
--     - the following XML tag be added to all pertinent Upgrade Objects:
--       <Lua_Script>Display_SpectatorUpgrades</Lua_Script>

require("PGStateMachine")
require("PGBase")
require("PGSpawnUnits")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	Define_State("State_Init", State_Init);
	ServiceRate = 1.0

	spectator_player = nil
end

function State_Init(message)
    if message == OnEnter then 
        spectator_player = Find_First_Object("Spectator_Reveal_Marker") --.Get_Owner()
        
        if not spectator_player then
            ScriptExit() 
        end
        
        if spectator_player then
            spectator_player = Find_First_Object("Spectator_Reveal_Marker").Get_Owner()
        end
                
--        if TestValid(spectator_player) then 
--            DebugMessage("-- Found primary spectator player %s.", tostring(spectator_player))
--        else
--            DebugMessage("-- ERROR: Did not find primary spectator player, exiting script.")
--            ScriptExit()
--        end
        
        local owner_team = Object.Get_Owner().Get_Team() + 1
        local upgrade_name = "Spectator_T" .. owner_team .. "_" .. Object.Get_Type().Get_Name()
        
        DebugMessage("-- Spawning Spectator dummy upgrade: %s", upgrade_name)
        Create_Generic_Object(upgrade_name, Object.Get_Position(), spectator_player)
    end
    ScriptExit()
end