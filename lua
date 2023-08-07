-- Function to handle player chat
local function onChatted(message)
    local prefix = ".kill "
    if message:sub(1, #prefix) == prefix then
        local targetName = message:sub(#prefix + 1):lower() -- Convert to lowercase for case-insensitive comparison

        -- Function to find a player by display name and return the corresponding username
        local function convertDisplayNameToUsername(displayName)
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player.DisplayName:lower():find(displayName, 1, true) then
                    return player.Name
                end
            end
            return nil
        end

        -- Check if the user wants to kill everyone in the server
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

        -- Check if the user wants to kill themselves
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

        -- Convert the display name to the corresponding username
        local targetUsername = convertDisplayNameToUsername(targetName)

        -- Execute the desired code when a player is found
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
