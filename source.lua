local debugger = {
  ["Loaded"] = false,
  ["ExitCode"] = -999,
  ["ExitCause"] = "",
}

pcall(function()
  local runService = game:GetService("RunService")

  if not runService:IsClient() then
    warn("[rbx-debug]: source.lua must be run from client! if you wish to run this server side, use source-server.lua instead.")
    debugger.ExitCode = 3
    debugger.ExitCause = "source.lua must be run from client! if you wish to run this server side, use source-server.lua instead."
  end

  local dependencies = loadstring(game:HttpGet("https://raw.githubusercontent.com/echo-harbor/rbx-debug/refs/heads/main/dependencies.lua"))()

  local universe = game.GameId

  if not table.find(dependencies.SupportedUniverses, universe) then
    debugger.ExitCode = 2
    debugger.ExitCause = "universe ".. tostring(universe) .. " is not a supported universe"
  end
end)

if debugger.ExitCode == -999 then
  debugger.ExitCode = 0
end

if debugger.ExitCode ~= 0 then
  if debugger.ExitCause == "" then
    warn("[rbx-debug]: debugger has exited with error code ".. tostring(debugger.ExitCode) .. " with no provided reason")
  else
    warn("[rbx-debug]: debugger has exited with error code ".. tostring(debugger.ExitCode))
    warn("[rbx-debug]:", debugger.ExitCause)
  end
  return debugger
end

debugger = {
  ["Loaded"] = true,
  ["ExitCode"] = nil,
  ["ExitCause"] = nil,
}

print("[rbx-debug]: debugger has successfully loaded into the environment")

debugger.func = {
  battlemode = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/echo-harbor/battle-mode/refs/heads/main/source.lua"))()
  end,
  getmydata = function()
    writefile("doors\\Data.json", game:GetService("HttpService"):JSONEncode(require(game.ReplicatedStorage.ReplicaDataModule).data))
    print("data written to workspace > doors > Data.json")
  end,
}
