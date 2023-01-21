
-- pico-8 hooks
function _init()
	clearlog()

	local mapgen = mapgen:new()
	mapgen:generate()
	mapgen:draw()
end

function _update()
	handle_controllers()
end

function _draw()
	cls()
	map()
end