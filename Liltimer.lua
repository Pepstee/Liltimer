-- InstanceTimer.lua

-- Create a frame object
local frame = CreateFrame("Frame")

-- Initialize variables
local timer = 0                   -- Variable to store the elapsed time
local inInstance = false          -- Flag to track whether the player is in an instance or not
local timerFrame                  -- Variable to hold the timer frame object

-- Function to update the timer
local function UpdateTimer(self, elapsed)
    if inInstance then            -- Check if the player is inside an instance
        timer = timer + elapsed   -- Increment the timer by the elapsed time
        if timerFrame then        -- Check if the timer frame exists
            timerFrame.text:SetText("Timer: " .. SecondsToTime(timer))  -- Update the timer frame text with elapsed time
        end
    end
end

-- Function to create and initialize the timer frame
local function CreateTimerFrame()
  timerFrame = CreateFrame("Frame", "InstanceTimerFrame", UIParent)  -- Create a frame for the timer
  timerFrame:SetSize(200, 50)                                       -- Set size of the timer frame
  timerFrame:SetPoint("RIGHT", UIParent, "RIGHT", -20, 0)            -- Set position of the timer frame
  timerFrame:SetBackdrop({                                           -- Set backdrop for the timer frame
      bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",     -- Background texture
      edgeFile = "Interface\\AddOns\\YourAddon\\custom-border",       -- Border texture
      edgeSize = 16,                                                  -- Border size
      insets = { left = 4, right = 4, top = 4, bottom = 4 }           -- Insets
  })
  timerFrame:SetBackdropColor(0, 0, 0, 0.7)                           -- Set background color
  timerFrame:SetBackdropBorderColor(1, 1, 1, 1)                       -- Set border color

  -- Text
  timerFrame.text = timerFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")  -- Create text object for timer
  timerFrame.text:SetPoint("CENTER", timerFrame, "CENTER", 0, 0)      -- Set position of the text
  timerFrame.text:SetFont("Fonts\\nimrod.ttf", 20, "OUTLINE")         -- Set font for the text
  timerFrame.text:SetText("Timer: 0:00")                              -- Set initial text

  -- Enable dragging
  timerFrame:SetMovable(true)                                         -- Allow frame to be moved
  timerFrame:EnableMouse(true)                                         -- Enable mouse interaction
  timerFrame:SetScript("OnMouseDown", function(self, button)           -- Set script for mouse down event
      if button == "LeftButton" then
          self:StartMoving()                                           -- Start moving the frame
      end
  end)
  timerFrame:SetScript("OnMouseUp", function(self, button)             -- Set script for mouse up event
      if button == "LeftButton" then
          self:StopMovingOrSizing()                                    -- Stop moving the frame
      end
  end)
end

-- Event handler for entering and leaving instances
frame:RegisterEvent("PLAYER_ENTERING_WORLD")                           -- Register event for player entering world
--- frame:RegisterEvent("PLAYER_LEAVE_COMBAT")                             -- Register event for player leaving combat
frame:SetScript("OnEvent", function(self, event, ...)
    local _, instanceType = IsInInstance()                             -- Check if the player is in an instance
    if instanceType == "raid" or instanceType == "party" then          -- If in raid or party instance
        inInstance = true                                               -- Set inInstance flag to true
        if event == "PLAYER_ENTERING_WORLD" then                       -- If entering world event
            print("Entered instance. Starting timer...")               -- Print message
            timer = 0                                                   -- Reset timer
            CreateTimerFrame()                                          -- Create timer frame
            timerFrame:SetScript("OnUpdate", UpdateTimer)              -- Start updating the timer
            inInstance = false                                          -- Set inInstance flag to false
            timerFrame:SetScript("OnUpdate", nil)                      -- Stop updating the timer
            if timerFrame then
                timerFrame:Hide()                                      -- Hide the timer frame
            end
        end
    else
        inInstance = false                                              -- Set inInstance flag to false
    end
end)
