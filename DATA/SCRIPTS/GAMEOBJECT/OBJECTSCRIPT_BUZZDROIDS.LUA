require("PGStateMachine")

function Definitions()
	ServiceRate = 1
	Define_State("State_Spawned_In_Nebula", State_Spawned_In_Nebula);
end

function State_Spawned_In_Nebula(message)
	if message == OnEnter then
		if Object.Is_In_Nebula() or Object.Is_In_Ion_Storm() then
			Object.Take_Damage(100) --Tune to reduce object lifetime
		end
	end
end