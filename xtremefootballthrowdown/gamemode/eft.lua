--
-- Hooks
--

hook.Add("OnEntityCreated", "eft_spawn_points", function(ent)
	local class = ent:GetClass()

	if class:find "info_player_" then
		local spawn = ents.Create "xft_player_spawn"
		
		if IsValid(spawn) then
			timer.Simple(0, function()
				spawn:SetPos(ent:GetPos())
				spawn:SetAngles(ent:GetAngles())
				spawn:SetParent(ent:GetParent())

				if class == "info_player_blue" then
					spawn:SetSlot(2)
				elseif class == "info_player_red" then
					spawn:SetSlot(1)
				end
				
				spawn:Spawn()
				ent:Remove()
			end)
		end
	end
end)

hook.Add("OnEntityCreated", "eft_goals", function(ent)
	local class = ent:GetClass()

	if class == "trigger_goal" then
		local goal = ents.Create "xft_goal"
		
		if IsValid(goal) then
			timer.Simple(0, function()
				goal:SetPos(ent:GetPos())
				goal:SetCollisionBounds(ent:GetCollisionBounds())
				goal:SetAngles(ent:GetAngles())
				goal:SetParent(ent:GetParent())
				goal:SetBrushModel(ent.BrushModel)
				goal:SetSlot(ent.Slot)
				
				goal:Spawn()
				ent:Remove()
			end)
		end
	end
end)

hook.Add("OnEntityCreated", "eft_ball_resets", function(ent)
	local class = ent:GetClass()

	if class == "trigger_ballreset" then
		local reset = ents.Create "xft_ball_reset"
		
		if IsValid(reset) then
			timer.Simple(0, function()
				reset:SetPos(ent:GetPos())
				reset:SetAngles(ent:GetAngles())
				reset:SetParent(ent:GetParent())
				reset:SetBrushModel(ent:GetBrushModel())
				reset:Spawn()
				ent:Remove()
			end)
		end
	end
end)

hook.Add("OnEntityCreated", "eft_items", function(ent)
	local class = ent:GetClass()

	if class == "prop_ball" then
		local ball = ents.Create "xft_item_ball"
		
		if IsValid(ball) then
			timer.Simple(0, function()
				ball:SetPos(ent:GetPos())
				ball:SetAngles(ent:GetAngles())
				ball:SetParent(ent:GetParent())
				
				ball:Spawn()
				ent:Remove()
			end)
		end
	end
end)