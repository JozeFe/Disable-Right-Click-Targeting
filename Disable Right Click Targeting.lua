-- =========================================================
--  Disable Right Click Targeting
-- =========================================================

local ADDON_NAME = "Disable Right Click Targeting"
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")

local function dbg(msg)
    print("|cff00ff00[" .. ADDON_NAME .. "]|r " .. msg)
end

-- =========================================================
--  Right-click secure setup
-- =========================================================
local function SetupRightClickBehavior()
    if _G.mlook then
        --dbg("mlook button already exists, skipping creation.")
        return
    end

	local f=CreateFrame("button","mlook")
	f:RegisterForClicks("AnyDown","AnyUp")
	f:SetScript("OnClick",
        function(s,b,d)
            if d then 
                MouselookStart()
            else 
                MouselookStop()
            end 
        end)
    SecureStateDriverManager:RegisterEvent("UPDATE_MOUSEOVER_UNIT")


	local f=CreateFrame("frame",nil,nil,"SecureHandlerStateTemplate")
    RegisterStateDriver(f,"mov","[@mouseover,exists]1;0")
    f:SetAttribute("_onstate-mov","if newstate==1 then self:SetBindingClick(1,'BUTTON2','mlook')else self:ClearBindings()end")

    dbg("Right-click is now disabled.")
end

-- =========================================================
--  Event handling
-- =========================================================
frame:SetScript("OnEvent", function(_, event, arg1, arg2)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        --dbg("Addon loaded and initialized.")
        return
    end

    if event == "PLAYER_ENTERING_WORLD" then
        -- local isInitialLogin = arg1
        -- local isReload = arg2
        -- local instanceName, instanceType, _, _, _, _, _, instanceID = GetInstanceInfo()

        -- dbg(("Entered world (instanceID=%s, name=%s, type=%s, initialLogin=%s, reload=%s)")
        --     :format(tostring(instanceID), tostring(instanceName), tostring(instanceType),
        --             tostring(isInitialLogin), tostring(isReload)))

        SetupRightClickBehavior()
    end
end)
