
-- Da Hood | Stealth Legit Aim Hub (Xeno + GitHub Style Compatible)
-- PC Only! Clean GUI with Legit Aim Assist and TriggerBot

local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
    Name = "Da Hood | Stealth Legit Aim",
    HidePremium = false,
    SaveConfig = false,
    IntroText = "PC Only | Legit Aim + TriggerBot"
})

-- Variables
getgenv().SilentAim = false
getgenv().TriggerBot = false
getgenv().TargetPart = "Head"
getgenv().Smoothness = 0.15
getgenv().AimKey = Enum.KeyCode.Q

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- FOV Circle
local Circle = Drawing.new("Circle")
Circle.Color = Color3.fromRGB(0, 255, 0)
Circle.Thickness = 1
Circle.Radius = 120
Circle.Filled = false
Circle.Visible = true

RunService.RenderStepped:Connect(function()
    Circle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
end)

-- Get Closest Target
local function getClosest()
    local closest, dist = nil, math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(getgenv().TargetPart) then
            local pos, onscreen = Camera:WorldToScreenPoint(player.Character[getgenv().TargetPart].Position)
            local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if onscreen and mag < dist and mag < Circle.Radius then
                closest = player
                dist = mag
            end
        end
    end
    return closest
end

-- Legit Aim Assist
spawn(function()
    while true do
        if getgenv().SilentAim and UserInputService:IsKeyDown(getgenv().AimKey) then
            local target = getClosest()
            if target and target.Character and target.Character:FindFirstChild(getgenv().TargetPart) then
                local pos = Camera:WorldToViewportPoint(target.Character[getgenv().TargetPart].Position)
                mousemoverel((pos.X - Mouse.X) * getgenv().Smoothness, (pos.Y - Mouse.Y) * getgenv().Smoothness)
            end
        end
        task.wait(0.01)
    end
end)

-- TriggerBot
spawn(function()
    while true do
        if getgenv().TriggerBot and UserInputService:IsKeyDown(getgenv().AimKey) then
            local target = getClosest()
            if target then
                mouse1click()
            end
        end
        task.wait(0.02)
    end
end)

-- GUI Tabs
local CombatTab = Window:MakeTab({
    Name = "Combat",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local VisualTab = Window:MakeTab({
    Name = "Visuals",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Toggles and Controls
CombatTab:AddToggle({
    Name = "Legit Aim Assist (Hold Q)",
    Default = false,
    Callback = function(Value)
        getgenv().SilentAim = Value
    end
})

CombatTab:AddToggle({
    Name = "TriggerBot (Auto Fire)",
    Default = false,
    Callback = function(Value)
        getgenv().TriggerBot = Value
    end
})

CombatTab:AddDropdown({
    Name = "Target Part",
    Default = "Head",
    Options = {"Head", "HumanoidRootPart"},
    Callback = function(Value)
        getgenv().TargetPart = Value
    end
})

CombatTab:AddSlider({
    Name = "Aim Assist Smoothness",
    Min = 0.05,
    Max = 0.3,
    Default = 0.15,
    Increment = 0.01,
    Callback = function(Value)
        getgenv().Smoothness = Value
    end
})

VisualTab:AddToggle({
    Name = "Show FOV Circle",
    Default = true,
    Callback = function(Value)
        Circle.Visible = Value
    end
})

VisualTab:AddSlider({
    Name = "FOV Radius",
    Min = 50,
    Max = 300,
    Default = 120,
    Increment = 10,
    Callback = function(Value)
        Circle.Radius = Value
    end
})

OrionLib:Init()
