
count_rules = {} 

function count_rules:new()
    local o = {}
    setmetatable(o,self)
    self.__index = self

    o.counts = {}
    o.counts[66] = 2

    return o
end

-- source : map_tile
-- mapdata:mapdata
-- returns void
function count_rules:propagate(source, mapdata)
    for k,v in pairs(self.counts) do
        if (source.tile == k) then
            local count = self.counts[k]

            count -= 1

            if (count <= 0) then
                for m in all(mapdata.map_tiles) do
                    m:remove(k)
                end
            end
            self.counts[k] = count
        end
    end
end

