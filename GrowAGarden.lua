local player = game.Players.LocalPlayer
local pets = {
	["Dragonfly"] = "rbxassetid://14861886059",
	["Raccoon"] = "rbxassetid://14861933542",
	["Fennec Fox"] = "rbxassetid://14861920556",
	["Disco Bee"] = "rbxassetid://14861901753",
	["Queen Bee"] = "rbxassetid://14861897800",
}

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
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

-- Dropdown logic
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

-- Pet follow code
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

-- Cooldown w/ countdown
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
