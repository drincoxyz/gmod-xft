-- https://gist.github.com/drincoxyz/a053bf607f8001cbee86921a410f844f
-- this patches the stencil library to optionally allow render.SetStencilEnable to reset to the default stencil values

if SERVER then return end

local render = render

render._SetStencilEnable = render._SetStencilEnable or render.SetStencilEnable

local render_SetStencilWriteMask       = render.SetStencilWriteMask
local render_SetStencilTestMask        = render.SetStencilTestMask
local render_SetStencilReferenceValue  = render.SetStencilReferenceValue
local render_SetStencilCompareFunction = render.SetStencilCompareFunction
local render_SetStencilPassOperation   = render.SetStencilPassOperation
local render_SetStencilFailOperation   = render.SetStencilFailOperation
local render_SetStencilZFailOperation  = render.SetStencilZFailOperation
local render_ClearStencil              = render.ClearStencil
local render_SetStencilEnable          = render._SetStencilEnable

function render.SetStencilEnable(enable, reset)
	if reset then
		render_SetStencilWriteMask(0xFF)
		render_SetStencilTestMask(0xFF)
		render_SetStencilReferenceValue(0)
		render_SetStencilCompareFunction(STENCIL_ALWAYS)
		render_SetStencilPassOperation(STENCIL_KEEP)
		render_SetStencilFailOperation(STENCIL_KEEP)
		render_SetStencilZFailOperation(STENCIL_KEEP)
		render_ClearStencil()
	end
	
	render_SetStencilEnable(enable)
end