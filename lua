local function onChatted(message)
    local prefix = ".kill "
    if message:sub(1, #prefix) == prefix then
        local targetName = message:sub(#prefix + 1):lower() -- Convert to lowercase for case-insensitive comparison

        local function convertDisplayNameToUsername(displayName)
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.DisplayName:lower():find(displayName, 1, true) then
                    return player.Name
                end
            end
            return nil
        end

        if targetName == "all" then
            -- Loop through all players and execute the kill command
            for _, player in ipairs(game.Players:GetPlayers()) do
                local args = {
                    [1] = player.Character
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Kill"):FireServer(unpack(args))
            end
            return -- Exit the function since we've killed everyone
        end

        if targetName == "others" then
            local localPlayer = game.Players.LocalPlayer
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= localPlayer and player.Character then
                    local args = {
                        [1] = player.Character
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("Kill"):FireServer(unpack(args))
                end
            end
            return
        end

        if targetName == "random" then
            local alivePlayers = {}
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("Humanoid").Health > 0 then
                    table.insert(alivePlayers, player)
                end
            end

            if #alivePlayers > 0 then
                local randomPlayer = alivePlayers[math.random(#alivePlayers)]
                local args = {
                    [1] = randomPlayer.Character
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Kill"):FireServer(unpack(args))
            else
                print("No alive players to kill.")
            end

            return -- Exit the function since we've performed the random kill
        end

        if targetName == "me" then
            local localPlayer = game.Players.LocalPlayer
            if localPlayer.Character then
                local args = {
                    [1] = localPlayer.Character
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Kill"):FireServer(unpack(args))
            else
                print("You don't have a character to kill.")
            end
        end

        local targetPlayer
        for _, player in ipairs(game.Players:GetPlayers()) do
            if player.Name:lower():find(targetName, 1, true) then
                targetPlayer = player
                break
            end
        end

        if not targetPlayer then
            -- If the targetName is not a username, try finding it using convertDisplayNameToUsername
            targetPlayer = game.Players:FindFirstChild(convertDisplayNameToUsername(targetName))
        end

        if targetPlayer then
            local args = {
                [1] = targetPlayer.Character
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Kill"):FireServer(unpack(args))
        else
            print("Player not found.")
        end
    end
end

game:GetService("Players").LocalPlayer.Chatted:Connect(onChatted)


