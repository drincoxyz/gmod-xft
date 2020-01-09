--
-- This is taken directly from JetBoom's EFT optimizations from `nixthelag.lua` and is
-- left unmodified (other than this comment block)
--
-- As far as I'm aware, these optimizations never caused any bugs and should theoretically help
-- performance a bit
--

hook.Add("Initialize", "XFTOptimize", function()
	-- Horrible amount of cycle usage, especially on the server.
	hook.Remove("PlayerTick", "TickWidgets")

	if SERVER then
		-- Forget what this is but probably retarded.
		if timer.Exists("CheckHookTimes") then
			timer.Remove("CheckHookTimes")
		end
	end

	if CLIENT then
		-- These call on bloated convar getting methods and aren't ever used anyway outside of sandbox.
		hook.Remove("RenderScreenspaceEffects", "RenderColorModify")
		hook.Remove("RenderScreenspaceEffects", "RenderBloom")
		hook.Remove("RenderScreenspaceEffects", "RenderToyTown")
		hook.Remove("RenderScreenspaceEffects", "RenderTexturize")
		hook.Remove("RenderScreenspaceEffects", "RenderSunbeams")
		hook.Remove("RenderScreenspaceEffects", "RenderSobel")
		hook.Remove("RenderScreenspaceEffects", "RenderSharpen")
		hook.Remove("RenderScreenspaceEffects", "RenderMaterialOverlay")
		hook.Remove("RenderScreenspaceEffects", "RenderMotionBlur")
		hook.Remove("RenderScene", "RenderStereoscopy")
		hook.Remove("RenderScene", "RenderSuperDoF")
		hook.Remove("GUIMousePressed", "SuperDOFMouseDown")
		hook.Remove("GUIMouseReleased", "SuperDOFMouseUp")
		hook.Remove("PreventScreenClicks", "SuperDOFPreventClicks")
		hook.Remove("PostRender", "RenderFrameBlend")
		hook.Remove("PreRender", "PreRenderFrameBlend")
		hook.Remove("Think", "DOFThink")
		hook.Remove("RenderScreenspaceEffects", "RenderBokeh")
		hook.Remove("NeedsDepthPass", "NeedsDepthPass_Bokeh")

		-- Useless since we disabled widgets above.
		hook.Remove("PostDrawEffects", "RenderWidgets")

		-- Could screw with people's point shops but whatever.
		hook.Remove("PostDrawEffects", "RenderHalos")
	end
end)