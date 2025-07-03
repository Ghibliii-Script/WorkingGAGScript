local isCooldown = false

spawnBtn.MouseButton1Click:Connect(function()
    if isCooldown then return end
    isCooldown = true

    spawnPet(selectedPet) -- call your pet spawn function here

    -- Start cooldown
    local timeLeft = 60
    spawnBtn.Text = "Wait (" .. timeLeft .. "s)"
    spawnBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

    while timeLeft > 0 do
        wait(1)
        timeLeft -= 1
        spawnBtn.Text = "Wait (" .. timeLeft .. "s)"
    end

    spawnBtn.Text = "Spawn"
    spawnBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 0)
    isCooldown = false
end)
