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

-- multiple_interceptors.lua

-- Define the player ID for the Imperial player (usually 0 for Empire)
local imperial_player = Find_Player(Empire) 

-- Define the type name for the TIE Interceptor squadron (check your XML files for the exact name)
local interceptor_type = "Empire_TIE_Interceptor_Squadron_Tech_2" -- This name might vary by mod

-- Function to spawn a single squadron
function Reinforce_Unit(unit_type, position, Empire, false, false)
    -- Spawn the unit. Reinforce_Unit is preferred for respecting collision and using reinforcement mechanics.
    
    -- Alternatively, use Create_Generic_Object for immediate, no-collision spawning:
    -- Create_Generic_Object(unit_type, position, player)
    
    -- Optional: Display a message or effect
    -- MessageBox("Reinforcements Incoming!") -- Example message command
end