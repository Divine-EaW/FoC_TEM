-- A script attached to the asteroid mine destruction survivors to delete all reset income upgrades

require("PGStateMachine")
require("PGBase")

function Definitions()
	ServiceRate = 1
	Define_State("State_Init", State_Init);
end

function State_Init(message)
	if message == OnEnter then
		Sleep(1)
		upgrades_list_1 = Find_All_Objects_Of_Type("RS_Increased_Supplies_L1_Upgrade")
		upgrades_list_2 = Find_All_Objects_Of_Type("RS_Increased_Supplies_L2_Upgrade")
		asteroid_list = Find_All_Objects_Of_Type("Rebel_Mineral_Extractor")

		player_team = Object.Get_Owner().Get_Team() 

-- Check if any asteroids are still alive and on our team		
		for i, asteroid in ipairs(asteroid_list) do
			if TestValid(asteroid) then
				asteroid_team = asteroid.Get_Owner().Get_Team()
				if player_team == asteroid_team then
					Object.Despawn()
					ScriptExit()
				end
			end
		end

-- If no asteroids are found, find and delete relevant reset upgrades
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
	end
	Object.Despawn()
	ScriptExit()
end