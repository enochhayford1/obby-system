local CollectionService = game:GetService("CollectionService")
local player = game.Players.LocalPlayer
local forward = script.Parent.Forward
local backward = script.Parent.Backward
local stageDisplay = script.Parent.stageDisplay
local updateUI = game.ReplicatedStorage.Events.updateUI
local stages = CollectionService:GetTagged("stage")

local stage = player:WaitForChild("leaderstats"):WaitForChild("Stage").Value
stageDisplay.Text = stage

forward.MouseButton1Click:Connect(function()
	local stage = player.leaderstats.Stage.Value
	if stageDisplay.Text + 1 > stage then
		stageDisplay.Text = 0
		local stageTo = game.Workspace.Stages:FindFirstChild(tostring(0))
		local root = player.Character:WaitForChild("HumanoidRootPart")
		root.CFrame = CFrame.new(stageTo.Position + Vector3.new(0,5,0))
		
	elseif stageDisplay.Text + 1 <= stage then
		stageDisplay.Text = stageDisplay.Text+1
		local stageTo = game.Workspace.Stages:FindFirstChild(tostring(stageDisplay.Text))
		local root = player.Character:WaitForChild("HumanoidRootPart")
		root.CFrame = CFrame.new(stageTo.Position + Vector3.new(0,5,0))
	end
end)

backward.MouseButton1Click:Connect(function()
	local stage = player.leaderstats.Stage.Value
	if stageDisplay.Text - 1 < 0 then
		stageDisplay.Text = stage
		local stageTo = game.Workspace.Stages:FindFirstChild(tostring(stage))
		local root = player.Character:FindFirstChild("HumanoidRootPart")
		root.CFrame = CFrame.new(stageTo.Position + Vector3.new(0,5,0))
		
	elseif stageDisplay.Text - 1 >= 0 then
		stageDisplay.Text = stageDisplay.Text - 1
		local stageTo = game.Workspace.Stages:FindFirstChild(stageDisplay.Text)
		local root = player.Character:FindFirstChild("HumanoidRootPart")
		root.CFrame = CFrame.new(stageTo.Position + Vector3.new(0,5,0))
	end
end)

updateUI.OnClientEvent:Connect(function(stage)
	stageDisplay.Text = stage
end)

