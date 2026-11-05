local CollectionService = game:GetService("CollectionService")
local damagers = CollectionService:GetTagged("damager") -- This holds all the (-5) bricks in the game
local instakills = CollectionService:GetTagged("instakill")
local DAMAGE_COOLDOWN = 0.1 -- Short cooldown to prevent near instantaneous death from damagers


-- For the non instakill killbricks
for _, killbrick in damagers do
    local debounce = false
    killbrick.Touched:Connect(function(hit)
        local humanoid = hit.Parent:FindFirstChild("Humanoid")
        if humanoid and not debounce then -- If it was a real player that touched the killbrick..
            debounce = true
            humanoid.Health -= 5 -- Damage the player by 5 HP points
            task.wait(DAMAGE_COOLDOWN)
            debounce = false
        end
    end)
end

-- For instakills
for _, instakill in instakills do
    instakill.Touched:Connect(function(hit)
        local humanoid = hit.Parent:FindFirstChild("Humanoid")
        if humanoid then -- If it was a real player that touched the killbrick..
            humanoid.Health = 0 -- Kill the player
        end
    end)
end