-- ▗▀▖      ▐     ▐          ▜       
-- ▐  ▞▀▖▞▀▖▜▀ ▞▀▘▜▀ ▞▀▖▛▀▖  ▐ ▌ ▌▝▀▖
-- ▜▀ ▌ ▌▌ ▌▐ ▖▝▀▖▐ ▖▛▀ ▙▄▘▗▖▐ ▌ ▌▞▀▌
-- ▐  ▝▀ ▝▀  ▀ ▀▀  ▀ ▝▀▘▌  ▝▘ ▘▝▀▘▝▀▘
-- This file handles player footsteps.

-- Since there's no enumerations for the foot argument in GM:PlayerFootstep or GM:PlayerStep by default, here they are.
FOOT_LEFT  = 0
FOOT_RIGHT = 1

function GM:PlayerStepSoundTime(pl, time, walk)
	-- See GM:PlayerFootstep for an explaination of this.
	-- Basically, players will technically step every frame/tick because of this.
	return 0
end

function GM:PlayerFootstep(pl, pos, foot, snd, vol, filter)
	-- Since GM:PlayerStepSoundTime always returns 0, this hook will be called every frame/tick while the player is moving.
	-- The reason for this is to make footsteps much more accurate by using the player's animation cycle, rather than the static timing values used when the animation model was compiled, which doesn't take into account things like playback rate.
	-- In other words, players will step when you expect them to step.
	-- This also makes the reasonable assumption that every movement animation has the player stepping at exactly 1/4 (right foot) and 3/4 (left foot) of the animation cycle, which all the defaults ones in Garry's Mod do.
	-- The biggest downside to this implementation is that addons that use this hook will probably break, but whatever.
	-- In the case of this gamemode, the custom GM:PlayerStep hook is the official replacement for this hook when it comes to the original functionality of this hook, since this is called by the engine.

	local cycle = pl:GetCycle()

	-- Since the normal foot argument is invalid due to the explaination above, it'll be corrected based on the player's animation cycle.
	-- The left foot is reserved for cycles >= 3/4 and < 1/4.
	-- The right foot is reserved for cycles  >= 1/4 and < 3/4.
	local foot = (cycle >= .75 || cycle < .25) && FOOT_LEFT || FOOT_RIGHT

	-- GM:PlayerStep will only be called when a step is taken.
	-- This is achieved by storing the last foot the player stepped with, and comparing it to the current foot argument.
	if pl.m_iLastFoot != foot then
		-- A new step is being taken, so update the plyer's last stepped foot.
		pl.m_iLastFoot = foot

		-- Now it's time to call the GM:PlayerStep hook.
		-- Much like GM:PlayerFootstep, a boolean can be returned to mute the sound that will be played manually, since this hook will always return true, and thus, always mute the footstep sound normally played by the engine.
		local mute = gamemode.Call("PlayerStep", pl, pos, foot, sound, volume, filter)

		-- Got the go-ahead to play the footstep sound manually.
		if !mute then
			-- Unlike the default engine behaviour, this will play the sound from the position of the foot bone that stepped, rather than emitting it from the player entity.
			-- This better replicates how it would sound in real life.
			local bone = foot == FOOT_LEFT && pl:LookupBone "ValveBiped.Bip01_L_Foot" || pl:LookupBone "ValveBiped.Bip01_R_Foot"
			local pos  = pl:GetBonePosition(bone)

			sound.Play(snd, pos, 75, math.Rand(95, 105), vol)
		end
	end

	-- Footstep sounds are played manually above, so the engine ones are muted.
	return true
end

function GM:PlayerStep(pl, pos, foot, sound, volume, filter)
	-- Uncomment this to test muting behavior of footstep sounds.
	-- return true
end
