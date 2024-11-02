repeat task.wait() until game:IsLoaded()

local TextChatService, TeleportService = game:GetService("TextChatService"), game:GetService("TeleportService")
local isModern = (TextChatService.ChatVersion == Enum.ChatVersion.TextChatService)

if isModern then
    local channel = TextChatService.TextChannels["RBXGeneral"]
    for i = 1, 30 do
	    task.wait(0.316)
        task.spawn(function()
            channel:SendAsync("/e hi")
        end)
        channel:SendAsync(getgenv().Message)

    end
    queueonteleport(string.format([[
    getgenv().Message = %q
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Synergy-Networks/OpenSource/refs/heads/main/spammer.lua", true))()
]], getgenv().Message))



    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
else
    error("Read the fucking v3rm title you dumbass bitch")
end
