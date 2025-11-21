-- This script is attached to the reveal marker present for team 3
-- By: Lany#9464 w/ Galyana#3315 (Discord)

require("PGStateMachine")
require("PGBase")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	ServiceRate = 1.0
	Define_State("State_Init", State_Init);

end

function State_Init(message)
	if message == OnEnter then
	    if Get_Game_Mode() == "Space" then
            Create_Generic_Object("Spectator_Credits_Script_Marker_Space", Object.Get_Position(), Object.Get_Owner())
        end
        if Get_Game_Mode() == "Land" then
            Create_Generic_Object("Spectator_Credits_Script_Marker_Land", Object.Get_Position(), Object.Get_Owner())
        end
    
	end
ScriptExit()

end

