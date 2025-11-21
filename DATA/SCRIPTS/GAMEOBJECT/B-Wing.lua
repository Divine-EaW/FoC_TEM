-- X-Wing plan (for TEM)
-- Author: Nikomer (Discord: Nikomer#3131)
--         Lany (Discord: .lany)
-- Revision: 1.7 - Date: 2023/06/29
--
-- FIXES:
--     - X-Wing spoiler lock nebula bug (ability becomes unusable)
--     - X-Wing container induced FOW reveal reduction adjusted to simulate valilla value (+ TEM balance adj.)
-- ADDS:
--     - Dynamic FOW reveal for the spectator faction
-- CHANGED:
--     - execution of Update_Spoiler() moved to separate thread to reduce lag (not sure if helps?)
--     - updated to include support for Red Squadron X-Wing units
--     - removed Red Squadron support, as they now get their own script
--     - Added dynamic FOW reveal logic with half the tick rate
-- REQUIRES:
--     - the following XML tag be added to Containers.xml for X-Wing squadron:
--       <Lua_Script>X-Wing</Lua_Script>
--       (a container needs to be created for X-Wing squadron, see TEM Containers.xml)
-- TODO:
--      - apply fix to B-Wing squadron, Rogue Squadron (FOC only)

require("PGStateMachine")
require("PGCommands")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	ServiceRate = 0.25 -- 4x per second
	Define_State("State_Init", State_Init);

	ability_name = "SPOILER_LOCK"
	Valid_Units_List = {"B-Wing"}
	spectator_players_present = nil
	spectator_players = nil
end

function State_Init(message)
	if message == OnEnter then
		-- prevent script from executing in galactic mode
		if Get_Game_Mode() ~= "Space" then
			return
		end
		-- find all X-Wings in the game, and determine if they belong to this squadron
		units = Get_Squad_Units()
		-- Spectator FOW reveal should fire with a lower frequency than the 4/sec for the bug fix
		-- tick variable is used to track that
		spectator_players = GlobalValue.Get("g_human_spectator_players")
		tick = 0
	elseif message == OnUpdate then
		Create_Thread("Update_Spoiler")
	end
end

-- Returns table of all X-Wing units contained by script Object (squadron)
function Get_Squad_Units()
	local units = {}

	-- search for all X-Wings and assign the ones contained by this squad to table of units
	for each, bwing in pairs(Valid_Units_List) do
		local Found_Units = Find_All_Objects_Of_Type(bwing)
		for key, unit in pairs(Found_Units) do
			if TestValid(unit) and unit.Get_Parent_Object() == Object then
				table.insert(units, unit)
			end
		end
	end
	return units
end

-- Tests squadron units for any of them being in a state of being affected by a nebula
function Any_In_Nebula(units)
    for key, unit in pairs(units) do
        if TestValid(unit) and unit.Get_Hull() > 0.0 then
            if not in_nebula then
                if unit.Is_In_Nebula() or unit.Is_In_Ion_Storm() then
                    return true
                end
            end
        end
    end
    return false
end

-- Tests all X-Wings in the squad if their sfoil state matches squadron's sfoil state
-- Removes X-Wings from being checked if they have been destroyed
-- Enables dynamic FOW reveal for the spectator by temporarily revealing
-- Update_Spoiler() is a thread-safe function
function Update_Spoiler()
	-- FOW reveal for Spectator happens at half the Service Rate (2x / sec)
	--if spectator_players ~= nil then
		if tick == 0 then
			if Exist_Spectator_Players() then
				for player, x in pairs(spectator_players) do
					FogOfWar.Temporary_Reveal(player, Object, 750)
				end
			end
			tick = 1
		else
			tick = 0
		end
	--end

	-- S-Foil bug fix
	local sfoils = Object.Is_Ability_Active(ability_name)
	if Any_In_Nebula(units) then
		for key, unit in pairs(units) do
			if TestValid(unit) and unit.Get_Hull() > 0.0 then
				-- turn s-foils off for any glitched x-wings
				if not sfoils and unit.Is_Ability_Active(ability_name) then
					unit.Activate_Ability(ability_name, sfoils)
					DebugMessage("%s -- Proc spoiler lock in nebula fix", tostring(Script))
				end
			else
				-- remove nil X-Wings from being tested
				table.remove(units, key)
				DebugMessage("%s -- Removed dead B-Wing from table", tostring(Script))
			end
		end
	else
		DebugMessage("%s -- No B-Wing inside a nebula in this squadron", tostring(Script))
	end
end

function Get_Spectator_Players()
	local players = {}

	if Get_Game_Mode() == "Space" then
		for i, unit in pairs(Find_All_Objects_Of_Type("Spectator_Dummy_Starting_Unit")) do -- space starting unit
			players[unit.Get_Owner()] = true
		end
	end
	
	if Get_Game_Mode() == "Land" then
		ScriptExit()
	end

	return players
end

function Exist_Spectator_Players()
	if spectator_players ~= nil then
		return true
	end
	-- If the calculation has not been completed in the Spectator script, skip this tick
	if spectator_players_present == nil then
		spectator_players_present = GlobalValue.Get("g_spectator_players_present")
		return false
	end
	
	if spectator_players == nil then
		-- load them if there are any to load
		if spectator_players_present == "none" then
			return false
		else
			if spectator_players_present == "new_method" then
				spectator_players = Get_Spectator_Players();
			else
				spectator_players = {}
				spectator_players[Find_Player("Pirates")] = true
			end
			return true
		end
	end
end
