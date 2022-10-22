pico-8 cartridge // http://www.pico-8.com
version 38
__lua__
--snowball fight!
--a work in progress


-- global lists
players = {}
snowballs = {}
cars = {}

-- global timers
car_timer = nil
title_screen_timer = nil

-- global state
title_screen = false

-- utility methods
function random(minimum, maximum)
	return rnd(maximum-minimum) + minimum
end

function random_int(low, high)
	return flr(rnd(high+1-low))+low
end

function log(msg)
	printh(msg, "log.txt", false)
end

function debug(msg)
	print(msg, 20, 20, 7)
end


-- global game logic functions
function handle_controllers()
	for i,player in pairs(players) do
		local mov_x = 0
		if(btn(⬅️,i-1)) then
			mov_x = -1
			elseif(btn(➡️,i-1)) then
			mov_x = 1
		end

		local mov_y = 0
		if(btn(⬆️,i-1)) then mov_y = -1
		elseif(btn(⬇️,i-1)) then mov_y = 1 end

		player:move(mov_x, mov_y)
		
		if(btnp(🅾️,i-1)) then
			add(snowballs, player:throw_snowball())
		end
	end
end


function title_controllers()
	if not title_timer == nil then
		return
	end
	
	if(btnp(❎,0)
			or btnp(❎,1)  
			or btnp(🅾️,0)  
			or btnp(🅾️,1)) then
		title_timer = 30
		sfx(1)
	end
end

function update_snowballs()
	for s in all(snowballs) do
		if (s ~= nil) s:update()
	end
	
	if count(snowballs) > 10 then
		for s in all(snowballs) do
			if s:is_down() then
				del(snowballs, s)
				break
			end
		end
	end
end

-- pico-8 hooks
function _init()
--	title_screen = true
--	draw_title_screen()
	add(players, player:new(10,rnd(20)+20,1))
	add(players, player:new(5,rnd(20)+40,2)) 
	
	car_timer = random(1*30, 3*30)
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
	update_snowballs()
end

function draw_title_screen()
		cls()
		print('snowball fight!', 26, 16, 0)
		print('snowball fight!', 25, 15, 7)
		print('press ❎ / 🅾️', 39, 116, 0)
		print('press ❎ / 🅾️', 38, 115, 7)
		return	
end

function _draw()
	if title_screen then
		return
	end
	
	cls()
	map()
	foreach(snowballs, function(o) o:draw() end)
	foreach(players, function(o) o:draw() end)
	--foreach(cars, function(o) o:draw() end)
end

-->8
-- player object
player = {}

function player:new(x,y,player_id)
	local o = {}
	setmetatable(o,self)
	self.__index = self
	o.x = x or 10
	o.y = y or 20
	o.dx = 0
	o.dy = 0
	o.is_looking_left = false
	o.walk_timer = nil
	o.walk_state = 0
	o.hearts = 3
	o.player_id = player_id
	o.hit_timer = nil
	o.flicker = false
	
	o.sprite_id = 1
	if(player_id == 1) then
		o.sprite_id = 2
	end
	return o
end

function player:draw()
	self:countdown_timer()
	
	if (self.hearts <= 0) then
		return
	end
	
	-- disabling walking animation for now
	spr(self.sprite_id, self.x, self.y, 1, 1, self.is_looking_left)	

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

	if (mov_x == 1) then
		self.is_looking_left = false
	elseif (mov_x == -1) then
		self.is_looking_left = true
	end

	self.x += self.dx
	self.y += self.dy

	self.walk_timer -= 1
	
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

function player:pickup(trashes)
	if (self.trash_obj != nil) then
		self.trash_obj = nil
		sfx(1)
		return
	end

	for i,trash in pairs(trashes) do
		if (trash.x > (self.x-8)) and (trash.x < (self.x+8)) then
			if (trash.y > (self.y-8)) and (trash.y < (self.y+8)) then
				self.trash_obj = trash
				sfx(2)
				break
			end
		end
	end
end

function player:run_over()
	if self.hit_timer == nil then
		sfx(3)
		self.hit_timer = 150
		self.hearts -= 1
	end
end

function player:throw_snowball()
	local s = snowball:new(self.x, self.y)
	
	if (self.is_looking_left) do
		s.dx = -3 + random(-.04,.04)
		s.dy = random(-.15,.15)
	else
		s.dx = 3 + random(-.04, .04)
		s.dy = random(-.15,.15)
	end
	s.dz = 5

	return s
end

function player:draw_hearts()
	spr(24+self.player_id, 0, (self.player_id * 10) - 7)
	for i = 1,self.hearts,1 do
		spr(24, 7 + ((i-1)*5), (self.player_id * 8)-8 + 3)
	end
end

-->8
-- snowball object
snowball = {}

function snowball:new(x, y)
	local o = {}
	setmetatable(o,self)
	self.__index = self
	
	o.x = x
	o.y = y
	o.sprite_id = 0
	o.z = 0
	o.shadow = true

	o.dx = 0
	o.dy = 0
	o.dz = 0
	o.grav = -0.5
	
	return o
end

function snowball:update()
	self.x += self.dx
	self.y += self.dy
	self.dz +=	self.grav
	self.z += self.dz
	if (self.z <= 0) do
		self.z = 0
		self.dx = 0
		self.dy = 0
	end 
end

function snowball:is_down()
	return self.z == 0
end

function snowball:draw()
	self.shadow = not self.shadow
	spr(self.sprite_id, self.x, self.y-(self.z/2))
	if (self.z ~= 0 and self.shadow) do
		spr(20, self.x, self.y)
	end
end


__gfx__
00000000000ccc000008880000000000000000000000000000000000000000000000000000000000000000000000000000008888888800000000222222220000
0000000000c4ffc0008aff8000000000000000000000000000000000000000000000000000000000000000000000000000888888888888000022222222222200
0000000000c4f1c0008af18000000000000000000000000000067000000000000000000000000000000000000000000003668888888866300266222222226620
0007700000c4ffc0008aff80068ee70000aaa000000ccc00007677000008e00000eee000000dd00000000000000000008a888888888888a82a222222222222a2
00076000000c4c000008a80006888600009aa000000ccc0007767000000880000088e000001ddd00000000000000000088888888888888882222222222222222
000000000009cc90000e88e005288600000900000001cc0000dd6000000880000000000000010000000000000000000088888888888888882222222222222222
0000000000055500000ddd0000000000000000000000000000000000000000000000000000000000000000000000000088881111111188882222111111112222
0000000000050500000d0d0000000000000000000000000000000000000000000000000000000000000000000000000018111111111111811211111111111121
555555555555555555577555555555550000000000000000000a0a00000000000000000000000000088000880000000011111111111161111111111111116111
5557755555555555555775555555555500000000000000000000a00000000000000000000004440008e888e80000000011111111111111111111111111111111
555775555555555555577555555555550000000000000000011a11100000000000000000004fff40008eee8000000000e11111111111111e2111111111111112
55577555555555555557755577777777000010000000000011111111000000000000000004f5f5f408e1e1e800000000eeeeeeeeeeeeeeee2222222222222222
55577555555555555557755577777777000111000000000011111611000000000008080004fffff408ee8ee800000000e1eeeeeeee77771e2122222222333312
5557755555555555555775555555555500001000000000001111111100000000008e878004f888f408eeeee800000000e1eeeeeeeeeeee1e2122222222222212
55577555555555555557755555555555000000000000000011111111000000000008e800040fff04008eee8000000000e1eeeeeeeeeeee1e2122222222222212
555555555555555555577555555555550000000000000000011111100000000000008000040000040000000000000000e1eeeeeeeeeeee1e2122222222222212
6666666666666666bbbbbbbbbbbbbbbb66666666bbbbbbbb000000000000000000000000000000000000000000000000e1eeeeeeeeeeee1e2122222222222212
6666666666666666bbbbbbbbbbbbbbbb66666666bbbbabbb000000000000000000000000000000000000000000000000e1eeeeeeeeeeee1e2122222222222212
6666666666666666bbbbbb3bbbbbbbbb66666666bbbaaabb000000000000000000000000000000000000000000000000e1eeeeeeeeeeee1e2122222222222212
6666666666666666bbbbbb3bbbbbbbbb66666666bbbb3bbb000000000000000000000000000000000000000000000000e1eeeeeeeeeeee1e2122222222222212
5555555566666666b3bbbbbbbbbbb3bb66666666bbb333bb000000000000000000000000000000000000000000000000ee1eeeeeeeeee1ee2212222222222122
6666666666666666b3bbbbbbbbbbb3bb66666666bbbb3bbb0000000000000000000000000000000000000000000000001eeeeeeeeeeeeee11222222222222221
6666666666666666bbbbbbbbbbbbbbbb66666666bbbbbbbb0000000000000000000000000000000000000000000000001ee1111111111ee11221111111111221
6666666666666666bbbbbbbbbbbbbbbb66666666bbbbbbbb0000000000000000000000000000000000000000000000001e111111111111e11211111111111121
0000000033333333600000060000000000044400000444000004440000880088008800880088008800000000000000001ee1111111111ee11221111111111221
000000003111111360111106000000000044ff000044ff000044ff00008e88e8008e88e8008e88e80000000000000000eeeeeeeeeeeeeeee2222222222222222
0000000031111113a011110600000000004ff100004ff100004ff1000008ee100008ee100008ee100000000000000000eeeeeeeeeeeeeeee2222222222222222
0000000033333336a0000006000000000404ff000404ff000404ff000008ee800008ee800008ee800000000000000000eeeeeeeeeeeeeeee2222222222222222
0000000033333336000005000000000040408808404088084040880800008e0800008e0800008e0800000000000000000e99eeeeeeee99e00299222222229920
0000000055533336000000000000000004008880040088800400888000008e8000008e8000008e800000000000000000000eeeeeeeeee0000002222222222000
000000005a5333360000000000000000000011100000111000001110000088e0000088e0000088e0000000000000000000000000000000000000000000000000
00000000555333366000000600000000000010100001001000001001000080800008008000008008000000000000000000000000000000000000000000000000
__label__
eeee4ee4ee4ee4ee4ee4ee4ee4ee4eeee4e222111121121121121121121112112112111211211112112112111211211211211211121111211211211221111116
4e4e44ee4ee4ee4ee4ee4ee4ee4ee44eeeeeee442221121121221122112211221211221121122112122112122121122112212112211221122121121112212216
eeeeee4e44ee4e4ee44ee4ee4ee4eee44e4e4eeeee4222221221221121212121122112212211122111122112112211212112212112211211212212121121111d
e4e4ee4ee44e4ee44ee4e44ee4e4ee4ee44e4ee4eeeee4221111212121212121212211211221212122111221121121122112112112112211121121122112112d
eee44ee4ee4ee4ee4ee4ee44eeee4ee4eeee44ee48eeeee82221122121212211211221121121211212211211221122111221121221121122121121211212211d
4eee44e44ee4e44ee44e4eee444e4ee4ee44ee4ee44e4eeeee2221121122112212211212211212121122112211d112211221121121221121122211211221121d
4e4eeeee44e4ee44ee4ee44eeeeee4ee4ee4ee44eeee4e4eeeee22122212211211d2121d1212122122112112122211122112212112112211211212212112121d
4eee4e4eee4e4ee44ee4eee4ee44ee9ee4ee4ee4ee44ee84e4eee82122112212211212211221112112212212111222122112212212121122211221112212111d
4ee4ee4e4e4e44ee84e44ee4e4ee4ee4ee4ee4ee44eee4eee48eeee222211221122112112112211221121221221112211221121121221121122122121121221d
4ee4e4ee4ee4ee4eeeeee44ee4ee4ee4ee4ee4ee4ee44ee44ee44eeee21221122122212221221221212211212122112212211211211122112211122121d1211d
4eee44e4e4eeee4ee49eeeee4ee4e4ee4ee4ee44ee4eee4eee4ee48eee222122112121211221122121122121211221121122122122122112112211212212112d
4e4eee4ee4ee44ee4ee44ee4ee4ee4ee4ee4eee4e44e44ee44eee4ee4ee2221122112212d11221d212212212221122122112211221221122121221211212221d
4ee4ee4eee44eee4eeeee4e4ee4e4e44ee4ee4eeeeee4ee4eee44ee4e8eee22212d21d1221221122122112d11222121d22d11d2112d1221221122112211d111d
4ee4eee94eeee4eee44eeeee4eee4eeee44ee4ee4ee4ee44e44eee44ee4eee2212211221122122112212d12221221d211221221d2112d112212112211221122d
4eee44eeee44ee4ee4ee4e4ee4e4ee44eee4ee4e4ee4eeee4ee44eee4e8e4ee22d12d122d211d222d1122121d1d12122d11d2112212d1221122122d12212211d
4eeeeeeee4ee4ee4eee4ee4ee477e7ee47774777477ee777e77ee4774ee4e7e727772121277727d717771221d777d2772777177112211221221211122112d11d
4ee4ee4ee9ee4ee9eee4eee4e740070e470007070707ee700707474004e4e7070707022d11700707070002122707072707070707d122d11d2112d2121d21122d
ee4ee4ee4ee4ee4ee4ee446dd70ee70ee77ee77707070e7047070704e4ee470707770212d27027770772212d177d07070777070702d1221212d122dd112d121d
4eeee9ee4ee4ee4ee9edddcdc70de704e700e70707070470e7070707e44e470707000d221270270707002d12270727070707070702112d21122121212212211d
4ee4ee4ee4ee4ee4eeddccddcc77d7774777470707070777470707770ee8e477070e222d2170170707772212d707077107070777022d2122d122d122d212d21d
e4eeeeeeee4ee4eeddccdcccddc00c000e000e0e040e0e000e040e000ee4ee400e0ee222d2202201020002d12202020021020d000122121122d1122112d112dd
4eee4ee4ee9ee4edcddcddccddcddcdddee4ee94eee4ee4ee4e4e44e44ee4ee4ee44ee22d2222d12d12d11222212d11dd121221221d212d221122d222122212d
4eeeee9eeeedddccdccdccddccdcc3cccde4e4ee4ee4e4eee4eee4eee4ee4ee44eeeeee222dd122d2212d22d1d2222222221d21d2212d1221d222d1d212d2d1d
eee4eeeeddcdccdcdccdccdccddccdcddd4ee4ee4ee4ee44ee4eeee4ee4ee44ee4ee4eee2222d2222d22d21d222d1d221d2212211d21222d2221d2122d21121d
eee4dddccdcddcdccddcddccdccd3cd3ccd4eeeee4ee4eee4ee94ee44e44eeee44ee4eeee2222d122d212d222d122d2d22dd12d2222d2211d2d122d1122dd21d
4ddddcddccdccdcdccdcc3cddccdccdcc1ddee44ee4ee4ee4eeee4eeeee4ee4eee4ee44eee222d22d2dd212d12d2212d221222d2212d12d2212d2122d21221dd
dcddcccddcdccdc3dccdcddcc3dccd3cddcddeeeee4ee4e4ee44ee4ee4ee4ee4ee44eeee4ed222d221222d2d22d1d2221d22d122dd22d22d22222d222d221d2d
ccddcdccdccd3cccd3cd3cc3dccddccd1ccddddddee44eeee4ee4ee44eee4ee4eee4ee4eeee2d2dd2d2dd222d222d2d2dd22222122d22d221dd12d122d1d221c
ddccddc3cd3ccddccdccdccddccdc3dccd1cd1cdddeeee4ee4ee4ee4ee4ee4ee44ee4ee4eeee2222d2d21dd2d21d22d122d12d2dd22d122d222d222dd21d2d2d
cddcccddccdcd3cd3cd1cddcc11ccddcdd1cddcdddddeee4ee4ee4eee44ee4eeee4ee4eee44ee222d2d22d22dd22d22d22dd2212d22d2212d2221d21d222d21d
ccddcc3cd3ccdcc1ccdccdc3dddc1cc1dccd1cddccddd4eeee4ee4e4eee4ee44eee4ee4eeeeeee2dd22dd22d22d2d22dd222d2d22d22ddd22dd22dd22dd2d21d
ccd3ddcc1dc1ccdcd1cc1cc1dccddc1dccd1cc1dc1dccdde4ee4eee44ee4eeee44ee4e44ee4eee222dd2ddd22dd22dd22d22d2d22d2222dd225dd2221d221ddd
cdcccdd1ccddc1dccdcddc1dd1cdc11cdddcdddc1dcddcdd4ee4ee4ee4ee4eeeee4eeeee9eee4ee2dddccdccd2d22d22dd22dd22d2dd2222d55522dd222d22dd
cdcd1cc1cc1cc1cd1ccdccdcc5ddcdcc1ddc1dcddc1dcdddddeeee9eee4eee44ee4ee4ee4eeeeee66cc6d66ccdddd22d22dd22dd22d2dd22d5552d22dd2dd21d
ccdccdccddc1dcc1dcdccddc1dc11cd1cc1dc11dcddc1dccdddd4eee4eee4eee4ee4e4eeeeeeeef6666dccd66cc6dddd22d22d22dd22d22d55555d222d222ddd
ccd1cd1c131cdddcc1dc3dcd5dcdd3ddddd1cddc11ccdddc1cddddd4ee4ee4ee4ee4ee4ee4effffe66dc66cc66ccddd2dd2d2dd22d2d22dd255552dd22dd222d
cdccdc1ccc5dc1dccdcd1ccd11cc1dcc11cddc1cddc1cc1dcc1cc1ddddeee4eee4ee4ee4eeeeffeffe66dc6dcd6cccddd22dd22dd22ddd225544552dd22dd21c
cddc1cc1d1cd3cc11ccdcc5cdd1d3c1dc6dc1dd1cddd1cc1dddddccdddd4eee4ee4ee4eee4efee66fe66cc6dcc6d6cccddd2d22dd2d22dd255555d222d22dd2d
ccd1cdd3cddc1dcddc1dcddc5d31dcddc11cd1cd1cccdd1cd1cc1d1cc1ddddee4eeeeee4ee4eeffef6e66dc66cdc6d6cddd22dd22dd222d2d45545dd2dd22ddd
ccc1ccdd13dcd1cc1ddccdddc1cdddccc1c1dc1cdd11c1dcc1ddcdd1ccdcdddd4ee44eeeeee4feffefe66ddcd6ccdcdcccddd2dd22dd22d555545552d22dd22d
cddcdc1cdcc1cc1dcc1dd3cddc1dc1c1d1cddcddcdcdcc11dcd1c1cddd1c1dcdddd4ee4e94eeee6feefee66cd6c6dcc6dccddd2dd22dd25544555455d22d22dd
cc1cdc11d1dd1dd1cddcddc1dd51cd11c11cd1cd11cdd1dc1dc1dcdd1ccddc1dc1dddd4eeeeeeeefee6ffedccddcc6dcddccdddd2dddd5555444555d5dd22ddd
ccdd1c1dcc1cc1cc11cd3c1dc5d1dccdc1dcd1cddcd1c11cdd1cd11cc1ddc1ddd1cd1dddd44eeeeeffefee6d6cddcddccddccdcddd2cddd55454555ddd2dd22c
cdccdc1d1cd1dd1cddc1dc1dd5dc51c1d1c1dc1dc11c1dc1dc1cdccdd1c1cdcd1cddcc1ddddd54eef6eeee6ddcc66ccdccddcddddd1dc15545544dcd52dd2d2d
cd1c1c11d1cd1cd1cdd1d3cc55dd1c1dc1dd1cdd11cd1cdd1cdd1cd1cd1c11cd1c1dd1cc1cc1ddd5eeeeeee6dddcdc6ddcdddcccd11dcd1d559bdcd3ddd2dccd
cc1d1c1dc1dc1cc1d1d1cdd1d551c11cd11c1ddc1d11d11cc1dc1dd1cc1ddc1ddd1cd1dd1ddcdd3dddddefeedc6cddccdccd5ddcd511d11d5495c31d1ddddccd
1c1ccd11cc11d1d1cc11c1cccd5ddd1c111dd1dd4ddd5ddd1d1cd1cc11cd1c1dc1dcdc1dc11cd1cc1ddddddddddccddccdd11dddd111d13554bd5dd13dcdc1cc
cdd1c5dd1dcdc1d1dd1d1d1d1ddc111dd1c5d444e94944444dd5d11dd1dd1ddd11c11dcddcd1cdd1cc1c1dddd1cddcddcdd1ddc1d3111555544355153cc1cccd
c1c1d11c11c1dc11cd1ccc1cdd5dc1dd1de449944949e99499444e44dd5ddddd55d5d1d111dd1cd1cdd1cc11cddd1cddddd311d53d55551555455135dcccd1cd
11cd1dc1dc11dc11cd11dcd1cd11d5d44949944944e4944944994994994445555555d555dd5dd51111c1d11d111d1515dd666ddddd115d5555d5555d15d11c1d
c5d5c111d11c11d11d1d51dd545d4449494e4444994494e94449e444944994994d4454555555455d455555d55d5555555551555d96696d555d5dd5d1cd15dc1d
ddd1d155555d1dd5d4444444e4499e49e499499849e4449449e4994444e444444944944945955945454d54d555555d55555555555544999699555d5dd3dddddd
44e494e94e4944499494e94ee9e44994944444e45211d144949444994994994944d49d45954955555566d655555dd555555555555d9b549d59999d49dd9dd465
4994e94949499494e99e994944994494449494445111111e4494944e4494444d5595d49d55555dd666666555d6d555555d5555ddd54955994d9d99ff999b99bf
f449499e49449e94494444994444948944944495d11c1c1294e494944455555555555d6666666666dd6555d665555dd55555d6d499b99444944494994699f699
49e94494494e94494449944e9944994494444954d11c11114444f944455d55555d6666d55d55d5555555d66d555d555555d6d495b44444d594db9db499ddb496
4449e494e99449494498499444e9489444e94454d13d1dd499995d5b455555d666d55555555d555d555d6d55555d5555566545544545d9b54b99559499b99db9
9d9449e444449449994444499444f49494995d55d5d4d499bd9b5445555d66665555555dd5555d555d66d555dd5555556d4459b94b9db49dd955999b54949959
d445944444494f94d99f94599d9954449455495445999b99dd455555d666d5555d55d55555d55555d6655dd55555d556d45bb459db44455b4955b5549bd5d9d5
9b54f49945495f449959599bd99d595f94d99b94b99d99db99d55dd66d555d55d55d55d555d5d55d76555555d555d566d944944b945b444955995d955999b599
559f44599459f4b59559b5955b999b99bf9b99d9b9db54555556666d55d55555555d55d55d5555d66555d55555d555665d9549554549bb49b59b49bd9db99d94
df999b46b99b9999b6949d999ddb9699b99d59b445594b54566665555555d5dd5d555555d55d5d76555555d55d555d6655544b49b59454b59d5594d9b4954944
99b9fd99469d9bf9499b99bd999d59bd45b9d54d9b5555dd66655dd5dd555555555d55d55555566555dd55d5555d5d6555554445544b94454b59b599d4944944
996499bd9b996496699699db6499bf4496599b4b4d555d666dd15155555d5d55d55d55555d55765555555555d5555d6d5555555544444b99444454b54b444494
d596b9699ddbd9b59bb9db99db99dd99bd9b5d9555d6666d55550005d55555d55d555d55555665567775d55555555566d5555555555544494495995494499449
9599df49b99999699649db9d99db95b94595555566666d55dd502002d55dd5555d55555d556655677776666655d55566d5555555555555549449944944444944
4df999b5f996b99b599b9fd99db449d55b54556666d555d555510005555555dd555d55d55d6d557ee777777777d77776dd555555555555555554444449944944
f49bd499955954959b559999b49db95b445d6666d55dd5555555000545d55555455d5555d7d55d7e77777777777777776ddd555555555555555555554454d499
b99595d955b944944449b54b5945555555666655555555dd555520055555d555d5555d556655557e77777777777e67776655ddd5555555555555555555555554
49699995599494495994d4994b595555666d55d55d55d5555d52002555d55dd555d55556625d55e777776777777eeee7666555555555555d555d555555555555
f569bd9bf49b99b446b99bb44b5555666655d55d555d55d5555002d555d555555d55d5d6d55d5dd7777ee7e76e77eeeedd66555555555555555555555d555555
94996d999bf46df9b645545b5455666655d55d55d5555555ddd20225d555d55d55555566d55555d7776eeeee7ee6eeee55566d5555d55555d5555d55555d5555
d96b996d59454b9d999d69455d6666d555d555555dd55d5deee204eed55d554d55d55d6d55d5d5d776e7ee6ee7eeeedd55dd66dd5555555555555555555555d5
996946d9b94b995543b5535666665555d55d55dd55555ddeeee22eeeed555d55555d566555d5555776eee7eeeeee7edd55555666d555d55555555555d5555555
d499db99699d595b555556666d555d55d5555d55555d5d6eeee88eeeeed55555dd55566d55555d567eeeeeeeee6eeed55d5555d666d555dd55d5555555d55d55
46bd99694b99b544555566655555d55d55d55555dd5ddeee8eeeeeeeeed55d555555d6d55d55d55d6eeeeeeeeeeee7555555d555d666d5555555555d5555d555
999669db955955b55555655555d55555555dd55555deeee828eeeee8eed555d555dd6655d55d55d526eeeeeeeeeeed5dd55555d555d6666555555d555d55d555
694b949d59b55455d5555555d55d55d5d5555d5d55eee8222eeeeee88eedd55dd55566555555555d776eddeeeeee6d5555dd55d55d55d6665d555555555555d5
4f949b5d5455d66555555d5555555d5555d5555d5dee2d5deeeeeee28eed5566d55d6d5d5dd5dd7777eeeeeee66ed5555d55555d555d55dd555d555d55d55555
4d965544b5d6555555d5555d5d55d55d55d555d54d225d55e8eeeeee2eeed677d5d66555554557777776e766e77775d55555dd5555d5555dd5555d555555d55d
54b955556d5555555555d55d555d55d55555d5555555d555eeeeeeee288e666fd566d5d5555d77777ee7eee77e7777d5d55d5555d555dd555dd55d555d555555
d4d455d555555555d5555d5555d55d55dd5555d55d5555ddeeeeeeeed28ee6765566d55d5557777776e7eeeeee77777d55d555d55d5555dd555555d555555d55
d555d555555555d555dd5555d5555555555d555d555d555deeeeeeeeed28e66d5d665555dd777777e77e67eeeee677776555d5555d55d555d55d5555d55d555d
ddd5dd5d55dd55d5568ee75d55dd55d54d55dd5555d55d5eeeeeeeeeeedd266d566d5dd55d777e77ee7eeeeeeeeee7777d55d55d555d55d555d55d555d55d555
d55d55555d55d555d68886d45d5555d555555555d555555eeeeeeeeeee6666f6566dd5555777ee777e76eeeeeeeee66777d5555d555d555d5555d55d555555d5
dd5d55dd55555555552886555555d55d55d555d5555d55dee8eeeeeee6ddd666666db5d5576eed677e7eeeeeedeeeee777655d555d555d555d5d555555d55555
dd4dd455d55d5d5d55555d5d55d55d5555d55d555d5555dee8eeeeeeed25555def44f66f67eeed7eee7eeeeeee2eeeeee77d5555555d5555d55d5dd5d555d555
d5d5d555d5545d555d5d5555555d5555d5555d555d55d55ee88eeeeeedd5555d6ff77777766ed2776eeeeeeeeeddeeeeee7555dd55d55dd555d55555d55d55d5
ddd54dd554d55555d5555dd55d5555d5555d555d55555d5ee8828ee88d55d556666e6776776dee76eee6eeeeeeeddeedeeddd5555d55d55d55d5d55d55d55555
d54d55d55d55d555d5d5555d555d5555dd55555d55d55d5dee22888eed2555d666ee6667666dd67ee6eeeeeeedeeeddee655555d555d5555d5555d555dd5d55d
d5ddd54d55555dd55555d5555d555d555555dd555d55d55d221111112d5d55d666feee7766f2d7e7eeeeeedeeeeeeedd2d55dd55555d55d55d5d5d55d55555d5
ddd45d5d55d555555d55d55d5555d45d55d5555d5555555d52212222555d5566666eeee6f66d67eeeedddeeedeeee62555d55555d555555d5555555d55d55d55
d45d5d55d55d555d55d55d5555d55555d4555d5555d55d55d52024dd55d55d66666eeeeeee6d77ee6ededdedeeeee6d5d55d55d55dd55d555d55d555555d555d
dd55d455d4555d55d55545d55d555dd555d55d55d55555555d42dd4d55555d6666eeeeee6ed57eeededdeddeeee6675555555d55555d55d5555d55d55d55d5d5
5dd4d5d55dd555d5555dd5555d555555d55d555d55d5d55d5dd4efed555dd66655dddeedddd57e6edddde2eeeeee772d55d5d55d555d55d55d5555d555d555d5
dd55d5d55d5554555d55555d555d5555d55d555555d5555d54f5dff55d5556665555dddd455d7eeddd222eee667e765555d555555d55555d555dd555d55dd555
dd4d54d5d55d5d5d555d55d5555d5dd555d55dd555555d555de4fef5555dd66dd55d55555d5d76ededeedeeee7e77d5d55555d55d555dd55d5555d55d5555d55
d5dd5d545545555d5555d555d55555555d555555d55d55555dee15d55d55d66d555d555555567edde2eede77ee677625dd55d55555d55555d5d55d555dd5555d
d4d54d5d5dd55d555d5555d55dd5555d555d55d5555d55dd45e111d555d5666d55d55d55d556eeded2eedeee7e7776d555d555dd5555d55555dd555d5555d55d
dd55dd4d555d55d5555ccc5d5555dd5555d555d55d555d5555d10155d555666555d55555d55deddedeeed77eeee776555555d5555d555dd55d55555555555555
dd4d55d5dd555555d55ccc555d555555d555d5555d555555d5510155d55d66d5d555d5d555d56ddd2dee57e7e6ee772d55d55555555d555d5555dd55d5dd5d55
d5dd45d555d55d555dd1cc5d555d55d55d55555d555d55d55551115555d666d55555555d55555e222deed6e77eee775555dd55d55555d555d5d55555d555555d
d4d5dd45d555d55d5555555d5555d555555d5555555d55555d55105d555666555d5d555d55d55dd2dd25d77777776755d555555d55d55dd5555d55d55d55d555
ddd45dd5d455d55455d55d555dd5555d55d55dd55d555d5d555555555dd666dd55555d5555dd5555d255d76ee777772555d55d55555d55555d55dd5d55d555d5
d54d55d45d5555d5d55d55d555555d55d555d5555d555d55d5d55d55d5d6665555d55d55d55555d5555557eeeee777d55d555555dd5555d55dd5555d55d55d55
d55dd45d55dd55d5555555d5d55d55555d55555d555d5555d555555d55666655d555555d5555d55d55d55ee66eeee65d555d55d55555d5d5d55d5555dd55d55d
4dd45dd555555555d5d55d455555d55d555d555d555d55d5555dd55d55666d5555d5d55d55d5555d5555d5dd5ddd55555555d555d55d5555d5455dd45555d555
dd5d55d4dd55dd5555d55d555dd555d555d55d55d5555d555d5555d55d666d5d5555d555d5555d55d55d55555555d55d55d55d55dd58ed555555d55555d555d5
d45dd455d54d555d555d555d555555d555d55d555d55d55d55555555d6666d55d55d55555d555d55555d5d55d5555d555d5555d5555885dd55d5555dd55555d5
5dd55d5555d5555d5d555555555d555dd555555d5555d55555d55d55d66665d555d5555d555d55555d5555d555dd555d555d555d55d88555d555dd55555dd555
dd45dd5dd4d5dd55555d5dd55d55dd5555dd555555d555d55d555d556666655d55d55d55d55d55d55d55d55555555d55555d5d55555dd555d55555555dd5555d
d5dd45d5555545d5d55d55555d5555555d555d55d55d55d55d5555d56666dd5555555d55555555d55555d55d5d5555d55d55555d555555d555d5d55d55555d55
d4dd55d45d55d5555455d55d555d55dd55555d555d555d55555dd55d6666d555d55d555d5dd5d555d5d5555d55d555d55d555d55d55d55555dd55d55555d5555
dd54dd55d55d555d55d555d555d55d5555d5555d5555d55d55555d566666d555d55555555555555d5555d5555555d555555d5555d5555d5555555d55d55d55d5
4dd55d45d54d5d55d55d55d554d55555d55d55d55d5555555d55d556666655d555d55d55d5555d555d55d555d5567d55d55555d555d55d55d55d55d55d5555d5
d5dd55dd55d555d55d55dd55d555d555d558e57775777d777d5775d7766dd55777775d5555d5755555577777557677d555d555d55d55555d555d555d555d5555
dd54d5d55d55d5455555545d555d55d555d8857070707070007d0076006d55770707755d55d750d55d77000777767555555dd555555d55555d55d55d55d55d5d
54d5d55d4d554d5d5dd55d555d555d5555d88d777077507755777577766d5d777d77705d555705555577075770dd655d5d5555d55d555d55d5555d555555dd55
d5dd4d555d5d555d555555d55d55d55d55555570007075700d50706070655577075770555d57055d5577050770d5dd55555d555d555d555555d55555dd5555d5
dd555d55d55d5555d55dd455d55d45d55d5d5570d57070777d77d0776065d5577777005555750d555dd77777005555d55555dd55555d55d5555dd5d55dd555d5
5d4d55dd45d45dd545545d5554555d55d55555505550d05000d0066006d555d50000055dd5505555d5550000055d5555d5d55555dd5555d55d55555d55d5dd55
d5dd55d5d555d545d5d55d5d5dd55555d555dd555dd55555d555d66666d55dd55555d55555dd5555555dd5555d555d55555d55d55555d5555d555d5d5554555d
d5d5d545d5dd45d555dd555d5555d5d555d5555d55555dd5455d6666665d5555dd5555d555555dd55d555555d555555d5d5555d55dd5555d55d55d455d5d55d5
d455d5d54d555d5d55555d455d55d555d5555555d55d55555d5566666655555d555d5555d555555d55d5555555d55d555d55d555555d555d555d555dd555dd55
ddd4555dd55dd55d5d4dd55d55d4555d555dd5555555d555d55d66666d55dd555555d555d55d555d5555d55d55d55d5555d5555dd555d555dd55d5d555d5555d
45dd5d55d4d54dd555d555dd54d555d55d5555dd5d5555d5d55666666dd555555dd555d55d55dd555d55555d5555555d55d55d5555d54d5555d55555d55d5555
dd555d55d5d55d55d4d555d45555d55555455d555d5d545555d66666655555d555555d555555555555dd55d555555555555555555d55555d555d455d555d55d5
dd4dd4ddd54d555dd55d5555dd55d55d55dd555554555d55d5d66666dd5dd555d55d555dd55d55d5d55555555dd55dd5d55d55d5555d55d555555d5566615555

__map__
2424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2424242424242424242424242424242400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000007000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000007000000000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100200d0500f0500d0500f05001700067000070006700107000e7000d7000f700167001c700207002b7002e700307003770000700017000b70001700007000170000700007000070000700007000170001700
0601000032700307002f7102c7202a73029740267502475021750217501f7501c7501d7401b7201772014720107200f7200973007760047500174000740017500075007750017500075000750007000070000700
04010000000000272404734077440b7440d7440f75410754117501375414754157441574015740167401c7401c740227302e730327501b7001c7001d700007001a700227002470026700297002d7002e70000000
030100000040000400024500245003450034500345004450034500345000400004000040000400004000040001400014000140002400024000240002400014500145001450014500145001450014500145000400
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1910000018010000001c010000001c0101c00018010000001c0101c0151c00000000000000000000000000001a010000001d010000001d010000001a010000001d0101d015000000000000000000000000000000
__music__
03 08424344

