local pets = {"Dragonfly", "Raccoon", "Fennec Fox", "Disco Bee", "Queen Bee", "Night Owl"}
local selectedPet = pets[1]

local player = game.Players.LocalPlayer
local rs = game:GetService("ReplicatedStorage")
local mouse = player:GetMouse()

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "DupeSpawnerUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.7, 0, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Dupe Pet Spawner"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1

local petBtn = Instance.new("TextButton", frame)
petBtn.Size = UDim2.new(1, -20, 0, 30)
petBtn.Position = UDim2.new(0, 10, 0, 35)
petBtn.Text = "Pet: " .. selectedPet
petBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
petBtn.TextColor3 = Color3.new(1, 1, 1)

petBtn.MouseButton1Click:Connect(function()
    local i = table.find(pets, selectedPet)
    selectedPet = pets[i % #pets + 1]
    petBtn.Text = "Pet: " .. selectedPet
end)

local spawnBtn = Instance.new("TextButton", frame)
spawnBtn.Size = UDim2.new(1, -20, 0, 35)
spawnBtn.Position = UDim2.new(0, 10, 0, 75)
spawnBtn.Text = "Duplicate"
spawnBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
spawnBtn.TextColor3 = Color3.new(1, 1, 1)

local function duplicatePet(petName)
    local folder = rs:FindFirstChild("Pets")
    if not folder then
        warn("❌ No 'Pets' folder in ReplicatedStorage.")
        return
    end

    local pet = folder:FindFirstChild(petName)
    if not pet then
        warn("❌ Pet not found:", petName)
        return
    end

    local clone = pet:Clone()
    clone.Parent = player.Character

    if not clone.PrimaryPart then
        local base = clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChildWhichIsA("BasePart")
        if base then
            clone.PrimaryPart = base
        else
            warn("❌ No base part in pet:", petName)
            return
        end
    end

    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        clone:SetPrimaryPartCFrame(root.CFrame * CFrame.new(math.random(2, 5), 0, math.random(2, 5)))
        print("✅ Spawned pet:", petName)
    end
end

spawnBtn.MouseButton1Click:Connect(function()
    duplicatePet(selectedPet)
end)
