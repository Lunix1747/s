local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local p = Players.LocalPlayer
local pg = p:WaitForChild("PlayerGui")

local sg = Instance.new("ScreenGui")
sg.ResetOnSpawn = false
sg.Parent = pg

local f = Instance.new("Frame")
f.Size = UDim2.new(0, 500, 0, 220)
f.Position = UDim2.new(0.5, -250, 0.3, -110)
f.Active = true
f.Draggable = true
f.BackgroundColor3 = Color3.fromRGB(255, 170, 200)
f.BorderSizePixel = 0
f.Parent = sg

local ui = Instance.new("UICorner")
ui.CornerRadius = UDim.new(0, 20)
ui.Parent = f

local t = Instance.new("TextLabel")
t.Size = UDim2.new(1, -140, 0, 60)
t.Position = UDim2.new(0, 20, 0, 15)
t.BackgroundTransparency = 1
t.TextScaled = true
t.Font = Enum.Font.GothamBold
t.TextColor3 = Color3.new(1,1,1)
t.Text = ""
t.Parent = f

local b = Instance.new("TextButton")
b.Size = UDim2.new(0, 80, 0, 40)
b.Position = UDim2.new(1, -100, 0, 15)
b.BackgroundColor3 = Color3.fromRGB(255, 120, 160)
b.Text = "Copy"
b.TextScaled = true
b.Font = Enum.Font.GothamBold
b.TextColor3 = Color3.new(1,1,1)
b.BorderSizePixel = 0
b.Parent = f

local bui = Instance.new("UICorner")
bui.CornerRadius = UDim.new(0, 14)
bui.Parent = b

local sl = Instance.new("Frame")
sl.Size = UDim2.new(1, -40, 0, 40)
sl.Position = UDim2.new(0, 20, 0, 90)
sl.BackgroundColor3 = Color3.fromRGB(255, 140, 180)
sl.BorderSizePixel = 0
sl.Parent = f

local slc = Instance.new("UICorner")
slc.CornerRadius = UDim.new(0, 12)
slc.Parent = sl

local bar = Instance.new("Frame")
bar.Size = UDim2.new(0.115, 0,1,0)
bar.Position = UDim2.new(0,0,0,0)
bar.BackgroundColor3 = Color3.fromRGB(255, 100, 150)
bar.BorderSizePixel = 0
bar.Parent = sl

local barc = Instance.new("UICorner")
barc.CornerRadius = UDim.new(0,12)
barc.Parent = bar

local wpmt = Instance.new("TextLabel")
wpmt.Size = UDim2.new(0,100,0,40)
wpmt.Position = UDim2.new(1,-120,0,90)
wpmt.BackgroundTransparency = 1
wpmt.TextScaled = true
wpmt.Font = Enum.Font.GothamBold
wpmt.TextColor3 = Color3.new(1,1,1)
wpmt.Text = "23 WPM"
wpmt.Parent = f

local wpmInput = Instance.new("TextBox")
wpmInput.Size = UDim2.new(0,80,0,40)
wpmInput.Position = UDim2.new(1,-120,0,140)
wpmInput.BackgroundColor3 = Color3.fromRGB(255,120,160)
wpmInput.Text = ""
wpmInput.PlaceholderText = "200+"
wpmInput.TextScaled = true
wpmInput.Font = Enum.Font.GothamBold
wpmInput.TextColor3 = Color3.new(1,1,1)
wpmInput.BorderSizePixel = 0
wpmInput.ClearTextOnFocus = false
wpmInput.Parent = f

local inputUI = Instance.new("UICorner")
inputUI.CornerRadius = UDim.new(0,14)
inputUI.Parent = wpmInput

local dynToggle = Instance.new("TextButton")
dynToggle.Size = UDim2.new(0,120,0,40)
dynToggle.Position = UDim2.new(1,-220,0,140)
dynToggle.BackgroundColor3 = Color3.fromRGB(255,150,200)
dynToggle.Text = "Dynamic Typing: OFF"
dynToggle.TextScaled = true
dynToggle.Font = Enum.Font.GothamBold
dynToggle.TextColor3 = Color3.new(1,1,1)
dynToggle.BorderSizePixel = 0
dynToggle.Parent = f
local dynState = false

dynToggle.MouseButton1Click:Connect(function()
    dynState = not dynState
    dynToggle.Text = "Dynamic Typing: "..(dynState and "ON" or "OFF")
end)

local autoToggle = Instance.new("TextButton")
autoToggle.Size = UDim2.new(0,120,0,40)
autoToggle.Position = UDim2.new(0,20,0,140)
autoToggle.BackgroundColor3 = Color3.fromRGB(255,150,200)
autoToggle.Text = "Auto-Type: ON"
autoToggle.TextScaled = true
autoToggle.Font = Enum.Font.GothamBold
autoToggle.TextColor3 = Color3.new(1,1,1)
autoToggle.BorderSizePixel = 0
autoToggle.Parent = f
local autoState = true

autoToggle.MouseButton1Click:Connect(function()
    autoState = not autoState
    autoToggle.Text = "Auto-Type: "..(autoState and "ON" or "OFF")
end)

local v = ReplicatedStorage:WaitForChild("WordValue")
local wpm = 23
local draggingSlider = false
local typing = false
local lastTypedWord = ""

local function updateWPM(val)
    wpm = val
    wpmt.Text = val.." WPM"
end

local function updateSlider(x)
    local r = (x - sl.AbsolutePosition.X) / sl.AbsoluteSize.X
    r = math.clamp(r,0,1)
    bar.Size = UDim2.new(r,0,1,0)
    local newWpm = math.floor(10 + r*190)
    updateWPM(newWpm)
end

sl.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = true
        updateSlider(UserInputService:GetMouseLocation().X)
    end
end)

sl.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseMovement and draggingSlider then
        updateSlider(UserInputService:GetMouseLocation().X)
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingSlider = false
    end
end)

b.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(t.Text)
    end
end)

wpmInput.FocusLost:Connect(function(enterPressed)
    local inputVal = tonumber(wpmInput.Text)
    if inputVal and inputVal > 200 then
        updateWPM(inputVal)
        bar.Size = UDim2.new(1,0,1,0) -- Set slider to max
    elseif inputVal and inputVal >= 10 and inputVal <= 200 then
        -- If they enter a valid value within slider range, update slider
        local r = (inputVal - 10) / 190
        bar.Size = UDim2.new(r,0,1,0)
        updateWPM(inputVal)
    end
    wpmInput.Text = ""
end)

task.spawn(function()
    while true do
        t.Text = tostring(v.Value)
        task.wait(0.5)
    end
end)

task.spawn(function()
    while true do
        if not autoState then
            task.wait(0.3)
        else
            local gui = pg:FindFirstChild("Textbox")
            if gui and gui.Enabled then
                local tb = gui:FindFirstChild("TextBox")
                if tb and tb.Visible and tb.Active then
                    local str = t.Text
                    -- Only type if the word has changed
                    if not typing and str ~= lastTypedWord then
                        typing = true
                        tb.Text = ""
                        local baseDelay = 12 / math.max(wpm,1)
                        for i = 1, #str do
                            tb.Text = str:sub(1,i)
                            if dynState then
                                local minD = baseDelay*0.5
                                local maxD = baseDelay*1.5
                                task.wait(math.random()*(maxD-minD)+minD)
                            else
                                task.wait(baseDelay)
                            end
                        end
                        
                        -- Press Enter after typing is complete
                        task.wait(0.1)
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                        task.wait(0.05)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                        
                        -- Remember this word to avoid retyping
                        lastTypedWord = str
                        typing = false
                    end
                end
            end
        end
        task.wait(0.3)
    end
end)

local oldDrag = f.Draggable
f.Draggable = true
UserInputService.InputChanged:Connect(function()
    if draggingSlider then
        f.Draggable = false
    else
        f.Draggable = oldDrag
    end
end)
