-- This script is attached to the reveal marker present for team 3
-- By: Lany#9464 w/ Galyana#3315 (Discord)

require("PGStateMachine")
require("PGBase")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	ServiceRate = 1.0
	Define_State("State_Init", State_Init);

	human_spectator_players = {}
	spectator_is_present = false
end

function State_Init(message)
	if message == OnEnter then
	Sleep(2) -- generous sleep to allow for spawning of starting units

	primary_spectator_player = Object.Get_Owner()
	if TestValid(primary_spectator_player) then
		if primary_spectator_player.Is_Human() then
			spectator_is_present = true
			addToSet(human_spectator_players, primary_spectator_player)
		else
			DebugMessage("-- Info: Marker Owner Spectator Player is not human, exiting.")
			ScriptExit()
	end
	else
		DebugMessage("-- ERROR: Marker Owner Spectator Player is not valid! Exiting.")
		ScriptExit()
	end

	team_one_players = Get_All_Players_Of_Team(0)
	team_two_players = Get_All_Players_Of_Team(1)
	DebugMessage("-- INFO: team_one_players contains %s entries", tostring(setSize(team_one_players)))
	DebugMessage("-- INFO: team_two_players contains %s entries", tostring(setSize(team_two_players)))
	end

	if message == OnUpdate then
		Update_Credits_Display() -- Sync version
	end
end

-- Gets all player objects of 'faction' via cycling the Space starting units of it and collecting the owners
-- returns a set (!) of player objects or nil if the faction is unknown
function Get_All_Players(faction)
	DebugMessage("%s -- Entering Get_All_Players", tostring(Script))
	local players = {}
	local space_starting_unit_name = nil

	if faction == "Rebel" then
		space_starting_unit_name = "X-Wing"
	elseif faction == "Empire" then
		space_starting_unit_name = "TIE_Interceptor"
	elseif faction == "Underworld" then
		space_starting_unit_name = "Starviper_Fighter"
	end

	if space_starting_unit_name ~= nil then
		DebugMessage("-- Searching for unit: %s", tostring(space_starting_unit_name))
		for i, unit in pairs(Find_All_Objects_Of_Type(space_starting_unit_name)) do
			addToSet(players, unit.Get_Owner())
		end
	else
		DebugMessage("-- WARNING: Called Get_All_Players with an unknown faction parameter: %s", tostring(faction))
		return nil
	end

	return players
end

-- Gets all players of a Team, by using Get_All_Players to find all players in the game and then filter for the queried team
-- team_id is a number
function Get_All_Players_Of_Team(team_id)
	DebugMessage("%s -- Entering Get_All_Players_Of_Team for team %s", tostring(Script), tostring(team_id))

	found_players = {} -- set

	factions = {"Rebel", "Empire", "Underworld"}
	faction_detected = false -- All players of a team will have the same faction, we can exit early

	for key, faction in pairs(factions) do
		-- early exit if the faction was already detected
		if faction_detected then
			return found_players
		end
		-- query the faction for it's starting units and then the owners for their team id
		players = Get_All_Players(faction)
		if players ~= nil then
			for player, val in players do
				if TestValid(player) then
					DebugMessage("-- Found player %s of team %s", tostring(player), tostring(player.Get_Team()))
					if player.Get_Team() == team_id then
						DebugMessage("-- Adding player to list for team %s", tostring(team_id))
						addToSet(found_players, player)
					end
				else
					DebugMessage("-- ERROR: player not valid")
				end
			end
		end
	end
	return found_players
end

-- Update the spectator player's credit display to show the rebel and empire player's respective funds
function Update_Credits_Display()
	if spectator_is_present then
		local team_1_credits = 0
		local team_2_credits = 0

		for player,x in team_one_players do
			team_1_credits = team_1_credits + player.Get_Credits()
		end

		for player,x in team_two_players do
			team_2_credits = team_2_credits + player.Get_Credits()
		end

		-- format team 1 credits (cut Ones)
		local team_1_credits = tonumber(Dirty_Floor(team_1_credits / 10))
		local team_1_credits = Clamp(team_1_credits, 0, 999)

		-- format team 2 credits (cut Ones)
		local team_2_credits = tonumber(Dirty_Floor(team_2_credits / 10))
		local team_2_credits = Clamp(team_2_credits, 0, 999)

		-- update spectator credits display ([Team]111,[Team]222)
		local new_spectator_credits = team_1_credits * 1000
		local new_spectator_credits = new_spectator_credits + team_2_credits

		for player,x in human_spectator_players do
			local old_credits = player.Get_Credits()
			player.Give_Money(-old_credits) -- at 0 credits now
			player.Give_Money(new_spectator_credits)
		end
	end
end

-- Set data type utility functions
-- a Set is a special use of a table where arbitrary keys always have the vale nil or true
-- loop usage: for key,unused in set do
function addToSet(set, key)
	set[key] = true
end

function removeFromSet(set, key)
	set[key] = nil
end

function setContains(set, key)
	return set[key] ~= nil
end

function setSize(set)
	local i = 0
	for key, value in pairs(set) do
		i = i + 1
	end
	return i
end
