-- منع تكرار السكربت
if game.CoreGui:FindFirstChild("OsamaIntro") then game.CoreGui.OsamaIntro:Destroy() end
if game.CoreGui:FindFirstChild("OsamaMain") then game.CoreGui.OsamaMain:Destroy() end

local player = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")

-- 1. واجهة البداية (BY OSAMA) - شاشة كاملة
local SplashGui = Instance.new("ScreenGui")
SplashGui.Name = "OsamaIntro"
SplashGui.Parent = game.CoreGui
SplashGui.IgnoreGuiInset = true

local Background = Instance.new("Frame")
Background.Size = UDim2.new(1, 0, 1, 0)
Background.BackgroundColor3 = Color3.new(0, 0, 0)
Background.Parent = SplashGui
Background.ZIndex = 100

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.LuckiestGuy
Title.Text = "BY OSAMA"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextScaled = true
Title.Parent = Background
Title.ZIndex = 101

-- إضافة الموسيقى الحماسية جداً (Sahara - Phonk)
local Sound = Instance.new("Sound", Background)
Sound.SoundId = "rbxassetid://12140417242" -- هذه الأغنية هي الأشهر في السكربتات
Sound.Volume = 5 -- صوت قوي جداً
Sound.PlayOnRemove = false

-- تشغيل الموسيقى مع تأثير اهتزاز للنص
task.spawn(function()
    Sound:Play()
    local startTime = tick()
    while tick() - startTime < 10 do -- تستمر 15 ثانية
        Title.Rotation = math.random(-2, 2) -- اهتزاز خفيف حماسي
        task.wait(0.05)
    end
    
    -- التلاشي بعد الـ 15 ثانية
    for i = 0, 1, 0.05 do
        Background.BackgroundTransparency = i
        Title.TextTransparency = i
        Sound.Volume = (1 - i) * 5
        task.wait(0.05)
    end
    SplashGui:Destroy()
end)

-------------------------------------------------------
-- 2. واجهة التحكم (Auto Play)
-------------------------------------------------------
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "OsamaMain"
MainGui.Parent = game.CoreGui
MainGui.ResetOnSpawn = false

local MainButton = Instance.new("TextButton")
MainButton.Size = UDim2.new(0, 150, 0, 50)
MainButton.Position = UDim2.new(0.5, -75, 0.5, -25)
MainButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainButton.Text = "Auto Play: OFF"
MainButton.TextColor3 = Color3.new(1, 1, 1)
MainButton.Font = Enum.Font.SourceSansBold
MainButton.TextSize = 20
MainButton.Parent = MainGui
Instance.new("UICorner", MainButton).CornerRadius = UDim.new(0, 12)

local LockButton = Instance.new("TextButton")
LockButton.Size = UDim2.new(0, 80, 0, 35)
LockButton.Position = UDim2.new(0.9, -90, 0.05, 0)
LockButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
LockButton.Text = "Unlock"
LockButton.TextColor3 = Color3.new(1, 1, 1)
LockButton.Parent = MainGui
Instance.new("UICorner", LockButton).CornerRadius = UDim.new(0, 8)

-- المتغيرات والتحكم
local running, canDrag, speed = false, false, 35

-- نظام السحب الذكي
local dragging, dragStart, startPos
MainButton.InputBegan:Connect(function(input)
    if canDrag and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragging, dragStart, startPos = true, input.Position, MainButton.Position
    end
end)

userInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

userInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

LockButton.MouseButton1Click:Connect(function()
    canDrag = not canDrag
    LockButton.Text = canDrag and "Lock" or "Unlock"
    LockButton.BackgroundColor3 = canDrag and Color3.fromRGB(0, 180, 0) or Color3.fromRGB(180, 0, 0)
end)

-- نظام التتبع لـ Time Bomb
local function getNearest()
    local target, dist = nil, math.huge
    for _, v in pairs(game.Players:GetPlayers()) do
        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            local d = (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then dist, target = d, v end
        end
    end
    return target
end

MainButton.MouseButton1Click:Connect(function()
    running = not running
    MainButton.Text = running and "Auto Play: ON" or "Auto Play: OFF"
    MainButton.BackgroundColor3 = running and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(30, 30, 30)
end)

runService.Heartbeat:Connect(function()
    if running and player.Character and player.Character:FindFirstChild("Humanoid") then
        local target = getNearest()
        player.Character.Humanoid.WalkSpeed = speed
        if target and target.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.Humanoid:MoveTo(target.Character.HumanoidRootPart.Position)
        end
    end
end)
