require("PGStateMachine")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	Define_State("State_Init", State_Init);
	ServiceRate = 1.0

	spectator_player = nil

	team_1_upgrades_list =
	{
		"Spectator_T1_UC_Level_Two_Tech_Upgrade",
		"Spectator_T1_UC_Level_Three_Tech_Upgrade",
		"Spectator_T1_UL_Black_Market_Shielding_L1_Upgrade",
		"Spectator_T1_UL_Black_Market_Shielding_L2_Upgrade",
		"Spectator_T1_UL_Bounty_Upgrade"
	}
	
	team_2_upgrades_list =
	{
		"Spectator_T2_UC_Level_Two_Tech_Upgrade",
		"Spectator_T2_UC_Level_Three_Tech_Upgrade",
		"Spectator_T2_UL_Black_Market_Shielding_L1_Upgrade",
		"Spectator_T2_UL_Black_Market_Shielding_L2_Upgrade",
		"Spectator_T2_UL_Bounty_Upgrade"
	}
end

function State_Init(message)
	if message == OnEnter then
		spectator_player = Find_First_Object("Spectator_Reveal_Marker")

		if not spectator_player then
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
end