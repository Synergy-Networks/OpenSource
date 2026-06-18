local API
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = cloneref(game:GetService("CoreGui"))
local ExperienceService = game:GetService("ExperienceService")
local Players = game:GetService("Players")

local RemoveErrorPrompts = true
local IterationSpeed = 0.25
local ExcludeFullServers = true
local SaveTeleportAttempts = false

API = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"

if RemoveErrorPrompts then
    pcall(function()
        CoreGui:WaitForChild("RobloxGui"):WaitForChild("Modules"):WaitForChild("ErrorPrompt"):Destroy()
    end)

    pcall(function()
        CoreGui.RobloxPromptGui:Destroy()
    end)
end

while true do
    local Executor = ""

    pcall(function()
        Executor = string.lower(tostring(identifyexecutor()))
    end)

    if not isfile("Servers.JSON") then
        writefile("Servers.JSON", game:HttpGet(API .. "&excludeFullGames=" .. tostring(ExcludeFullServers)))
    end

    local Success, JSONData = pcall(function()
        return HttpService:JSONDecode(readfile("Servers.JSON"))
    end)

    if not Success or type(JSONData) ~= "table" or JSONData.gameId ~= game.PlaceId then
        local MainPage = game:HttpGet(API .. "&excludeFullGames=" .. tostring(ExcludeFullServers))

        local DecodeSuccess, Decoded = pcall(function()
            return HttpService:JSONDecode(MainPage)
        end)

        if DecodeSuccess and Decoded and Decoded.data then
            Decoded.gameId = game.PlaceId
            writefile("Servers.JSON", HttpService:JSONEncode(Decoded))
            JSONData = Decoded
        else
            task.wait(IterationSpeed)
            continue
        end
    end

    if not JSONData.data or #JSONData.data < 1 then
        if JSONData.nextPageCursor then
            local NextPage = game:HttpGet(API .. "&excludeFullGames=" .. tostring(ExcludeFullServers) .. "&cursor=" .. JSONData.nextPageCursor)

            local DecodeSuccess, Decoded = pcall(function()
                return HttpService:JSONDecode(NextPage)
            end)

            if DecodeSuccess and Decoded and Decoded.data then
                Decoded.gameId = game.PlaceId
                writefile("Servers.JSON", HttpService:JSONEncode(Decoded))
                JSONData = Decoded
            else
                task.wait(IterationSpeed)
                continue
            end
        else
            delfile("Servers.JSON")
            task.wait(IterationSpeed)
            continue
        end
    end

    for I = #JSONData.data, 1, -1 do
        local Server = JSONData.data[I]
        local JobId = Server and Server.id

        table.remove(JSONData.data, I)
        writefile("Servers.JSON", HttpService:JSONEncode(JSONData))

        if JobId and JobId ~= game.JobId then
            if SaveTeleportAttempts then
                appendfile("Attempts.txt", JobId .. "\n")
            end

            if Executor ~= "potassium" then
                local LaunchSuccess = pcall(function()
                    ExperienceService:LaunchExperience({
                        placeId = game.PlaceId,
                        gameInstanceId = JobId,
                    })
                end)

                if not LaunchSuccess then
                    TeleportService:TeleportToPlaceInstance(
                        game.PlaceId,
                        JobId,
                        Players.LocalPlayer
                    )
                end
            else
                TeleportService:TeleportToPlaceInstance(
                    game.PlaceId,
                    JobId,
                    Players.LocalPlayer
                )
            end

            task.wait(IterationSpeed)
        end
    end

    task.wait(IterationSpeed)
end
