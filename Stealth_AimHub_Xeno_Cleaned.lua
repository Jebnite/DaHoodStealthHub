
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

getgenv().SilentAim = false
getgenv().TriggerBot = false
getgenv().TargetPart = "Head"
getgenv().Smoothness = 0.15
getgenv().AimKey = Enum.KeyCode.Q

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "StealthLegitHub"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0.1, 0, 0.2, 0)
Frame.Size = UDim2.new(0, 250, 0, 160)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Frame)
Title.Text = "Legit Stealth Hub"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

local AimBtn = Instance.new("TextButton", Frame)
AimBtn.Position = UDim2.new(0, 10, 0, 40)
AimBtn.Size = UDim2.new(0, 230, 0, 30)
AimBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AimBtn.Text = "Toggle Aim Assist: OFF"
AimBtn.TextColor3 = Color3.new(1, 1, 1)
AimBtn.Font = Enum.Font.Gotham
AimBtn.TextSize = 14

AimBtn.MouseButton1Click:Connect(function()
    getgenv().SilentAim = not getgenv().SilentAim
    AimBtn.Text = "Toggle Aim Assist: " .. (getgenv().SilentAim and "ON" or "OFF")
end)

local TriggerBtn = Instance.new("TextButton", Frame)
TriggerBtn.Position = UDim2.new(0, 10, 0, 80)
TriggerBtn.Size = UDim2.new(0, 230, 0, 30)
TriggerBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TriggerBtn.Text = "Toggle TriggerBot: OFF"
TriggerBtn.TextColor3 = Color3.new(1, 1, 1)
TriggerBtn.Font = Enum.Font.Gotham
TriggerBtn.TextSize = 14

TriggerBtn.MouseButton1Click:Connect(function()
    getgenv().TriggerBot = not getgenv().TriggerBot
    TriggerBtn.Text = "Toggle TriggerBot: " .. (getgenv().TriggerBot and "ON" or "OFF")
end)

local Circle = Drawing.new("Circle")
Circle.Color = Color3.fromRGB(0, 255, 0)
Circle.Thickness = 1
Circle.Radius = 120
Circle.Filled = false
Circle.Visible = true

RunService.RenderStepped:Connect(function()
    Circle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
end)

local function getClosest()
    local closest, dist = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(getgenv().TargetPart) then
            local pos, onscreen = Camera:WorldToScreenPoint(p.Character[getgenv().TargetPart].Position)
            local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if onscreen and mag < dist and mag < Circle.Radius then
                closest = p
                dist = mag
            end
        end
    end
    return closest
end

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
