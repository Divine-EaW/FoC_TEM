-- A script attached to completed Empire Asteroid Mines that resets
-- the income bonus upgrade for all controlled asteroid mines.

require("PGStateMachine")
require("PGBase")

function Definitions()
	ServiceRate = 1
	Define_State("State_Init", State_Init);
end

function State_Init(message)
	if message == OnEnter then
		upgrades_list_1 = Find_All_Objects_Of_Type("US_Extort_Cash_L1_Upgrade")
		upgrades_list_2 = Find_All_Objects_Of_Type("US_Extort_Cash_L2_Upgrade")

		player_team = Object.Get_Owner().Get_Team()
		
		for i, upgrade in ipairs(upgrades_list_1) do
			if TestValid(upgrade) then
				upgrade_team = upgrade.Get_Owner().Get_Team()			
				if player_team == upgrade_team then
					Create_Generic_Object("US_Extort_Cash_L1_Upgrade", upgrade.Get_Position(), upgrade.Get_Owner())
					upgrade.Despawn()
				end
			end
		end
		
		for i, upgrade in ipairs(upgrades_list_2) do
			if TestValid(upgrade) then
				upgrade_team = upgrade.Get_Owner().Get_Team()			
				if player_team == upgrade_team then
					Create_Generic_Object("US_Extort_Cash_L2_Upgrade", upgrade.Get_Position(), upgrade.Get_Owner())
					upgrade.Despawn()
				end
			end
		end
	end
	ScriptExit()
end