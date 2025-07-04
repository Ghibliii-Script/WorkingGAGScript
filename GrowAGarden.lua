local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 🌟 LOADING SCREEN
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "LoadingScreen"
loadingGui.IgnoreGuiInset = true
loadingGui.ResetOnSpawn = false
loadingGui.Parent = playerGui

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.new(0, 0, 0)
bg.Parent = loadingGui

local music = Instance.new("Sound")
music.SoundId = "rbxassetid://1843521514"
music.Looped = true
music.Volume = 1
music.Parent = bg
music:Play()

local raccoonPic = Instance.new("ImageLabel")
raccoonPic.Size = UDim2.new(0, 140, 0, 140)
raccoonPic.Position = UDim2.new(0.5, -70, 0.18, 0)
raccoonPic.BackgroundTransparency = 1
raccoonPic.Image = "rbxassetid://16017608809"
raccoonPic.Parent = bg

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0.1, 0)
loadingText.Position = UDim2.new(0, 0, 0.4, 0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "🌿 Loading Garden Assets..."
loadingText.TextColor3 = Color3.new(1, 1, 1)
loadingText.TextScaled = true
loadingText.Font = Enum.Font.SourceSansBold
loadingText.Parent = bg

local barBackground = Instance.new("Frame")
barBackground.Size = UDim2.new(0.6, 0, 0.04, 0)
barBackground.Position = UDim2.new(0.2, 0, 0.55, 0)
barBackground.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
barBackground.BorderSizePixel = 0
barBackground.Parent = bg

local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(90, 200, 120)
progressBar.BorderSizePixel = 0
progressBar.Parent = barBackground

local skip = false
local skipBtn = Instance.new("TextButton")
skipBtn.Size = UDim2.new(0, 100, 0, 30)
skipBtn.Position = UDim2.new(0.5, -50, 0.65, 0)
skipBtn.Text = "⏭️ Skip"
skipBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
skipBtn.TextColor3 = Color3.new(1,1,1)
skipBtn.TextScaled = true
skipBtn.Font = Enum.Font.SourceSansBold
skipBtn.Parent = bg

skipBtn.MouseButton1Click:Connect(function()
	skip = true
end)

for i = 1, 100 do
	if skip then break end
	progressBar.Size = UDim2.new(i / 100, 0, 1, 0)
	task.wait(0.05)
end

for i = 1, 10 do
	bg.BackgroundTransparency = i / 10
	loadingText.TextTransparency = i / 10
	raccoonPic.ImageTransparency = i / 10
	progressBar.BackgroundTransparency = i / 10
	barBackground.BackgroundTransparency = i / 10
	skipBtn.TextTransparency = i / 10
	task.wait(0.05)
end

music:Stop()
loadingGui:Destroy()

-- 🐾 PET SPAWNER GUI

local pets = {
	["Dragonfly"] = "rbxassetid://14861886059",
	["Raccoon"] = "rbxassetid://14861933542",
	["Fennec Fox"] = "rbxassetid://14861920556",
	["Disco Bee"] = "rbxassetid://14861901753",
	["Queen Bee"] = "rbxassetid://14861897800",
}

local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "PetSpawner"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0.5, -110, 0.5, -60)
frame.BackgroundColor3 = Color3.fromRGB(60, 130, 80)
frame.Active = true
frame.Draggable = true

local dropdown = Instance.new("TextButton", frame)
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 10)
dropdown.Text = "Select Pet"
dropdown.TextScaled = true
dropdown.BackgroundColor3 = Color3.fromRGB(90, 170, 100)

local spawnButton = Instance.new("TextButton", frame)
spawnButton.Size = UDim2.new(1, -20, 0, 30)
spawnButton.Position = UDim2.new(0, 10, 0, 50)
spawnButton.Text = "🧸 Spawn Selected Pet"
spawnButton.TextScaled = true
spawnButton.BackgroundColor3 = Color3.fromRGB(80, 200, 120)

local selectedPet = nil
local cooldown = false
local cooldownTime = 60
local dropdownOpen = false
local petOptions = {}

-- 🧾 Dropdown
dropdown.MouseButton1Click:Connect(function()
	if dropdownOpen then
		for _, opt in pairs(petOptions) do opt:Destroy() end
		petOptions = {}
		dropdownOpen = false
	else
		local y = 90
		for name in pairs(pets) do
			local option = Instance.new("TextButton", frame)
			option.Size = UDim2.new(1, -20, 0, 25)
			option.Position = UDim2.new(0, 10, 0, y)
			option.Text = name
			option.BackgroundColor3 = Color3.fromRGB(110, 180, 110)
			option.TextScaled = true
			option.MouseButton1Click:Connect(function()
				selectedPet = name
				dropdown.Text = "Selected: " .. name
				for _, opt in pairs(petOptions) do opt:Destroy() end
				petOptions = {}
				dropdownOpen = false
			end)
			table.insert(petOptions, option)
			y = y + 28
		end
		dropdownOpen = true
	end
end)

-- 🐾 Spawn Pet Function
local function spawnPet(name)
	local id = pets[name]
	local pet = Instance.new("Part", workspace)
	pet.Name = name
	pet.Shape = Enum.PartType.Ball
	pet.Size = Vector3.new(2, 2, 2)
	pet.Anchored = false
	pet.CanCollide = false
	pet.Color = Color3.fromRGB(255, 255, 150)
	pet.Material = Enum.Material.Neon

	local mesh = Instance.new("SpecialMesh", pet)
	mesh.MeshType = Enum.MeshType.FileMesh
	mesh.MeshId = "rbxassetid://85612143"
	mesh.TextureId = id
	mesh.Scale = Vector3.new(2, 2, 2)

	local run = game:GetService("RunService")
	local followConn

	followConn = run.Heartbeat:Connect(function()
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local root = player.Character.HumanoidRootPart
			local targetPos = root.Position + Vector3.new(2, 0, 2)
			pet.Position = pet.Position:Lerp(targetPos, 0.15)
		end
	end)

	player.CharacterRemoving:Connect(function()
		if followConn then followConn:Disconnect() end
		pet:Destroy()
	end)
end

-- 🕒 Cooldown Spawn Button
spawnButton.MouseButton1Click:Connect(function()
	if cooldown then return end

	if not selectedPet then
		spawnButton.Text = "❌ Select a Pet!"
		task.wait(2)
		spawnButton.Text = "🧸 Spawn Selected Pet"
		return
	end

	cooldown = true
	spawnPet(selectedPet)

	for i = cooldownTime, 1, -1 do
		spawnButton.Text = "⏳ " .. i .. " SECONDS"
		task.wait(1)
	end

	spawnButton.Text = "🧸 Spawn Selected Pet"
	cooldown = false
end)
