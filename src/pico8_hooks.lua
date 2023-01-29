
mapgen = {}

-- pico-8 hooks
function _init()
	clearlog()

	mapgen = mapgen:new()
	mapgen:initialize()
	mapgen:find_neighboring_tiles()
end

function _update()
	handle_controllers()
	mapgen:collapse_a_tile()
	-- mapgen:draw()
end

function _draw()
	cls()
	map()
end