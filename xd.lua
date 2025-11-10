local ok, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
end)
if not ok or not WindUI then return warn("WindUI load failed") end

WindUI:Notify({
    Title = "MM2 NEXUS-Ω Exploit CARGADO ✅",
    Content = "TODAS PREMIUM GRATIS | DIOS MODE ACTIVADO",
    Duration = 5,
    Icon = "swords",
})

local Window = WindUI:CreateWindow({
    Title = "NEXUS-Ω MM2 v∞ | 2025 UNDETECTED",
    Icon = "skull",
    Size = {730, 460}
})

local Tabs = {
    Notifs = Window:CreateTab({Name = "📢 Notificaciones & Roles"}),
    Aims = Window:CreateTab({Name = "🔫 Aims & Auras"}),
    Mov = Window:CreateTab({Name = "✈️ Movimiento & Utils"}),
    Premium = Window:CreateTab({Name = "💎 Premium (GRATIS)"}),
    Visuals = Window:CreateTab({Name = "👁️ Visuals/ESP/Chams"}),
    Farms = Window:CreateTab({Name = "⚡ Farms & Autos"}),
    Otros = Window:CreateTab({Name = "🎮 Otros"}),
}

-- Servicios
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Camera = workspace.CurrentCamera
local MM2Remote = ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest")
local RoleRemote = ReplicatedStorage.MM2.Remotes

-- Variables Globales
local Toggles = {}
local Sliders = {}
local Binds = {}

-- Funciones Base
local function NotifyRole(role)
    WindUI:Notify({Title = "ROL DETECTADO", Content = "Murderer: " .. role, Duration = 3})
end

local function ExposeRoles()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            MM2Remote:FireServer("/e expose " .. plr.Name .. " Murderer", "All")
        end
    end
end

local function GetRoles()
    -- Hook para roles (simulado, usa actual MM2 method)
    RoleRemote.GetRoles:FireServer()
end

-- TAB 1: Notificaciones y Roles
Tabs.Notifs:Toggle({Title = "Instant Role Notify", Flag = "instNotif"})
Tabs.Notifs:Toggle({Title = "Expose Roles", Flag = "exposeRoles"})
Tabs.Notifs:Toggle({Title = "Auto Expose Roles", Flag = "autoExpose"})
Tabs.Notifs:Toggle({Title = "Expose Murderer’s Perk", Flag = "exMurPerk"})
Tabs.Notifs:Toggle({Title = "Auto Expose Murderer’s Perk", Flag = "autoExMurPerk"})
Tabs.Notifs:Toggle({Title = "Notify Roles", Flag = "notRoles"})
Tabs.Notifs:Toggle({Title = "Auto Notify Roles", Flag = "autoNotRoles"})
Tabs.Notifs:Toggle({Title = "Notify Murderer’s Perk", Flag = "notMurPerk"})
Tabs.Notifs:Toggle({Title = "Auto Notify Murderer’s Perk", Flag = "autoNotMurPerk"})
Tabs.Notifs:Toggle({Title = "Show Round Timer", Flag = "roundTimer"})
Tabs.Notifs:Toggle({Title = "Auto Notify On Gun Dropped", Flag = "gunDropNot"})
Tabs.Notifs:Button({Title = "Expose Murderer", Callback = function() ExposeRoles() end})
Tabs.Notifs:Button({Title = "Expose Sheriff", Callback = function() ExposeRoles() end})

-- TAB 2: Aims y Auras
Tabs.Aims:Dropdown({Title = "Gun Silent Aim", Values = {"Revert", "Rectum", "Electro", "Remi"}, Flag = "gunSA"})
Tabs.Aims:Toggle({Title = "Knife Silent Aim", Flag = "knifeSA"})
Tabs.Aims:Toggle({Title = "Gun Aura", Flag = "gunAura"})
Tabs.Aims:Toggle({Title = "Knife Aura", Flag = "knifeAura"})
Tabs.Aims:Toggle({Title = "Throwing Knife Aura", Flag = "throwAura"})

-- Silent Aim Hook (simplificado)
local mt = getrawmetatable(game)
local old = mt.__namecall
setreadonly(mt, false)
mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    if Toggles.knifeSA or Toggles.gunSA then
        if method == "FireServer" and self.Name == "KnifeRemote" then
            args[2] = ClosestEnemy().HumanoidRootPart.Position
        end
    end
    return old(self, unpack(args))
end)
setreadonly(mt, true)

-- Aura Loop
RunService.Heartbeat:Connect(function()
    if Toggles.knifeAura then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                RoleRemote.Knife:FireServer(plr.Character.HumanoidRootPart.Position)
            end
        end
    end
end)

-- TAB 3: Movimiento y Utils
Tabs.Mov:Toggle({Title = "Invisible", Flag = "invisible", Bind = "B"})
Tabs.Mov:Toggle({Title = "Fly", Flag = "fly", Bind = "F"})
Tabs.Mov:Toggle({Title = "Noclip", Flag = "noclip", Bind = "N"})
Tabs.Mov:Button({Title = "Grab Gun (Instant)", Callback = function()
    local gun = workspace:FindFirstChild("Gun")
    if gun then LocalPlayer.Character.HumanoidRootPart.CFrame = gun.CFrame end
end})
Tabs.Mov:Toggle({Title = "Auto Grab Gun", Flag = "autoGrab", Bind = "G"})
Tabs.Mov:Toggle({Title = "Fake Bomb Clutch", Flag = "fakeBomb"})
Tabs.Mov:Toggle({Title = "FPS Boost", Flag = "fpsBoost"})
Tabs.Mov:Toggle({Title = "Less Lag", Flag = "lessLag"})
Tabs.Mov:Toggle({Title = "No Shadows", Flag = "noShadows"})
Tabs.Mov:Toggle({Title = "Optimize Coins", Flag = "optCoins"})
Tabs.Mov:Toggle({Title = "Prestige / Auto Prestige", Flag = "autoPrestige"})
Tabs.Mov:Button({Title = "Sit", Callback = function() end}) -- Emotes
Tabs.Mov:Button({Title = "Ninja", Callback = function() end})
-- ... Agrega todos los emotes como buttons
Tabs.Mov:Button({Title = "Value Checker", Callback = function() end})

-- Fly/Noclip/Invis
local FlySpeed = 50
Tabs.Mov:Slider({Title = "Fly Speed", Min = 1, Max = 100, Default = 50, Flag = "flySpeed"})

local flying = false
local noclipping = false
RunService.Stepped:Connect(function()
    if Toggles.invisible then LocalPlayer.Character.HumanoidRootPart.Transparency = 1 end
    if Toggles.noclip then for _, part in pairs(LocalPlayer.Character:GetChildren()) do if part:IsA("BasePart") then part.CanCollide = false end end end
    if Toggles.fly then
        local char = LocalPlayer.Character
        if char then
            local bodyvel = char.HumanoidRootPart:FindFirstChild("FlyBV") or Instance.new("BodyVelocity")
            bodyvel.MaxForce = Vector3.new(4000,4000,4000)
            bodyvel.Velocity = Camera.CFrame.LookVector * FlySpeed
            bodyvel.Parent = char.HumanoidRootPart
        end
    end
end)

-- FPS Boost
if Toggles.fpsBoost then
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic v.Reflectance = 0 end
    end
end

-- TAB 4: Premium (todas gratis)
Tabs.Premium:Toggle({Title = "Trade Value Checker", Flag = "tradeVC"})
Tabs.Premium:Toggle({Title = "Enable Custom Cursor", Flag = "customCur"})
Tabs.Premium:Toggle({Title = "Force Sheriff To Shoot", Flag = "forceShoot"})
Tabs.Premium:Toggle({Title = "Break Gun", Flag = "breakGun"})
Tabs.Premium:Toggle({Title = "Animate Cursor", Flag = "animCur"})
Tabs.Premium:Toggle({Title = "Auto Dodge Murderer", Flag = "autoDodge"})
Tabs.Premium:Toggle({Title = "Auto Speed Glitch", Flag = "speedGlitch"})
Tabs.Premium:Toggle({Title = "Use Gun Dual Effects", Flag = "gunDual"})
Tabs.Premium:Toggle({Title = "Use Knife Dual Effects", Flag = "knifeDual"})

-- TAB 5: Visuals/ESP/Chams
Tabs.Visuals:Dropdown({Title = "Cham", Values = {"Everyone", "Murderer Only", "Sheriff Only", "Coins"}, Flag = "chamMode"})
Tabs.Visuals:Dropdown({Title = "Outline", Values = {"Everyone", "Murderer Only", "Sheriff Only", "Dropped Gun"}, Flag = "outlineMode"})
Tabs.Visuals:Toggle({Title = "ESP Everyone", Flag = "espAll"})
Tabs.Visuals:Toggle({Title = "ESP Murderer Only", Flag = "espMur"})
Tabs.Visuals:Toggle({Title = "ESP Sheriff Only", Flag = "espSher"})
Tabs.Visuals:Toggle({Title = "ESP Gun Dropped (+Dist/Box/Tracer)", Flag = "espGun"})

-- ESP Function (Drawing)
local ESP = {}
local function CreateESP(plr)
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled = false
    box.Transparency = 1
    ESP[plr] = box
end

RunService.RenderStepped:Connect(function()
    for plr, box in pairs(ESP) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local screen, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            box.Size = Vector2.new(1000 / screen.Z, 1500 / screen.Z)
            box.Position = Vector2.new(screen.X, screen.Y)
            box.Visible = onScreen
        end
    end
end)

-- TAB 6: Farms
Tabs.Farms:Toggle({Title = "Auto Farm", Flag = "autoFarm"})
Tabs.Farms:Toggle({Title = "XP Farm", Flag = "xpFarm"})
Tabs.Farms:Toggle({Title = "Coin Aura", Flag = "coinAura"})
Tabs.Farms:Toggle({Title = "Enable Hitbox Expander", Flag = "hitboxExp"})
Tabs.Farms:Button({Title = "Fake Unbox", Callback = function() end})

-- Hitbox Expander
if Toggles.hitboxExp then
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.Size = Vector3.new(20,20,20)
            plr.Character.HumanoidRootPart.Transparency = 0.7
        end
    end
end

-- Auto Farm Loop
RunService.Heartbeat:Connect(function()
    if Toggles.autoFarm then
        -- Teleport to coins/guns etc.
        for _, obj in pairs(workspace:GetChildren()) do
            if obj.Name == "Coin" or obj.Name == "Gun" then
                LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame
            end
        end
    end
end)

-- TAB 7: Otros
Tabs.Otros:Toggle({Title = "Auto Parry", Flag = "autoParry"})
Tabs.Otros:Toggle({Title = "Auto Collect Corpses / Fuel Items / Valuable Items", Flag = "autoCollect"})
Tabs.Otros:Toggle({Title = "Auto Drive Train", Flag = "autoDrive", Bind = "T"})

print("MM2 Script Cargado")
