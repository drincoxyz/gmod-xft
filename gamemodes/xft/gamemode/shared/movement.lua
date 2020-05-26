--                        ▐    ▜
-- ▛▚▀▖▞▀▖▌ ▌▞▀▖▛▚▀▖▞▀▖▛▀▖▜▀   ▐ ▌ ▌▝▀▖
-- ▌▐ ▌▌ ▌▐▐ ▛▀ ▌▐ ▌▛▀ ▌ ▌▐ ▖▗▖▐ ▌ ▌▞▀▌
-- ▘▝ ▘▝▀  ▘ ▝▀▘▘▝ ▘▝▀▘▘ ▘ ▀ ▝▘ ▘▝▀▘▝▀▘
-- This file handles player movement.

function GM:Move(pl, mv)
	-- When the player is dead, they shouldn't be able to move at all, so all buttons and movement speed are removed, as well as overriding default engine movement.
	-- In addition, if the player has a ragdoll, their origin and velocity are fixed to the ragdoll's.
	if !pl:Alive() then
		mv:SetForwardSpeed(0)
		mv:SetSideSpeed(0)
		mv:SetUpSpeed(0)
		mv:SetButtons(0)

		local rag = pl:GetRagdollEntity()

		if IsValid(rag) then
			mv:SetOrigin(rag:GetPos())
			mv:SetVelocity(rag:GetVelocity())
		end

		return true
	end

	-- By default, players will have their maximum movement speed set to this.
	mv:SetMaxSpeed(400)

	-- This gives a chance for things like items to modify the player's movement data before it's processed by the base movement code below.
	gamemode.Call("CustomMove", pl, mv)

	-- This handles the absolute basic player movement.
	-- Basically, the player's forward movement will totally negate any side movement, and forward speed will be accelerated slowly until it reaches the maximum movement speed.
	-- If the player isn't running straight ahead, they will have their speed clamped to a fairly low value.
	-- The reason FL_ANIMDUCKING is being checked instead of simply calling Crouching on the player is because FL_ANIMDUCKING also takes into account the transition into ducking, as well as the actual ducking itself.
	if pl:OnGround() && !pl:IsFlagSet(FL_ANIMDUCKING) && mv:GetForwardSpeed() > 0 then
		local vel          = mv:GetVelocity()
		local maxSpeed     = mv:GetMaxSpeed()
		local speed        = math.min(maxSpeed, vel:Length2D())
		local acceleration = 1
		local newSpeed     = math.max(speed + FrameTime() * (15 + 0.5 * (400 - speed)) * acceleration, 100) * (1 - math.max(0, math.abs(math.AngleDifference(mv:GetMoveAngles().yaw, vel:Angle().yaw)) - 4) / 360)

		mv:SetSideSpeed(0)
		mv:SetMaxClientSpeed(newSpeed)
	else
		-- This is a special case for players who are swimming, to make it so they don't swim so slow.
		if pl:WaterLevel() > 1 then
			mv:SetMaxClientSpeed(250)
		else
			mv:SetMaxClientSpeed(150)
		end
	end
end

function GM:CustomMove(pl, mv)
end
