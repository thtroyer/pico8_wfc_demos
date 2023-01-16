
neighbor_rules = {}
neighbor_rules_const = {
	above = 0,
	below = 1,
	right = 2,
	left = 3,
	all = 4
}

function neighbor_rules:new()
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o.list_of_neighbors_above = {}
	o.list_of_neighbors_below = {}
	o.list_of_neighbors_right = {}
	o.list_of_neighbors_left = {}

	return o
end

-- tile1 : int -- refers to sprite #
-- tile2 : int -- refers to sprite #
-- direction : int -- refers to a neighbor_rules_const value
function neighbor_rules:add_neighbors(tile1, tile2, direction)
	local neighbors = {}
	add(neighbors, tile1)
	add(neighbors, tile2)

	if (direction == neighbor_rules_const.above) then
		add(self.list_of_neighbors_above, neighbors)
	elseif (direction == neighbor_rules_const.below) then
		add(self.list_of_neighbors_below, neighbors)
	elseif (direction == neighbor_rules_const.right) then
		add(self.list_of_neighbors_right, neighbors)
	elseif (direction == neighbor_rules_const.left) then
		add(self.list_of_neighbors_left, neighbors)
	elseif (direction == neighbor_rules_const.all) then
		add(self.list_of_neighbors_above, neighbors)
		add(self.list_of_neighbors_below, neighbors)
		add(self.list_of_neighbors_right, neighbors)
		add(self.list_of_neighbors_left, neighbors)
	end
end

-- source : map_tile
-- mapdata:mapdata
-- returns void
function neighbor_rules:propogate(source, mapdata)
	-- log("rules above " .. tostring(self.list_of_neighbors_above))
	-- log("rules below " .. tostring(self.list_of_neighbors_below))
	-- log("rules right " .. tostring(self.list_of_neighbors_right))
	-- log("rules left " .. tostring(self.list_of_neighbors_left))
	local x = source.x
	local y = source.y
	local tiles = mapdata.map_tiles

	-- todo: propogating recursively isn't working quite right yet
	if not (x >= 15) then
		if (self:ortho(source, tiles, tiles[(x+1)+y*16], neighbor_rules_const.right)) then
			-- self:propogate(tiles[(x+1)+y*16], mapdata)
		end
	end
	
	if not (x <= 0) then
		if(self:ortho(source, tiles, tiles[(x-1)+y*16], neighbor_rules_const.left)) then
			-- self:propogate(tiles[(x-1)+y*16], mapdata)
		end
	end

	if not (y >= 15) then
		if (self:ortho(source, tiles, tiles[x+(y+1)*16], neighbor_rules_const.above)) then
			-- self:propogate(tiles[x+(y+1)*16], mapdata)
		end
	end

	if not (y <= 15) then
		if(self:ortho(source, tiles, tiles[x+(y-1)*16], neighbor_rules_const.below)) then
			-- self:propogate(tiles[x+(y-1)*16], mapdata)
		end
	end

end

-- update tiles param based on changes in source tile
-- 
-- source : map_tile
-- tiles : list<map_tile>
-- neighbor : map_tile
-- rules_const : int -- which rules to check
-- return boolean -- whether neighbor was updated
function neighbor_rules:ortho(source, tiles, target, rule_const)
	-- log("propogating changes to "..x..","..y)
	if (target == nil) then
		log("target not found")
		return
	end

	log("propogating changes to "..target.x..","..target.y)

	log(tostring(target))

	if (target:is_collapsed()) return false

	log("rule_const: " .. tostring(rule_const))
	local rules_to_check = nil

	if (rule_const == neighbor_rules_const.above) then
		rules_to_check = self.list_of_neighbors_above
	elseif (rule_const == neighbor_rules_const.below) then
		rules_to_check = self.list_of_neighbors_below
	elseif (rule_const == neighbor_rules_const.right) then
		rules_to_check = self.list_of_neighbors_right
	elseif (rule_const == neighbor_rules_const.left) then
		rules_to_check = self.list_of_neighbors_left
	else
		log("can't find rule," .. rule_const)
	end

	local states_to_rm = {}

	-- tn=tile_neighbor
	for tn in all(target.list_of_tiles) do
		local change = true
		-- ts = tile_source
		for ts in all(source.list_of_tiles) do
			for r in all(rules_to_check) do
				if (r[1] == ts and r[2] == tn)
				or (r[2] == ts and r[1] == tn) then
					change = false
				end
			end
		end
		if change then
			add(states_to_rm, tn)
		end
	end

	log("states_to_rm:" .. tostring(states_to_rm))

	if (#states_to_rm == 0) return false

	for t in all(states_to_rm) do
		target:remove(t)
	end

	log("neighbor now: " .. tostring(neighbor))

	log("rtn true")

	return true
end
