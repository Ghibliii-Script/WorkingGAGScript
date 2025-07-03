local pets = {"Dragonfly", "Raccoon", "Fennec Fox", "Disco Bee", "Queen Bee"}
local selectedPet = pets[1]
local placeMode = false

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local rs = game:GetService("ReplicatedStorage")

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "PetSpawnerUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 180)
frame.Position = UDim2.new(0.7, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Active = true
frame.Draggable = true

local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, 0, 0, 30)
label.Text = "Pet Spawner"
label.TextColor3 = Color3.new(1, 1, 1)
label.BackgroundTransparency = 1

local petBtn = Instance.new("TextButton", frame)
petBtn.Size = UDim2.new(1, -20, 0, 30)
petBtn.Position = UDim2.new(0, 10, 0, 40)
petBtn.Text = "Pet: " .. selectedPet
petBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
petBtn.TextColor3 = Color3.new(1, 1, 1)

local function cyclePet()
    local i = table.find(pets, selectedPet)
    selectedPet = pets[i % #pets + 1]
    petBtn.Text = "Pet: " .. selectedPet
end

petBtn.MouseButton1Click:Connect(cyclePet)

local spawnBtn = Instance.new("TextButton", frame)
spawnBtn.Size = UDim2.new(1, -20, 0, 35)
spawnBtn.Position = UDim2.new(0, 10, 0, 80)
spawnBtn.Text = "Spawn"
spawnBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
spawnBtn.TextColor3 = Color3.new(1, 1, 1)

local function spawnPet(petName, pos)
    local folder = rs:FindFirstChild("Pets")
    if not folder then return end
    local pet = folder:FindFirstChild(petName)
    if pet then
        local clone = pet:Clone()
        clone.Parent = player.Character
        local part = clone:FindFirstChildWhichIsA("BasePart")
        if part then
            if pos then
                part.CFrame = CFrame.new(pos)
            else
                part.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(2, 0, 0)
            end
        end
    end
end

spawnBtn.MouseButton1Click:Connect(function()
    spawnPet(selectedPet)
end)

local placeBtn = Instance.new("TextButton", frame)
placeBtn.Size = UDim2.new(1, -20, 0, 30)
placeBtn.Position = UDim2.new(0, 10, 0, 125)
placeBtn.Text = "Placer: OFF"
placeBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 0)
placeBtn.TextColor3 = Color3.new(1, 1, 1)

placeBtn.MouseButton1Click:Connect(function()
    placeMode = not placeMode
    placeBtn.Text = "Placer: " .. (placeMode and "ON" or "OFF")
    placeBtn.BackgroundColor3 = placeMode and Color3.fromRGB(0, 120, 0) or Color3.fromRGB(120, 0, 0)
end)

mouse.Button1Down:Connect(function()
    if placeMode then
        local target = mouse.Hit
        if target then
            spawnPet(selectedPet, target.Position)
        end
    end
end)
