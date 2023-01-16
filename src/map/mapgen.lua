
-- mapgen
mapgen = {}

function mapgen:new()
	local o = {}
	setmetatable(o, self)
	self.__index = self

	self.rules = {}

	local r = neighbor_rules:new()

	r:add_neighbors(86, 86, neighbor_rules_const.all)
	r:add_neighbors(102, 102, neighbor_rules_const.all)

	-- horizontal
	r:add_neighbors(86, 80, neighbor_rules_const.right)
	r:add_neighbors(86, 81, neighbor_rules_const.left)

	r:add_neighbors(102, 80, neighbor_rules_const.right)
	r:add_neighbors(102, 81, neighbor_rules_const.left)

	-- r:add_neighbors(96, 96, neighbor_rules_const.left)
	-- r:add_neighbors(97, 97, neighbor_rules_const.right)

	-- -- vertical
	-- r:add_neighbors(81, 86, neighbor_rules_const.right)
	-- r:add_neighbors(80, 86, neighbor_rules_const.left)

	-- r:add_neighbors(81, 102, neighbor_rules_const.left)
	-- r:add_neighbors(80, 102, neighbor_rules_const.right)

	-- r:add_neighbors(81, 81, neighbor_rules_const.above)
	-- r:add_neighbors(80, 80, neighbor_rules_const.below)



	-- r:add_neighbors(102, 65, neighbor_rules_const.all)
	-- r:add_neighbors(86, 102, neighbor_rules_const.all)
	-- r:add_neighbors(102,103, neighbor_rules_const.all)
	-- r:add_neighbors(86, 86, neighbor_rules_const.all)
	-- r:add_neighbors(86, 87, neighbor_rules_const.all)
	-- r:add_neighbors(86, 70, neighbor_rules_const.all)
	-- r:add_neighbors(70, 70, neighbor_rules_const.all)
	-- r:add_neighbors(70,71, neighbor_rules_const.all)
	-- r:add_neighbors(71, 71, neighbor_rules_const.all)
	add(self.rules, r)
	o.map_tiles = {}

	o.mapdata = mapdata:new()
	return o
end

function mapgen:generate()
	self:initialize()
	self:collapse()
end

function mapgen:initialize()
	self.mapdata:initialize()
end

function mapgen:collapse()
	log("mapgen:collapse()")
	local resolved = false
	local low_tiles = self.mapdata:lowest()
	-- log("low tiles")
	-- log(tostring(low_tiles))

	while not (#low_tiles == 0) do
		-- log("low tiles")
		-- log(tostring(low_tiles))

		-- find lowest entropy
		local low_ent_tile = rnd(low_tiles)
		log("collapsing tile " .. low_ent_tile.x .. ", " .. low_ent_tile.y)
		low_ent_tile:collapse()

		-- propogate tile changes
		self:propogate(low_ent_tile)

		-- self:print_all_states(map_tiles)

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

	log("collapsed " .. x .. ", " .. y)
	log("propogating...")
	log("tiles:")
	local tiles = self.mapdata.map_tiles
	log(tiles)
	for rule in all(self.rules) do
		rule:propogate(affected_tile, self.mapdata)
	end
end