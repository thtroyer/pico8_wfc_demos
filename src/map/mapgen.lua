
-- mapgen
mapgen = {}

function mapgen:new()
	local o = {}
	setmetatable(o, self)
	self.__index = self

	self.rules = {}

--	local r = neighbor_rules:new()

	-- gray numbers, left to right
	-- 112 - 1; 113 - 2; 114 - 3;
	-- red numbers, up to down
	-- 116, 117, 118
	-- 115 - everything else
	
	-- gray numbers
	-- r:add_neighbors(112, neighbor_rules.left, 113)
	-- r:add_neighbors(113, neighbor_rules.left, 114)
	-- r:add_neighbors(115, neighbor_rules.left, 112)
	-- r:add_neighbors(114, neighbor_rules.left, 115)

	-- -- vertical gray numbers
	-- r:add_neighbors(112, neighbor_rules.above, 112)
	-- r:add_neighbors(113, neighbor_rules.above, 113)
	-- r:add_neighbors(114, neighbor_rules.above, 114)

	-- -- red numbers
	-- r:add_neighbors(115, neighbor_rules.above, 116)
	-- r:add_neighbors(116, neighbor_rules.above, 117)
	-- r:add_neighbors(117, neighbor_rules.above, 118)
	-- r:add_neighbors(118, neighbor_rules.above, 115)

	-- -- horizontal red numbers
	-- r:add_neighbors(116, neighbor_rules.right, 116)
	-- r:add_neighbors(117, neighbor_rules.right, 117)
	-- r:add_neighbors(118, neighbor_rules.right, 118)

	-- -- dot filler
	-- r:add_neighbors(115, neighbor_rules.above, 112)
	-- r:add_neighbors(115, neighbor_rules.above, 113)
	-- r:add_neighbors(115, neighbor_rules.above, 114)

	-- r:add_neighbors(115, neighbor_rules.below, 112)
	-- r:add_neighbors(115, neighbor_rules.below, 113)
	-- r:add_neighbors(115, neighbor_rules.below, 114)

	-- r:add_neighbors(115, neighbor_rules.left, 116)
	-- r:add_neighbors(115, neighbor_rules.left, 117)
	-- r:add_neighbors(115, neighbor_rules.left, 118)

	-- r:add_neighbors(115, neighbor_rules.right, 116)
	-- r:add_neighbors(115, neighbor_rules.right, 117)
	-- r:add_neighbors(115, neighbor_rules.right, 118)

	-- r:add_neighbors(115, neighbor_rules.all, 115)

	o.map_tiles = {}

	o.mapdata = mapdata:new()
	return o
end

function mapgen:find_neighboring_tiles()
	local r = neighbor_rules:new()

	local tiles = { 64, 65, 66, 80, 81, 82, 83, 84, 85, 86, 87, 96, 97, 98, 99, 100, 101, 102, 103, 88, 89, 104, 105}

	for t1 in all(tiles) do
		for t2 in all(tiles) do
			if (get_sprite_pixels(t1, sides.bottom) == get_sprite_pixels(t2, sides.top)) then
				r:add_neighbors(t1, neighbor_rules.above, t2)
			end
			if (get_sprite_pixels(t1, sides.top) == get_sprite_pixels(t2, sides.bottom)) then
				r:add_neighbors(t1, neighbor_rules.below, t2)
			end
			if (get_sprite_pixels(t1, sides.right) == get_sprite_pixels(t2, sides.left)) then
				r:add_neighbors(t1, neighbor_rules.left, t2)
			end
			if (get_sprite_pixels(t1, sides.left) == get_sprite_pixels(t2, sides.right)) then
				r:add_neighbors(t1, neighbor_rules.right, t2)
			end
		end
	end

	r:deduplicate_rules()

	add(self.rules, r)
end

function mapgen:generate()
	self:initialize()
	self:find_neighboring_tiles()
	self:collapse()
end

function mapgen:initialize()
	self.mapdata:initialize()
end

function mapgen:collapse()
	log("mapgen:collapse()")
	local resolved = false
	local low_tiles = self.mapdata:lowest()

	while not (#low_tiles == 0) do
		-- find lowest entropy
		local low_ent_tile = rnd(low_tiles)
		if (#low_tiles == 255) then
			low_ent_tile = low_tiles[17] -- 1,1
		end

		log("collapsing tile " .. low_ent_tile.x .. ", " .. low_ent_tile.y)
		low_ent_tile:collapse()

		-- propogate tile changes
		self:propogate(low_ent_tile)

		low_tiles = self.mapdata:lowest()
	end
end

function mapgen:draw()
	local map_tiles = self.mapdata.map_tiles
	for x = 0,15, 1 do
		for y = 0, 15, 1 do
			mset(x, y, map_tiles[x+y*16].tile)
		end
	end
end

-- debug
function mapgen:print_all_states(tiles)
    local tiles = self.mapdata.map_tiles
	for t in all(tiles) do
		log(t.x..","..t.y)
		local states = ""
		for s in all(t.list_of_tiles) do
			states = states .. s .. ", "
		end
		log(states)
	end
end

function mapgen:propogate(affected_tile)
	x = affected_tile.x
	y = affected_tile.y

	log("")
	log("collapsed " .. x .. ", " .. y)
	log("mapgen:propogate")

	local tiles = self.mapdata.map_tiles
	for rule in all(self.rules) do
		rule:propogate(affected_tile, self.mapdata)
	end
end