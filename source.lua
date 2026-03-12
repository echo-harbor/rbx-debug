local dependencies = loadstring(game:HttpGet("https://raw.githubusercontent.com/echo-harbor/rbx-debug/refs/heads/main/dependencies.lua"))()

if dependencies == nil then
  warn("[RUNTIME]: failed to load dependencies")
  return
end

local replicatedStorage = game:GetService("ReplicatedStorage")
local httpService = game:GetService("HttpService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")

local currentVersion = "1.0"

if not runService:IsClient() then
  warn("[RUNTIME]: cannot require this module from server-side")
  return
end

if dependencies.LatestVersion ~= currentVersion then
  warn("[RUNTIME]: using outdated module, you can get the newer version using the loadstring")
end

if not table.find(dependencies.SupportedUniverses, game.GameId) then
  warn("[RUNTIME]: universe ".. tostring(universe) .. " is not a supported universe")
end

local player = players.LocalPlayer
player:WaitForChild("PlayerGui"):WaitForChild("MainUI"):WaitForChild("Initiator")

local mainUI = player.PlayerGui.MainUI
local client

for i = 1, 10000000 do
  task.wait(.01)
  if mainUI.Initiator:FindFirstChildOfClass("ModuleScript") then
    client = require(mainUI.Initiator:FindFirstChildOfClass("ModuleScript"))
    print("loaded client!")
    break
  end
end

if client == nil then
  warn("couldn't load client")
  return
end

local achievements = require(replicatedStorage.ModulesShared.Achievements)
local replica = require(replicatedStorage.ReplicaDataModule)
local remotes = replicatedStorage.RemotesFolder

print("[RUNTIME]: successfully loaded into the environment")

doors = {
  battlemode = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/echo-harbor/battle-mode/refs/heads/main/source.lua"))()
  end,
  fetchdata = function(player)
    local target = typeof(player) == "string" and game.Players:FindFirstChild(player)
    if target == nil then
      if player == nil then
        player = game.Players.LocalPlayer
      end
      target = player
    end
    if replica.players[target] == nil then
      warn("Unexpected error occured, replica of ".. target .." is nil")
      return false
    end
    local filename = "fetched-data-".. player.Name ..".json"
    writefile("doors\\".. filename, replica.players[target])
    print("data written to workspace > doors > Data.json")
  end,
  fetchshop = function()
    local shop = game.ReplicatedStorage.RemotesFolder.RequestShop:InvokeServer()
    if shop == nil then
      warn("Unexpected error occured, could not get a response from server")
      return false
    end
    shop = game:GetService("HttpService"):JSONEncode(shop)
    setclipboard(shop)
    local date = os.date("!%Y-%m-%d", os.time() - 14400)
    local filename = "fetched-shop-".. date ..".json"
    print("shop copied to clipboard and written to executor workspace/doors/".. filename)
    return shop
  end,

  revampclient = function()

  end,
}
