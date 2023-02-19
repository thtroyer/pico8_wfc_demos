
mg = {}

-- pico-8 hooks
function _init()
	clearlog()

	mg = mapgen:new(
		{ 64, 64, 64, 64, 64, 64, 64, 65, 66, 80, 81, 82, 83, 84, 85, 86, 87, 96, 97, 98, 99, 100, 101, 102, 103, 88, 89, 104, 105}
	)
	mg:initialize()
	mg:find_neighboring_tiles()
	-- mg:generate_neighbor_rules_by_example(
		-- { 213, 214, 215, 216, 229, 230, 231, 232, 245, 256, 257, 258}
	-- )
	mg:collapse()
end

function _update()
	handle_controllers()
	-- mg:collapse_a_tile_slow()
	-- mg:collapse()
	-- mg:draw()
end

function _draw()
	cls()
	map()
end