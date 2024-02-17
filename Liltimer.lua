-- InstanceTimer.lua

local frame = CreateFrame("Frame")
local timer = 0
local inInstance = false
local timerFrame
local blackRectangle

-- Function to update the timer
local function UpdateTimer(elapsed)
    if inInstance then
        timer = timer + elapsed
        timerFrame.text:SetText("Timer: " .. math.floor(timer))
    end
end

-- Function to create and initialize the timer frame
local function CreateTimerFrame()
    timerFrame = CreateFrame("Frame", "InstanceTimerFrame", UIParent, "BackdropTemplate")
    timerFrame:SetSize(200, 50)
    timerFrame:SetPoint("CENTER", UIParent, "CENTER")
    timerFrame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    timerFrame:SetBackdropColor(0, 0, 0, 0.7) -- Black backdrop with 70% opacity
    timerFrame:SetBackdropBorderColor(1, 1, 1, 1) -- White border with full opacity

    -- Text
    timerFrame.text = timerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    timerFrame.text:SetAllPoints(timerFrame)
end

-- Function to create and initialize the black rectangle
local function CreateBlackRectangle()
    blackRectangle = CreateFrame("Frame", "BlackRectangle", UIParent)
    blackRectangle:SetAllPoints(UIParent)
    blackRectangle:SetFrameLevel(0) -- Set the frame level below other UI elements
    blackRectangle:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8x8"
    })
    blackRectangle:SetBackdropColor(0, 0, 0, 1) -- Black color with full opacity
    blackRectangle:Show() -- Ensure the black rectangle is visible
end

-- Event handler for entering and leaving instances
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_LEAVE_COMBAT")
frame:SetScript("OnEvent", function(self, event, ...)
    local _, instanceType = IsInInstance()
    if instanceType == "raid" or instanceType == "party" then
        inInstance = true
        if event == "PLAYER_ENTERING_WORLD" then
            print("Entered instance. Starting timer...")
            timer = 0 -- Reset timer to 0 upon entering the instance
            CreateTimerFrame() -- Create the timer frame
            frame:SetScript("OnUpdate", UpdateTimer)
        elseif event == "PLAYER_LEAVE_COMBAT" then
            print("Left instance. Stopping timer...")
            inInstance = false
            frame:SetScript("OnUpdate", nil)
            if timerFrame then
                timerFrame:Hide() -- Hide the timer frame when leaving the instance
            end
        end
    else
        inInstance = false -- Ensure inInstance is false outside of instances
    end
end)

-- Create the black rectangle when the addon is loaded
CreateBlackRectangle()
