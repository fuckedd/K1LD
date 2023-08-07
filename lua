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

        local targetUsername = convertDisplayNameToUsername(targetName)

        if targetUsername then
            local args = {
                [1] = game.Players:FindFirstChild(targetUsername).Character
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Kill"):FireServer(unpack(args))
        else
            print("Player not found.")
        end
    end
end

game:GetService("Players").LocalPlayer.Chatted:Connect(onChatted)
