-- https://gist.github.com/drincoxyz/0eda488d1e02232a8f449ae4efa87dab
-- this patch makes it so that players will spawn a server ragdoll instead of a client one from Player:CreateRagdoll
-- server ragdolls have full physics capabilities and are synchronized between clients (at the cost of network usage)
-- as expected this will make Player:CreateRagdoll call GM:CreateEntityRagdoll instead of GM:CreateClientsideRagdoll

hook.Add('OnEntityCreated', 'ragpatch', function(ent)
	if ent:GetClass() != 'prop_ragdoll' or !ent:IsValid() then return end

	local owner = ent:GetOwner()
	
	if !owner:IsPlayer() then return end

	ent.GetPlayerColor = function(self)
		local owner = ent:GetOwner()
		return owner:IsValid() and owner:GetPlayerColor() or Vector()
	end
end)

local meta = FindMetaTable 'Player'

meta._GetRagdollEntity = meta._GetRagdollEntity or meta.GetRagdollEntity

function meta:GetRagdollEntity()
	return self:GetNW2Entity 'ragdoll'
end

if CLIENT then return end

meta._CreateRagdoll = meta._CreateRagdoll or meta.CreateRagdoll

function meta:CreateRagdoll()
	local rag = ents.Create 'prop_ragdoll'
	
	if rag:IsValid() then
		local mdl   = self:GetModel()
		local pos   = self:GetPos()
		local ang   = self:GetRenderAngles()
		local vel   = self:GetVelocity()
		local bones = {}
		
		for i = 0, self:GetBoneCount() do
			local pos, ang = self:GetBonePosition(i)
			bones[i] = {pos = pos, ang = ang}
		end
	
		rag:SetModel(mdl)
		rag:SetPos(pos)
		rag:SetAngles(ang)
		rag:SetOwner(self)
		rag:Spawn()
		
		self:SetNW2Entity('ragdoll', rag)
		
		timer.Simple(0, function()
			if !rag:IsValid() then return end
			
			local phys = rag:GetPhysicsObject()
			
			if phys and phys:IsValid() then
				local mass = phys:GetMass()
				
				phys:Wake()
				phys:AddVelocity(vel * mass / 2)
				
				for i = 0, rag:GetPhysicsObjectCount() do
					local bone = rag:TranslatePhysBoneToBone(i)
					
					if bone and 0 < bone then
						local pos, ang = self:GetBonePosition(bone)
						
						if pos and ang then
							local phys = rag:GetPhysicsObjectNum(i)
							
							if phys and phys:IsValid() then
								local ft = FrameTime()
								
								phys:Wake()
								phys:ComputeShadowControl {
									pos = pos,
									angle = ang,
									teleportdistance = 1,
								}
							end
						end
					end
				end
			end
		end)
		
		hook.Add('Think', rag, function()
			local owner = rag:GetOwner()
			
			if !owner:IsValid() or rag != owner:GetRagdollEntity() then
				return rag:Remove()
			end
		end)
	end
	
	gamemode.Call('CreateEntityRagdoll', self, rag)
	
	return rag
end

function meta:DestroyRagdoll()
	local rag = self:GetRagdollEntity()
	
	if rag:IsValid() then
		rag:Remove()
	end
end