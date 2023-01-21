
neighbor_rules = {
	-- consts
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
-- direction : int -- refers to a neighbor_rules const 
function neighbor_rules:add_neighbors(tile1, direction, tile2)
	local neighbors = {}
	add(neighbors, tile1)
	add(neighbors, tile2)
	local swapped_neighbors = {}
	add(swapped_neighbors, tile2)
	add(swapped_neighbors, tile1)


	log("adding neighbors " .. tostring(neighbors) .. " to " .. direction)

	if (direction == neighbor_rules.above) then
		add(self.list_of_neighbors_above, neighbors)
		add(self.list_of_neighbors_below, swapped_neighbors)
	elseif (direction == neighbor_rules.below) then
		add(self.list_of_neighbors_below, neighbors)
		add(self.list_of_neighbors_above, swapped_neighbors)
	elseif (direction == neighbor_rules.right) then
		add(self.list_of_neighbors_right, neighbors)
		add(self.list_of_neighbors_left, swapped_neighbors)
	elseif (direction == neighbor_rules.left) then
		add(self.list_of_neighbors_left, neighbors)
		add(self.list_of_neighbors_right, swapped_neighbors)
	elseif (direction == neighbor_rules.all) then
		-- recurse to add all directions
		self:add_neighbors(tile1, neighbor_rules.above, tile2) 
		self:add_neighbors(tile1, neighbor_rules.below, tile2) 
		self:add_neighbors(tile1, neighbor_rules.left, tile2) 
		self:add_neighbors(tile1, neighbor_rules.right, tile2) 
	end
end

-- public
-- updates list_of_neighbors_*
-- returns void
function neighbor_rules:deduplicate_rules()
	self:deduplicate_rule(self.list_of_neighbors_above)
	self:deduplicate_rule(self.list_of_neighbors_below)
	self:deduplicate_rule(self.list_of_neighbors_left)
	self:deduplicate_rule(self.list_of_neighbors_right)
end

-- private
-- updates passed &rules
-- ensures there arne't any duplicate rules to cycle through
--
-- returns void
function neighbor_rules:deduplicate_rule(rules)
	local newrules = {}
	local foundrules = {}
	for k,v in pairs(rules) do
		local hashval = tostring(v)
		if (not foundrules[hashval]) then
			foundrules[hashval] = true
			add(newrules, v)
		end
	end

	rules = newrules
end

-- source : map_tile
-- mapdata:mapdata
-- returns void
function neighbor_rules:propogate(source, mapdata)
	local x = source.x
	local y = source.y
	local tiles = mapdata.map_tiles

	if not (x >= 15) then
		if (self:update(source, tiles, tiles[(x+1)+y*16], neighbor_rules.left)) then
			self:propogate(tiles[(x+1)+y*16], mapdata)
		end
	end
	
	if not (x <= 0) then
		if(self:update(source, tiles, tiles[(x-1)+y*16], neighbor_rules.right)) then
			self:propogate(tiles[(x-1)+y*16], mapdata)
		end
	end

	if not (y >= 15) then
		if (self:update(source, tiles, tiles[x+(y+1)*16], neighbor_rules.above)) then
			self:propogate(tiles[x+(y+1)*16], mapdata)
		end
	end

	if not (y <= 0) then
		if(self:update(source, tiles, tiles[x+(y-1)*16], neighbor_rules.below)) then
			self:propogate(tiles[x+(y-1)*16], mapdata)
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
function neighbor_rules:update(source, tiles, target, rule_const)
	if (target == nil) then
		log("target not found")
		return
	end

	log("propogating changes to "..target.x..","..target.y)

	log(tostring(target))

	if (target:is_collapsed()) return false

	log("rule_const: " .. tostring(rule_const))
	local rules_to_check = nil

	if (rule_const == neighbor_rules.above) then
		rules_to_check = self.list_of_neighbors_above
	elseif (rule_const == neighbor_rules.below) then
		rules_to_check = self.list_of_neighbors_below
	elseif (rule_const == neighbor_rules.right) then
		rules_to_check = self.list_of_neighbors_right
	elseif (rule_const == neighbor_rules.left) then
		rules_to_check = self.list_of_neighbors_left
	else
		log("can't find rule," .. rule_const)
	end

	log(" rules to compare: " .. tostring(rules_to_check))

	local states_to_rm = {}

	-- tn=tile_neighbor
	for tn in all(target.list_of_tiles) do
		local change = true
		-- ts = tile_source
		for ts in all(source.list_of_tiles) do
			for r in all(rules_to_check) do
				if (r[1] == ts and r[2] == tn) then
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

	log("neighbor now: " .. tostring(target))

	log("rtn true")

	return true
end
