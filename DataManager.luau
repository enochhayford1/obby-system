local RunService = game:GetService("RunService")
local ProfileStore = require(game.ServerScriptService.GameData.ProfileStore)
local USE_MOCK = false

-- The PROFILE_TEMPLATE table is what new profile "Profile.Data" will default to:
local PROFILE_TEMPLATE = {
	Stage = 0,
}

local Players = game:GetService("Players")


local PlayerStore = ProfileStore.New("PlayerStore", PROFILE_TEMPLATE)

local function createLeaderstats(player: Player, profile)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"

	local stage = Instance.new("IntValue")
	stage.Name = "Stage"
	stage.Value = profile.Data.Stage
	stage.Parent = leaderstats

	leaderstats.Parent = player
end

local function setSpawnOnJoin(player: Player, profile)
	local spawnPoint = tostring(profile.Data.Stage)
	player.RespawnLocation = game.Workspace.Stages:FindFirstChild(spawnPoint)
end


if RunService:IsStudio() and USE_MOCK then
	PlayerStore = PlayerStore.Mock
	warn("Mock store enabled:  Saving disabled - toggle with USE_MOCK")
end

local Profiles: {[Player]: typeof(PlayerStore:StartSessionAsync())} = {}

local function PlayerAdded(player)

	-- Start a profile session for this player's data:

	local profile = PlayerStore:StartSessionAsync(`{player.UserId}`, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})

	-- Handling new profile session or failure to start it:

	if profile ~= nil then

		profile:AddUserId(player.UserId) -- GDPR compliance
		profile:Reconcile() 

		profile.OnSessionEnd:Connect(function()
			Profiles[player] = nil
			player:Kick(`Profile session end - Please rejoin`)
		end)

		if player.Parent == Players then
			Profiles[player] = profile
			print(`Profile loaded for {player.DisplayName}!`)
			createLeaderstats(player, profile)
		else
			-- The player has left before the profile session started
			profile:EndSession()
		end

	else
		-- This condition should only happen when the Roblox server is shutting down
		player:Kick(`Profile load fail - Please rejoin`)
	end

	setSpawnOnJoin(player, profile)
	player:LoadCharacterAsync()

end

-- In case Players have joined the server earlier than this script ran:
for _, player in Players:GetPlayers() do
	task.spawn(PlayerAdded, player)
end

Players.PlayerAdded:Connect(PlayerAdded)

Players.PlayerRemoving:Connect(function(player)
	local profile = Profiles[player]
	if profile ~= nil then
		profile:EndSession()
	end
end)


local DataManager = {}

local function updateStageLeaderstats(player: Player, stage: number)
	player.leaderstats.Stage.Value = stage
end

function DataManager.getProfile(player: Player)
	return Profiles[player]
end

function DataManager.setStage(player: Player, stage: number)
	local profile = DataManager.getProfile(player)

	if not profile then
		return
	end

	profile.Data.Stage = stage
	updateStageLeaderstats(player, stage)
end

function DataManager.getStage(player: Player): number?
	local profile = DataManager.getProfile(player)

	if profile then
		return profile.Data.Stage
	end

	return nil
end

return DataManager
