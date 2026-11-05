local DataManager = require(script.DataManager)
local updateUI = game.ReplicatedStorage.Events.updateUI
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local stages = CollectionService:GetTagged("stage")
local debounce = {}

-- Stage validation
function isNextStage(player, stage)
	local profile = DataManager.getProfile(player)

	if profile then
		return tonumber(stage.Name) == (profile.Data.Stage + 1)
	end

	return false
end

-- Sets a new spawnpoint for the player
function setNewSpawn(player: Player)
	local stage = DataManager.getStage(player)
	
	if stage then
	player.RespawnLocation = game.Workspace.Stages:FindFirstChild(tostring(stage))
	end
end

-- Updates the stage selector ui
function updatePlayerUI(player: Player)
	local stage = DataManager.getStage(player)
	
	if stage then
		updateUI:FireClient(player, stage)
	end
end

-- register stage event for all stages
for _, stage in stages do
	stage.Touched:Connect(function(hit)
		local player = Players:GetPlayerFromCharacter(hit.Parent)

		if player and not debounce[player.UserId] then
			debounce[player.UserId] = true

			if isNextStage(player, stage) then
				DataManager.setStage(player, tonumber(stage.Name))
				setNewSpawn(player)
				updatePlayerUI(player)
			end
		end
		
		task.wait(1)
		debounce[player.UserId] = nil
	end)
end

