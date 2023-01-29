
mg = {}

-- pico-8 hooks
function _init()
	clearlog()

	mg = mapgen:new()
	mg:initialize()
	mg:find_neighboring_tiles()
	-- mg:collapse()
end

function _update()
	handle_controllers()
	-- mg:collapse_a_tile_slow()
	mg:collapse()
	-- mg:draw()
end

function _draw()
	cls()
	map()
end