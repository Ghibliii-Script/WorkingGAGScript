-- Grow A Garden Pet Spawner with GUI + Animation + Cooldown
-- yt acc: @onlyhanzuuuuu

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Remote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SpawnPet")
local player = Players.LocalPlayer

local pets = {
    "Dragonfly",
    "Raccoon",
    "Disco Bee",
    "Fennec Fox",
    "Queen Bee",
    "Red Fox"
}

local cooldown = 120
local canSpawn = true

-- GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "PetGUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 100)
frame.Position = UDim2.new(0.5, -110, 0.8, 0)
frame.BackgroundTransparency = 1
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0, 200, 0, 50)
button.Position = UDim2.new(0.5, -100, 0, 5)
button.Text = "Spawn Pet"
button.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 24

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(0, 200, 0, 30)
label.Position = UDim2.new(0.5, -100, 0, 60)
label.BackgroundTransparency = 1
label.Text = ""
label.TextColor3 = Color3.new(1, 0, 0)
label.Font = Enum.Font.SourceSans
label.TextSize = 18

-- Animation: Fade in GUI
frame.BackgroundTransparency = 1
button.TextTransparency = 1
label.TextTransparency = 1

local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
TweenService:Create(frame, tweenInfo, {BackgroundTransparency = 0.2}):Play()
TweenService:Create(button, tweenInfo, {TextTransparency = 0}):Play()
TweenService:Create(label, tweenInfo, {TextTransparency = 0}):Play()

-- Click to spawn pet
button.MouseButton1Click:Connect(function()
    if canSpawn then
        canSpawn = false
        local randomPet = pets[math.random(1, #pets)]
        Remote:FireServer(randomPet)
        button.Text = "Cooldown"
        for i = cooldown, 1, -1 do
            label.Text = "Wait: " .. i .. "s"
            wait(1)
        end
        label.Text = ""
        button.Text = "Spawn Pet"
        canSpawn = true
    end
end)
