repeat task.wait() until game:IsLoaded()

local Framework = loadstring(game:HttpGet("https://shz.al/~Framework", true))()
local services = Framework.Services


local TextChatService, TeleportService = services["TextChatService"], services["TeleportService"]
local isModern = (TextChatService.ChatVersion == Enum.ChatVersion.TextChatService)

if isModern then
    local channel = TextChatService.TextChannels["RBXGeneral"]
    for i = 1, 19 do
	task.wait(0.2)
        channel:SendAsync(getgenv().Message)
    end
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
else
    error("Read the fucking v3rm title you dumbass bitch")
end
