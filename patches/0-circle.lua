-- https://gist.github.com/drincoxyz/a053bf607f8001cbee86921a410f844f
-- this patches the surface library to optionally allow surface.DrawCircle to draw a filled circle

if SERVER then return end

local surface = surface

surface._DrawCircle = surface._DrawCircle or surface.DrawCircle

local table = table
local math  = math

local surface_DrawCircle   = surface._DrawCircle
local surface_SetDrawColor = surface.SetDrawColor
local surface_DrawPoly     = surface.DrawPoly
local table_insert         = table.insert
local math_sin             = math.sin
local math_rad             = math.rad
local math_cos             = math.cos
local math_pi              = math.pi

function surface.DrawCircle(x, y, rad, seg, r, g, b)
	local rcol = IsColor(r)
	local g    = rcol and nil or g
	local cir  = {}

	table_insert(cir, {x = x, y = y, u = 0.5, v = 0.5})
	for i = 0, seg do
		local a = math_rad((i / seg) * -360)
		table_insert(cir, {x = x + math_sin(a) * rad, y = y + math_cos(a) * rad, u = math_sin(a) / 2 + 0.5, v = math_cos(a) / 2 + 0.5})
	end

	local a = math_rad(0)
	table_insert(cir, {x = x + math_sin(a) * rad, y = y + math_cos(a) * rad, u = math_sin(a) / 2 + 0.5, v = math_cos(a) / 2 + 0.5})

	surface_SetDrawColor(r, g, b)
	surface_DrawPoly(cir)
end