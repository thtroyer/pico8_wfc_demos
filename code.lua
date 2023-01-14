--snowball fight!
--a work in progress


-- global lists
players = {}
snowballs = {}
snowmen = {}

-- global timers
title_screen_timer = nil

-- global state
title_screen = false

-- utility methods

-- converts anything to string, even nested tables
function tostring(any)
    if type(any) == "function" then
        return "function"
    end
    if any == nil then
        return "nil"
    end
    if type(any) == "string" then
        return any
    end
    if type(any) == "boolean" then
        if any then
            return "true"
        end
        return "false"
    end
    if type(any) == "table" then
        local str = "{ "
        for k, v in pairs(any) do
            str = str .. tostring(k) .. "->" .. tostring(v) .. " "
            --str=str..tostring(k).."->".."n/a".." "
        end
        return str .. "}"
    end
    if type(any) == "number" then
        return "" .. any
    end
    return "unknown"
end

function random(minimum, maximum)
    return rnd(maximum - minimum) + minimum
end

function random_int(low, high)
    return flr(rnd(high + 1 - low)) + low
end

function log(msg)
    printh(msg, "log.txt", false)
end

function debug(msg)
    print(msg, 20, 20, 7)
end

-- global game logic functions
function handle_controllers()
    for i, player in pairs(players) do
        local mov_x = 0
        if (btn(⬅️, i - 1)) then
            mov_x = -1
        elseif (btn(➡️, i - 1)) then
            mov_x = 1
        end

        local mov_y = 0
        if (btn(⬆️, i - 1)) then
            mov_y = -1
        elseif (btn(⬇️, i - 1)) then
            mov_y = 1
        end

        player:move(mov_x, mov_y)

        if (btn(🅾️, i-1)) then
    add(snowballs, player:throw_snowball())
        end
    end
end

function title_controllers()
    if not title_timer == nil then
        return
    end

    if (btnp(❎, 0)
            or btnp(❎, 1)
            or btnp(🅾️, 0)
    or btnp(🅾️,1)) then
    title_timer = 30
    sfx(1)
    end
end

function update_snowballs()
    for s in all(snowballs) do
        if (s ~= nil) s:update()
        end

        for s in all(snowballs) do
            if s.frames_left == 0 then
                del(snowballs, s)
                break
            end
        end
    end

    function update_players()
        for p in all(players) do
            p:update()
        end
    end

    function update_snowmen()
        for s in all(snowmen) do
            s:update()
        end
    end

    function collide(x1, x1s, y1, y1s, z1, z1s, x2, x2s, y2, y2s, z2, z2s)


        if ((x1 + x1s) > x2) and ((x2 + x2s) > x1) then
            if ((y1 + y1s) > y2) and ((y2 + y2s) > y1) then
                if ((z1 + z1s) > z2) and ((z2 + z2s) > z1) then
                    return true
                end
            end
        end
        return false

        --	if (player.x+8 > self.x) and (self.x+16 > player.x) then
        --	if (player.y+5 > self.y) and (self.y+31 > player.y) then
        --		player:run_over()
        --	end
        --	end
    end

    function entitycollide(e1, e2)
        return collide(
                e1.x + e1.xoff,
                e1.xsize,
                e1.y + e1.xoff,
                e1.ysize,
                e1.z,
                e1.zsize,
                e2.x + e2.xoff,
                e2.xsize,
                e2.y + e2.xoff,
                e2.ysize,
                e2.z,
                e2.zsize
        )
    end

    --deprecated
    function entitycollide_bak(e1, e2)
        return collide(
                e1.x + e1.xoff,
                e1.xsize,
                e1.y + e1.xoff,
                e1.ysize,
                e2.x + e2.xoff,
                e2.xsize,
                e2.y + e2.xoff,
                e2.ysize)
    end

    function detect_collisions()
        for s in all(snowballs) do
            if (s.active) then
                for t in all(snowmen) do
                    --if collide(s.x+4,1,s.y+4,1,t.x,8,t.y,8) then
                    if (entitycollide(s, t)) then
                        t:hit()
                        s:hit()
                    end
                end
            end
        end

        for s in all(snowballs) do
            if (s.active) then
                for p in all(players) do
                    if (entitycollide(p, s)) then
                        if (s.thrower ~= p) then
                            p:hit(s)
                            s:hit()
                        end
                    end
                end
            end
        end
    end

    function generate_map()

    end

    -- pico-8 hooks
    function _init()
        --	title_screen = true
        --	draw_title_screen()
        add(players, player:new(10, rnd(20) + 20, 1))
        add(players, player:new(5, rnd(20) + 40, 2))
        add(snowmen, snowman:new())
        add(snowmen, snowman:new())

        --test
        --mset(4,4,66)
        local mapgen = mapgen:new()
        mapgen:generate()
        mapgen:draw()
    end

    function _update()
        --[[
        if title_screen then
            title_controllers()
            if not (title_timer == nil) then
                title_timer -= 1
            end
            if title_timer == 0 then
                title_screen = false
                music(0)
            end
            return
        end
        ]]

        handle_controllers()
        update_players()
        update_snowballs()
        update_snowmen()
        detect_collisions()
    end

    function draw_title_screen()
        cls()
        print('snowball fight!', 26, 16, 0)
        print('snowball fight!', 25, 15, 7)
        print('press ❎ / 🅾️', 39, 116, 0)
        print('press ❎ / 🅾️', 38, 115, 7)
    end

    function _draw()
        if title_screen then
            return
        end

        cls()
        map()
        foreach(snowballs, function(o)
            o:draw()
        end)
        foreach(snowmen, function(o)
            o:draw()
        end)
        foreach(players, function(o)
            o:draw()
        end)
    end

    -->8
    -- player object
    player = {}

    function player:new(x, y, player_id)
        local o = {}
        setmetatable(o, self)
        self.__index = self
        o.x = x or 10
        o.y = y or 20
        o.dx = 0
        o.dy = 0
        o.z = 0
        o.xsize = 8
        o.ysize = 8
        o.zsize = 15
        o.xoff = 0
        o.yoff = 0
        o.zoff = 0
        o.hitdx = 0
        o.hitdy = 0

        o.looking_dir = "⬇️"
        o.walk_timer = nil
        o.walk_state = 0
        o.hearts = 3
        o.player_id = player_id
        o.hit_timer = nil
        o.flicker = false
        o.throw_timer = nil

        o.sprite_id = 1
        if (player_id == 1) then
            o.sprite_id = 2
        end
        return o
    end

    function player:draw()
        self:countdown_timer()

        if (self.hearts <= 0) then
            return
        end

        local so = (self.player_id - 1) * 3
        -- disabling walking animation for now
        --	spr(self.sprite_id, self.x, self.y, 1, 1, self.is_looking_left)
        if (self.looking_dir == "⬆️⬅️") then
            spr(128 + so, self.x, self.y, 1, 1)
        elseif (self.looking_dir == "⬆️") then
            spr(129 + so, self.x, self.y, 1, 1)
        elseif (self.looking_dir == "⬆️➡️") then
            spr(130 + so, self.x, self.y, 1, 1)
        elseif (self.looking_dir == "⬅️") then
            spr(144 + so, self.x, self.y, 1, 1)
        elseif (self.looking_dir == "➡️") then
            spr(146 + so, self.x, self.y, 1, 1)
        elseif (self.looking_dir == "⬇️⬅️") then
            spr(160 + so, self.x, self.y, 1, 1)
        elseif (self.looking_dir == "⬇️") then
            spr(161 + so, self.x, self.y, 1, 1)
        elseif (self.looking_dir == "⬇️➡️") then
            spr(162 + so, self.x, self.y, 1, 1)
        end

        --[[

        sprite_id = self.sprite_id
        if (self.walk_state == 1) then
            sprite_id += 1
        elseif (self.walk_state == 3) then
            sprite_id += 2
        end

        if not (self.hit_timer == nil) then
            self.flicker = not self.flicker
            if (self.flicker == false) then
                spr(sprite_id, self.x, self.y, 1, 1, self.is_looking_left)
            end
        else
            spr(sprite_id, self.x, self.y, 1, 1, self.is_looking_left)
        end
        ]]
        self:draw_hearts()
    end

    function player:countdown_timer()
        -- countdown hit timer
        if not (self.hit_timer == nil) then
            self.hit_timer -= 1
        if (self.hit_timer <= 0) then
            self.hit_timer = nil
            self.flicker = false
            end
        end
    end

    function player:move(mov_x, mov_y)

        if (mov_x == 0 and mov_y == 0) then
            self.walk_timer = nil
            self.walk_state = 0
            return
        end

        if (self.walk_timer == nil) then
            self.walk_timer = 5
        end
        if (self.walk_timer == 0) then
            self.walk_timer = 5
            self.walk_state += 1
        if self.walk_state > 3 then
        self.walk_state = 0
            end
        end

        if not (self.hit_timer == nil) then
            self.dx = mov_x * 0.3
            self.dy = mov_y * 0.3
        else
            self.dx = mov_x
            self.dy = mov_y
        end

        self.looking_dir = ""

        if (mov_y == 1) self.looking_dir = self.looking_dir .. "⬇️"
            if (mov_y == -1) self.looking_dir = self.looking_dir .. "⬆️"

                if (mov_x == 1) self.looking_dir = self.looking_dir .. "➡️"
                    if (mov_x == -1) self.looking_dir = self.looking_dir .. "⬅️"

                        self.x += self.dx
                    self.y + = self.dy

                    -- boundries
                    if self.y > 130 then
                    self.y = 130
                    elseif self.y < -8 then
                    self.y = -8
                    end

                    if self.x > 130 then
                    self.x = 130
                        elseif self.x < -8 then
                        self.x = -8
                        end
                    end

                    function player:throw_snowball()
                        if not (self.throw_timer == nil) then
                            return
                        end

                        self.throw_timer = 13

                        local s = snowball:new(self.x, self.y + 2, self)

                        --if (sub(self.looking_dir, 2, 2) == "⬅️") then
                        if (self.looking_dir == "⬅️") then
                            s.dx = -3 + random(-.04, .04)
                            s.dy = random(-.15, .15)
                        elseif (self.looking_dir == "➡️") then
                            s.dx = 3 + random(-.04, .04)
                            s.dy = random(-.15, .15)
                        end

                        if (self.looking_dir == "⬆️") then
                            s.dy = -3 + random(-.04, .04)
                            s.dx = random(-.15, .15)
                        elseif self.looking_dir == "⬇️" then
                            s.dy = 3 + random(-.04, .04)
                            s.dx = random(-.15, .15)
                        end

                        s.dz = 2.5

                        return s
                    end

                    function player:draw_hearts()
                        if (1 == 1) then
                            return
                        end
                        spr(24 + self.player_id, 0, (self.player_id * 10) - 7)
                        for i = 1, self.hearts, 1 do
                            spr(24, 7 + ((i - 1) * 15), (self.player_id * 8) - 8 + 3)
                        end
                    end

                    function player:hit(snowball)
                        self.hitdx += (snowball.dx/2)
                        self.hitdy + = (snowball.dy/2)
                    end

                    function sign(x)
                        return x / abs(x)
                    end

                    function player:update()
                        self.x += self.hitdx
                        self.y + = self.hitdy

                        self.hitdx - = sign(self.hitdx) * .5
                        self.hitdy - = sign(self.hitdy) * .5
                        if (self.hitdx < 0.1) self.hitdx = 0
                        if (self.hitdy < 0.1) self.hitdy = 0

                        if not (self.throw_timer == nil) then
                        self.throw_timer - = 1
                        if (self.throw_timer == 0) self.throw_timer = nil
                        end
                        end
                        -->8
                        -- snowball and snow particle objects
                        snowball = {}
                        spart = {}

                        function spart:new(x, y, z, dx, dy, dz)
                        local o = {}
                        setmetatable(o, self)
                        self.__index = self

                        o.x = x
                        o.y = y
                        o.z = z
                        o.grav = -0.5

                        o.dx = dx
                        o.dy = dy
                        o.dz = dz

                        o.frames_left = random_int(40, 300)

                        return o
                        end

                        function spart:update()
                        self.frames_left -= 1
                        if (self.frames_left == 0) return

                        self.x + = self.dx
                        self.y + = self.dy
                        self.dz + = self.grav
                        self.z + = self.dz

                        if (self.z <= 0) then
                        self.z = 0
                        self.dx = 0
                        self.dy = 0
                        end
                        end

                        function spart:draw()
                        if (self.frames_left <= 0) return
                        pset(self.x+4, self.y+4 - (self.z/2), 7)
                        end

                        function snowball:new(x, y, thrower)
                        local o = {}
                        setmetatable(o, self)
                        self.__index = self

                        o.x = x
                        o.y = y
                        o.sprite_id = 0
                        o.z = 0
                        o.shadow = true

                        o.dx = 0
                        o.dy = 0
                        o.dz = 0
                        o.grav = -0.25
                        o.active = true

                        o.xoff = 4
                        o.yoff = 4
                        o.xsize = 2
                        o.ysize = 2
                        o.zsize = 2

                        o.thrower = thrower

                        o.frames_left = random_int(300,600)
                        o.particles = {}

                        return o
                        end

                        function snowball:update()
                        self.frames_left - = 1
                        if (self.frames_left == 0) return

                        self.x + = self.dx
                        self.y + = self.dy
                        self.dz + = self.grav
                        self.z + = self.dz
                        if (self.z <= 0) then
                        if (self.dz ~= self.grav) then
                        self:splat()
                        end
                        self.z = 0
                        self.dx = 0
                        self.dy = 0
                        self.dz = 0
                        end

                        for p in all(self.particles) do
                        p:update()
                        end

                        if random_int(0, 100) <= 2 then
                        add(self.particles,
                        spart:new(self.x, self.y, self.z,
                        self.dx/2, self.dy/2, self.dz)
                        )
                        end
                        end

                        function snowball:splat()
                        if ( not self.active) return

                        for i = 1, random_int(10, 16), 1 do
                        add(
                        self.particles,
                        spart:new(
                        self.x, self.y, self.z,
                        self.dx/2 + random(-0.4, 0.4), self.dy/2 + random(-0.4, 0.4), 1.2 + random(-1, 1)
                        )
                        )
                        end
                        self.active = false
                        end

                        function snowball:hit()
                        local xpos = 1
                        local xneg = -1
                        local ypos = 1
                        local yneg = -1

                        if (self.dx>1) then
                        xpos= 0
                        elseif (self.dx < -1) then
                        xneg = 0
                        end
                        if (self.dy>1) then
                        ypos = 0
                        elseif (self.dy < -1) then
                        yneg = 0
                        end


                        for i = 1, random_int(5, 8), 1 do
                        add(
                        self.particles,
                        spart:new(
                        self.x, self.y, self.z,
                        random(xneg, xpos),
                        random(yneg, ypos),
                        1 + random(-.5, .5)
                        )
                        )
                        end
                        self.active = false
                        self.dx = 0
                        self.dy = 0
                        self.dz = 0
                        end

                        function snowball:is_down()
                        return self.z == 0
                        end

                        function snowball:draw()
                        if (self.frames_left == 0) return

                        self.shadow = not self.shadow
                        spr(self.sprite_id, self.x, self.y-(self.z/2))
                        if (self.z ~= 0 and self.shadow) then
                        spr(20, self.x, self.y)
                        end

                        for p in all(self.particles) do
                        p:draw()
                        end
                        end


                        -->8
                        -- snowman target
                        snowman = {}

                        function snowman:new()
                        local o = {}
                        setmetatable(o, self)
                        self.__index = self

                        o.xoff = 0
                        o.yoff = 0
                        o.xsize = 8
                        o.ysize = 12
                        o.z = 0
                        o.zsize = 30

                        o.x = random_int(64, 120)
                        o.y = random_int(20, 114)
                        o.health = 100
                        o.flipx = random_int(0, 1) == 0

                        return o
                        end

                        function snowman:checkcollision(snowball)
                        end

                        function snowman:hit()
                        self.health - = 10
                        self.zsize = 30 - (self:states()*3)
                        end

                        function snowman:update()
                        --self.health -= 1
                        end

                        function snowman:states()
                        local h = self.health
                        if (h >= 90) return 0
                        if (h <= 90 and h > 60) return 1
                        if (h <= 60 and h > 30) return 2
                        if (h <= 30 and h > 0) return 3
                        if (h <= 0) return 4
                        end

                        function snowman:draw()
                        sprite = 42 + self:states()
                        spr(sprite,
                        self.x, self.y-8,
                        1, 2,
                        self.flipx)

                        end
                        -->8
                        -- mapdata and mapgen
                        mapgen = {}
                        mapdata = {}

                        function mapdata:new()
                        local o = {}
                        setmetatable(o, self)
                        self.__index = self

                        -- list<map_tiles>
                        o.map_tiles = {}
                        log("mapdata:new()")
                        return o
                        end


                        function mapdata:initialize()
                        local map_tiles = {}

                        log("generating map tiles")
                        for y = 0, 15 do
                        for x = 0, 15 do
                        log(x..","..y)
                        log(x+y*16)
                        log("adding " .. x+y*16)
                        map_tiles[x+y*16] = maptile:new(64, 65)
                        map_tiles[x+y*16].x = x
                        map_tiles[x+y*16].y = y
                        map_tiles[x+y*16]:add(102)
                        map_tiles[x+y*16]:add(103)
                        map_tiles[x+y*16]:add(86)
                        map_tiles[x+y*16]:add(87)
                        map_tiles[x+y*16]:add(70)
                        map_tiles[x+y*16]:add(71)
                        end
                        log(tostring(map_tiles))
                        end
                        self.map_tiles = map_tiles
                        end

                        -- x: int, y: int
                        -- returns map_tile
                        function mapdata:get_maptile(x, y)
                        return self.map_tiles[x+y*16]
                        end

                        -- x: int, y: int
                        -- returns list<map_tile>
                        function mapdata:get_maptile_neighbors(x, y)
                        function add_if_notnil(list, i)
                        if ( not (i == nil)) then
                        add(list, i)
                        end
                        return list
                        end

                        neighbors = {}
                        neighbors = add_if_notnil(self.get_maptile(x+1, y))
                        neighbors = add_if_notnil(self.get_maptile(x-1, y))
                        neighbors = add_if_notnil(self.get_maptile(x,y+1))
                        neighbors = add_if_notnil(self.get_maptile(x, y-1))
                        return neighbors
                        end

                        -- find tiles with lowest entropy
                        -- returns list<maptile>
                        function mapdata:lowest()
                        local lowest_entropy = 9999
                        local l_list = {}

                        for t in all(self.map_tiles) do
                        if not t:is_collapsed() then
                        local ent = t:entropy()
                        if ent == lowest_entropy then
                        add(l_list, t)
                        elseif ent < lowest_entropy then
                        lowest_entropy = ent
                        l_list = {}
                        add(l_list, t)
                        end
                        end
                        end

                        log("found " .. count(l_list))
                        return l_list
                        end

                        --todo: cleanup below
                        -- keep migrating to use mapobj

                        function mapgen:new()
                        local o = {}
                        setmetatable(o, self)
                        self.__index = self

                        self.rules = {}

                        local r = neighbor_rules:new()
                        r:add_neighbors(102, 65)
                        r:add_neighbors(86, 102)
                        r:add_neighbors(102,103)
                        r:add_neighbors(86, 86)
                        r:add_neighbors(86, 87)
                        r:add_neighbors(86, 70)
                        r:add_neighbors(70, 70)
                        r:add_neighbors(70,71)
                        r:add_neighbors(71, 71)
                        add(self.rules, r)
                        o.map_tiles = {}

                        o.mapdata = mapdata:new()
                        return o
                        end

                        function mapgen:generate()
                        log("mapgen:generate()")
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
                        log("low tiles")
                        log(tostring(low_tiles))

                        while not (#low_tiles == 0) do
                        log("low tiles")
                        log(tostring(low_tiles))

                        -- find lowest entropy
                        local low_ent_tile = rnd(low_tiles)
                        log("collapsing tile " .. low_ent_tile.x .. ", " .. low_ent_tile.y)
                        low_ent_tile:collapse()

                        -- propogate tile changes
                        self:propogate(low_ent_tile)

                        self:print_all_states(map_tiles)

                        low_tiles = self.mapdata:lowest()
                        end
                        end

                        function mapgen:draw()
                        --log("drawing map")
                        local map_tiles = self.mapdata.map_tiles
                        -- draw map
                        for x = 0,15, 1 do
                        for y = 0, 15, 1 do
                        --			log(x .. ", " .. y)
                        --			log(map_tiles[x+y*16].tile)
                        mset(x, y, map_tiles[x+y*16].tile)
                        end
                        end
                        end

                        function mapgen:print_all_states(tiles)
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
                        --	self.rules:propogate(affected_tile, tiles, x+1, y)
                        --	self.rules:propogate(affected_tile, tiles, x-1, y)
                        --	self.rules:propogate(affected_tile, tiles, x, y+1)
                        --	self.rules:propogate(affected_tile, tiles, x, y-1)
                        end
                        -->8
                        -- maptile
                        maptile = {}

                        function maptile:new()
                        local o = {}
                        setmetatable(o, self)
                        self.__index = self

                        o.list_of_tiles = {}

                        o.tile = nil
                        o.x = nil
                        o.y = nil

                        return o
                        end

                        function maptile:entropy()
                        return count(self.list_of_tiles)
                        end

                        function maptile:is_collapsed()
                        return not (self.tile == nil)
                        end

                        function maptile:add(tile)
                        add(self.list_of_tiles, tile)
                        end

                        function maptile:remove(tile)
                        log("removing"..tile .." from " ..x..","..y)
                        del(self.list_of_tiles, tile)
                        for s in all(self.list_of_tiles) do
                        log("s: " ..s)
                        end
                        end

                        function maptile:collapse()
                        if (self:is_collapsed()) then
                        log("already collapsed")
                        return
                        end

                        log("collapsing")
                        log("tiles:")
                        log(self.list_of_tiles)
                        log(count(self.list_of_tiles))
                        if (count(self.list_of_tiles) == 0) then
                        self.tile = 86
                        log ("something broke")
                        return
                        end
                        self.tile = rnd(self.list_of_tiles)

                        -- draw once collapsed
                        cls()
                        mset(self.x, self.y, self.tile)
                        map()
                        log("mset " .. self.x .. "," .. self.y .. " as " .. self.tile)

                        self.list_of_tiles = {}
                        add(self.list_of_tiles, self.tile)
                        log("tile: " .. self.tile)
                        log(self:is_collapsed())
                        end
                        -->8
                        -- rules
                        neighbor_rules = {}

                        function neighbor_rules:new()
                        local o = {}
                        setmetatable(o, self)
                        self.__index = self

                        o.list_of_nbrs = {}

                        return o
                        end

                        function neighbor_rules:add_neighbors(tile1, tile2)
                        local neighbors = {}
                        add(neighbors, tile1)
                        add(neighbors, tile2)

                        add(self.list_of_nbrs, neighbors)
                        end

                        -- source : map_tile
                        -- mapdata:mapdata
                        -- returns void
                        function neighbor_rules:propogate(source, mapdata)
                        local x = source.x
                        local y = source.y
                        self:ortho(source, mapdata.map_tiles, x+1, y)
                        self:ortho(source, mapdata.map_tiles, x-1, y)
                        self:ortho(source, mapdata.map_tiles, x, y+1)
                        self:ortho(source, mapdata.map_tiles, x, y-1)
                        end

                        -- source : map_tile
                        -- tiles : list<map_tile>
                        -- x : int, y : int
                        -- return void
                        function neighbor_rules:ortho(source, tiles, x, y)
                        log("propogating changes to "..x..","..y)
                        neighbor = tiles[x+y*16]
                        if (neighbor == nil) then
                        log("neighbor not found")
                        return
                        end

                        local states_to_rm = {}

                        -- tn=tile_neighbor
                        for tn in all(neighbor.list_of_tiles) do
                        local change = true
                        -- ts = tile_source
                        local ts = source.tile
                        for r in all(self.list_of_nbrs) do
                        if (r[1] == ts and r[2] == tn)
                        or (r[2] == ts and r[1] == tn) then
                        log("----found match")
                        change = false
                        end
                        end
                        if change then
                        log("deleting from " .. neighbor.x .. ", " .. neighbor.y .. "; " .. tn)
                        --del(neighbor.list_of_tiles, tn)
                        --neighbor:remove(tn)
                        add(states_to_rm, tn)
                        end
                        end

                        log("bork2")
                        log(count(states_to_rm))
                        for t in all(states_to_rm) do
                        log("bork")
                        neighbor:remove(t)
                        end
                        end
