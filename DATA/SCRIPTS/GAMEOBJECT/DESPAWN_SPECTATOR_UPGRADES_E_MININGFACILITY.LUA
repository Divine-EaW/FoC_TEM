require("PGStateMachine")
require("PGBase")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	Define_State("State_Init", State_Init);
	ServiceRate = 1.0

	spectator_player = nil

	team_1_upgrades_list =
	{
		"Spectator_T1_EL_Increased_Production_L1_Upgrade",
		"Spectator_T1_EL_Increased_Production_L2_Upgrade",
		"Spectator_T1_EL_Increased_Production_L3_Upgrade"
	}
	
	team_2_upgrades_list =
	{
		"Spectator_T2_EL_Increased_Production_L1_Upgrade",
		"Spectator_T2_EL_Increased_Production_L2_Upgrade",
		"Spectator_T2_EL_Increased_Production_L3_Upgrade"
	}
end

function State_Init(message)
	if message == OnEnter then
		Sleep(0.5) --Required to properly find facilities
		upgrades_list_1 = Find_All_Objects_Of_Type("EL_Increased_Production_L1_Upgrade")
		upgrades_list_2 = Find_All_Objects_Of_Type("EL_Increased_Production_L2_Upgrade")
		upgrades_list_3 = Find_All_Objects_Of_Type("EL_Increased_Production_L3_Upgrade")
		facility_list = Find_All_Objects_Of_Type("Empire_Ground_Mining_Facility")
		player_team = Object.Get_Owner().Get_Team()

		for i, facility in ipairs(facility_list) do
			if TestValid(facility) then
				facility_team = facility.Get_Owner().Get_Team()
				if player_team == facility_team then
					Object.Despawn()
					ScriptExit()
				end
			end
		end 
		for i, upgrade in ipairs(upgrades_list_1) do
			if TestValid(upgrade) then
				upgrade_team = upgrade.Get_Owner().Get_Team()
				if player_team == upgrade_team then
					upgrade.Despawn()
				end
			end
		end
		for i, upgrade in ipairs(upgrades_list_2) do
			if TestValid(upgrade) then
				upgrade_team = upgrade.Get_Owner().Get_Team()
				if player_team == upgrade_team then
					upgrade.Despawn()
				end
			end
		end
		for i, upgrade in ipairs(upgrades_list_3) do
			if TestValid(upgrade) then
				upgrade_team = upgrade.Get_Owner().Get_Team()
				if player_team == upgrade_team then
					upgrade.Despawn()
				end
			end
		end
	
		spectator_player = Find_First_Object("Spectator_Reveal_Marker")

		if not spectator_player then
			Object.Despawn()
			ScriptExit()
		end 

		if Object.Get_Owner().Get_Team() == 0 then
			for i, upgrade_name in ipairs(team_1_upgrades_list) do
				local upgrade = Find_First_Object(upgrade_name)
				if TestValid(upgrade) then
					upgrade.Despawn()
				end
			end 
		else 
			if Object.Get_Owner().Get_Team() == 1 then
				for i, upgrade_name in ipairs(team_2_upgrades_list) do
					local upgrade = Find_First_Object(upgrade_name)
					if TestValid(upgrade) then
						upgrade.Despawn()
					end
				end
			end
		end 
	end
	Object.Despawn()
	ScriptExit()
end