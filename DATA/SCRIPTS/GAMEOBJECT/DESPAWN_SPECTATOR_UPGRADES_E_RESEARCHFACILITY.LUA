require("PGStateMachine")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	Define_State("State_Init", State_Init);
	ServiceRate = 1.0

	spectator_player = nil

	team_1_upgrades_list =
	{
		"Spectator_T1_EL_Enhanced_Turret_Firepower_L1_Upgrade",
		"Spectator_T1_EL_Enhanced_Turret_Firepower_L2_Upgrade",
		"Spectator_T1_EL_Reinforced_Structures_Upgrade"
	}
	
	team_2_upgrades_list =
	{
		"Spectator_T2_EL_Enhanced_Turret_Firepower_L1_Upgrade",
		"Spectator_T2_EL_Enhanced_Turret_Firepower_L2_Upgrade",
		"Spectator_T2_EL_Reinforced_Structures_Upgrade"
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