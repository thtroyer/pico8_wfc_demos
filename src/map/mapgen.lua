
-- mapgen
mapgen = {}

function mapgen:new()
	local o = {}
	setmetatable(o, self)
	self.__index = self

	self.rules = {}

	local r = neighbor_rules:new()

	-- 112 - 1; 113 - 2; 114 - 3;
	-- 115 - everything else
	
	-- r:add_neighbors(112, neighbor_rules.left, 113)
	-- r:add_neighbors(113, neighbor_rules.left, 114)
	-- r:add_neighbors(115, neighbor_rules.left, 112)
	-- r:add_neighbors(114, neighbor_rules.left, 115)

	-- these rules should generate the same as the above version
	r:add_neighbors(113, neighbor_rules.right, 112)
	r:add_neighbors(114, neighbor_rules.right, 113)
	r:add_neighbors(112, neighbor_rules.right, 115)
	r:add_neighbors(115, neighbor_rules.right, 114)
	-- end 

	r:add_neighbors(115, neighbor_rules.left, 115)

	r:add_neighbors(112, neighbor_rules.above, 112)
	r:add_neighbors(113, neighbor_rules.above, 113)
	r:add_neighbors(114, neighbor_rules.above, 114)
	r:add_neighbors(115, neighbor_rules.above, 115)

	-- dot filler
	r:add_neighbors(115, neighbor_rules.above, 112)
	r:add_neighbors(115, neighbor_rules.above, 113)
	r:add_neighbors(115, neighbor_rules.above, 114)

	r:add_neighbors(115, neighbor_rules.below, 112)
	r:add_neighbors(115, neighbor_rules.below, 113)
	r:add_neighbors(115, neighbor_rules.below, 114)


	-- r:add_neighbors(86, 86, neighbor_rules_const.all)
	-- r:add_neighbors(102, 102, neighbor_rules_const.all)

	-- r:add_neighbors(79, 80, neighbor_rules_const.all)
	-- r:add_neighbors(79, 81, neighbor_rules_const.all)
	-- r:add_neighbors(79, 82, neighbor_rules_const.all)
	-- r:add_neighbors(79, 83, neighbor_rules_const.all)
	-- r:add_neighbors(79, 84, neighbor_rules_const.all)
	-- r:add_neighbors(79, 85, neighbor_rules_const.all)
	-- r:add_neighbors(79, 86, neighbor_rules_const.all)
	-- r:add_neighbors(79, 96, neighbor_rules_const.all)
	-- r:add_neighbors(79, 97, neighbor_rules_const.all)
	-- r:add_neighbors(79, 98, neighbor_rules_const.all)
	-- r:add_neighbors(79, 99, neighbor_rules_const.all)
	-- r:add_neighbors(79, 100, neighbor_rules_const.all)
	-- r:add_neighbors(79, 101, neighbor_rules_const.all)
	-- r:add_neighbors(79, 102, neighbor_rules_const.all)
	-- r:add_neighbors(79, 79, neighbor_rules_const.all)

	-- horizontal
	-- r:add_neighbors(80, 86, neighbor_rules_const.right)
	-- r:add_neighbors(81, 86, neighbor_rules_const.left)

	-- r:add_neighbors(80, 102, neighbor_rules_const.right)
	-- r:add_neighbors(81, 102, neighbor_rules_const.left)

	-- r:add_neighbors(96, 96, neighbor_rules_const.right)
	-- r:add_neighbors(96, 96, neighbor_rules_const.left)

	-- r:add_neighbors(97, 97, neighbor_rules_const.right)
	-- r:add_neighbors(97, 97, neighbor_rules_const.left)


	-- vertical
	-- r:add_neighbors(80, 80, neighbor_rules_const.above)
	-- r:add_neighbors(80, 80, neighbor_rules_const.below)

	-- r:add_neighbors(81, 81, neighbor_rules_const.above)
	-- r:add_neighbors(81, 81, neighbor_rules_const.below)

	-- r:add_neighbors(96, 102, neighbor_rules_const.below)
	-- r:add_neighbors(97, 102, neighbor_rules_const.above)

	-- r:add_neighbors(96, 86, neighbor_rules_const.above)
	-- r:add_neighbors(97, 86, neighbor_rules_const.below)

	-- -- corners
	-- --todo: finish, add corners and edges to list
	-- r:add_neighbors(82, 80, neighbor_rules_const.above)
	-- r:add_neighbors(82, 97, neighbor_rules_const.left)
	-- r:add_neighbors(82, 86, neighbor_rules_const.below)
	-- r:add_neighbors(82, 86, neighbor_rules_const.right)

	-- r:add_neighbors(83, 81, neighbor_rules_const.above)
	-- r:add_neighbors(83, 86, neighbor_rules_const.left)
	-- r:add_neighbors(83, 86, neighbor_rules_const.below)
	-- r:add_neighbors(83, 97, neighbor_rules_const.right)

	-- r:add_neighbors(98, 86, neighbor_rules_const.above)
	-- r:add_neighbors(98, 96, neighbor_rules_const.left)
	-- r:add_neighbors(98, 80, neighbor_rules_const.below)
	-- r:add_neighbors(98, 86, neighbor_rules_const.right)

	-- r:add_neighbors(99, 86, neighbor_rules_const.above)
	-- r:add_neighbors(99, 86, neighbor_rules_const.left)
	-- r:add_neighbors(99, 81, neighbor_rules_const.below)
	-- r:add_neighbors(99, 96, neighbor_rules_const.right)

	
	-- r:add_neighbors(84, 81, neighbor_rules_const.above)
	-- r:add_neighbors(84, 96, neighbor_rules_const.left)
	-- r:add_neighbors(84, 102, neighbor_rules_const.below)
	-- r:add_neighbors(84, 102, neighbor_rules_const.right)

	-- r:add_neighbors(85, 81, neighbor_rules_const.above)
	-- r:add_neighbors(85, 102, neighbor_rules_const.left)
	-- r:add_neighbors(85, 102, neighbor_rules_const.below)
	-- r:add_neighbors(85, 96, neighbor_rules_const.right)

	-- r:add_neighbors(100, 102, neighbor_rules_const.above)
	-- r:add_neighbors(100, 97, neighbor_rules_const.left)
	-- r:add_neighbors(100, 81, neighbor_rules_const.below)
	-- r:add_neighbors(100, 102, neighbor_rules_const.right)

	-- r:add_neighbors(101, 102, neighbor_rules_const.above)
	-- r:add_neighbors(101, 102, neighbor_rules_const.left)
	-- r:add_neighbors(101, 80, neighbor_rules_const.below)
	-- r:add_neighbors(101, 97, neighbor_rules_const.right)


	


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
		if (#low_tiles == 255) then
			low_ent_tile = low_tiles[17] -- 1,1
		end

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

	log("")
	log("collapsed " .. x .. ", " .. y)
	log("mapgen:propogate")

	local tiles = self.mapdata.map_tiles
	for rule in all(self.rules) do
		rule:propogate(affected_tile, self.mapdata)
	end
end