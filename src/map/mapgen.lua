
-- mapgen
mapgen = {}

function mapgen:new()
	local o = {}
	setmetatable(o, self)
	self.__index = self

	self.rules = {}

	local tilesets = {}

	add(tilesets, 
		{ 74, 74, 74, 75, 76, 77, 78, 90, 91, 92, 93, 94, 95, 106 }
	)

	add(tilesets,
		{ 64, 64, 64, 64, 64, 64, 64, 65, 66, 80, 81, 82, 83, 84, 85, 86, 87, 96, 97, 98, 99, 100, 101, 102, 103, 88, 89, 104, 105}
	)

	self.tiles = rnd(tilesets)

	local count_rule = count_rules:new()
	add(o.rules, count_rule)

	o.map_tiles = {}

	o.mapdata = mapdata:new()
	return o
end

function mapgen:find_neighboring_tiles()
	local r = neighbor_rules:new()

	for t1 in all(self.tiles) do
		for t2 in all(self.tiles) do
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
	self:initialize(self.tiles)
	self:find_neighboring_tiles()
	self:collapse()
end

function mapgen:initialize(tiles)
	self.mapdata:initialize(tiles)
end

function mapgen:collapse()
	local resolved = false
	local low_tiles = self.mapdata:lowest()

	while not (#low_tiles == 0) do
		-- find lowest entropy
		local low_ent_tile = rnd(low_tiles)
		-- log("map tiles")
		-- log(tostring(self.mapdata))

		-- log("low_tiles:")
		-- log(tostring(low_tiles))

		low_ent_tile:collapse()

		-- propagate tile changes
		self:propagate(low_ent_tile)

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

function mapgen:propagate(affected_tile)
	x = affected_tile.x
	y = affected_tile.y

	local tiles = self.mapdata.map_tiles
	for rule in all(self.rules) do
		rule:propagate(affected_tile, self.mapdata)
	end
end