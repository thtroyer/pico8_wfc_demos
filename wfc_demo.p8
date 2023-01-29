pico-8 cartridge // http://www.pico-8.com
version 39
__lua__
--wave function collapse demo 2
--experimenting with simplified version

-- utility methods
#include src/utility.lua

#include src/global_game_logic.lua

#include src/pico8_hooks.lua

-->8
--#include src/entities/player.lua

-->8
--#include src/entities/spart.lua
--#include src/entities/snowball.lua

-->8
--#include src/entities/snowman.lua

-->8
#include src/map/mapdata.lua

-->8
#include src/map/mapgen.lua

-->8
#include src/map/maptile.lua

-->8
-- mapgen rules
#include src/map/rules/neighbor_rules.lua
#include src/map/rules/count_rules.lua

-->8
-- sprite lookup
#include src/map/sprite_lookup.lua


__gfx__
00000000000ccc000008880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000c4ffc0008aff8000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000c4f1c0008af18000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700000c4ffc0008aff8000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00076000000c4c000008a80000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000009cc90000e88e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000055500000ddd0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000050500000d0d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000111000000000000000000000000000008080000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000001000000000000000000000000000008e878000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000008e80000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000330000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000003333000003300000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000007777000077330000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000071771700717733000003000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000077977700779777000073300000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000077977700779717000077330000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000007777000077770000797730000033000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000477777444777774400797170073333300000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000047774700477747007777770077777700000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000074777700747777004777470047774700000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000007777000077770007477770074777700000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000077777700777777000777700007777700000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000777777777777777707777770077777770777770000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000777777777777777777777777777777777777777700000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000777777777777777777777777777777777747777700000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000077777700777777077777777779977777499717700000000
666666665555555566666666000000000000000000000000dddddddddddddddd0000000000000000555555552222222255555555555555555500005588888888
6666666655555555666ccc66000000000000000000000000dddddddddddddddd0000000000000000555555552222222255555555555555555500005588888888
66666666555555556cccccc6000000000000000000000000dddddddddddddddd0000000000000000555555552222222255555555555500005500005588888888
66666666555555556cccccc6000000000000000000000000dddddddddddddddd0000000000000000555555552222222255555555555500005500005588888888
666666665555555566ccccc6000000000000000000000000dddddddddd1ddddd0000000000000000555555552222222255000055555500005500005588888888
666666665555555566ccccc6000000000000000000000000dddddddddddddddd0000000000000000555555552222222255000055555500005500005588888888
6666666655555555666ccc66000000000000000000000000dddddddddddddd1d0000000000000000555555552222222255000055555555555500005588888888
666666665555555566666666000000000000000000000000dddddddddddddddd0000000000000000555555552222222255000055555555555500005588888888
66665555555566666666666666666666555555555555555566666666666666665555666666665555550000555555555555555555555555555555555555000055
66665555555566666666666666666666555555555555555566666666666666665555666666665555550000555555555555555555555555555555555555000055
66655555555666666666666666666666555555555555555566666666666666665555666666665555550000550000555500000000000000555500000055000000
66655555555666666666666666666666555555555555555566666666666667665555666666665555550000550000555500000000000000555500000055000000
66655555555666666666665555666666555555666655555566666666666666665555666666665555555555550000555500000000000000555500000055000000
66665555555666666666655555566666555556666665555566666666667666665555666666665555555555550000555500000000000000555500000055000000
66665555555566666666555555556666555566666666555566666666666666665555666666665555555555555555555555555555550000555500005555555555
66665555555566666666555555556666555566666666555566666666666666665555666666665555555555555555555555555555550000555500005555555555
55555555666666666666555555556666555566666666555555555555555555556666666655555555550000550000000000000000000000000000000000000000
55555555666666666666555555556666555566666666555555555555555555556666666655555555550000550000000000000000000000000000000000000000
55555555666666666666655555566666555556666665555555555555555555556666666655555555000000550000000000000000000000000000000000000000
5556665566666666666666555566666655555566665555555555555555d555556666666655555555000000550000000000000000000000000000000000000000
66666666556665556666666666666666555555555555555555555555555555555555555566666666000000550000000000000000000000000000000000000000
6666666655555555666666666666666655555555555555555555555555555d555555555566666666000000550000000000000000000000000000000000000000
66666666555555556666666666666666555555555555555555555555555555555555555566666666555555550000000000000000000000000000000000000000
66666666555555556666666666666666555555555555555555555555555555555555555566666666555555550000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00066000000660000006600000000000000880000008800000088000000000000000000000000000000000000000000000000000000000000000000000000000
00606000006006000060060000000000008080000080080000800800000000000000000000000000000000000000000000000000000000000000000000000000
00006000000006000000060000050000000080000000080000000800000000000000000000000000000000000000000000000000000000000000000000000000
00006000000060000000660000000000000080000000800000008800000000000000000000000000000000000000000000000000000000000000000000000000
00006000000600000060060000000000000080000008000000800800000000000000000000000000000000000000000000000000000000000000000000000000
00666600006666000006600000000000008888000088880000088000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00ccc00000cccc00000ccc0000cccc000ccccb0000cccb0000000000000000000000000000000000000000000000000000000000000000000000000000000000
00fccc000cccccc000cc4f000011cc000ccccc0000cc110000000000000000000000000000000000000000000000000000000000000000000000000000000000
00fccc000cccccc000cc4f0000f1cc000ccccc0000cc1f0000000000000000000000000000000000000000000000000000000000000000000000000000000000
00f4c1000cc11cc0001c4f0000f1c10001ccc100001c1f0000000000000000000000000000000000000000000000000000000000000000000000000000000000
004ccc0000cccc4000cccc0000cccc000ccccc0000cccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000
00ccce0000ccce0000eccc0000cccf000fcccf0000fccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000
00055500005555000055500000066600006660000066600000000000000000000000000000000000000000000000000000000000000000000000000000000000
00505500005005000055050000606600006060000066060000000000000000000000000000000000000000000000000000000000000000000000000000000000
00ccc00000000000000ccc0000ccc0000bcccc00000bcc0000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cffcc000000000000c4ffc000f11c00c11111c000c11f0000000000000000000000000000000000000000000000000000000000000000000000000000000000
0c1fcc000000000000c4f1c0004f1c001f4f4f1000c1f40000000000000000000000000000000000000000000000000000000000000000000000000000000000
0cff4c000000000000c4ffc000ff1c001fffff1000c1ff0000000000000000000000000000000000000000000000000000000000000000000000000000000000
00c4c00000000000000c4c0000cccc00c1fff1c000cccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ecce00000000000000ecce00fcfcc00cc111cc000ccfcf000000000000000000000000000000000000000000000000000000000000000000000000000000000
005550000000000000055500006666000ccccc000066660000000000000000000000000000000000000000000000000000000000000000000000000000000000
00505000000000000005050000600600000000000060060000000000000000000000000000000000000000000000000000000000000000000000000000000000
00cccc0000cccc0000cccc0000ccc0000bccc00000cbcc0000000000000000000000000000000000000000000000000000000000000000000000000000000000
04fffcc00cffffc00c4fffc000fffc000cfffc0000cfff0000000000000000000000000000000000000000000000000000000000000000000000000000000000
041f1cc0041f1fc00c41f1c0004f4100014f41000014f40000000000000000000000000000000000000000000000000000000000000000000000000000000000
04fff4c004ffff400c4fff4000fff10001fff100001fff0000000000000000000000000000000000000000000000000000000000000000000000000000000000
00ccc40004ccc400004ccc0000cccc000ccccc0000cccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000
0eecce000eccce0000eccee00ffccf000fcccf0000fccff000000000000000000000000000000000000000000000000000000000000000000000000000000000
00055500005555000055500000066600006660000066600000000000000000000000000000000000000000000000000000000000000000000000000000000000
00505500005005000055050000606600006060000066060000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
88888eeeeee888eeeeee888eeeeee888eeeeee888777777888eeeeee888eeeeee888888888888888888ff8ff8888228822888222822888888822888888228888
8888ee888ee88ee88eee88ee888ee88ee888ee88778787788ee888ee88ee8eeee88888888888888888ff888ff888222222888222822888882282888888222888
888eee8e8ee8eeee8eee8eeeee8ee8eeeee8ee8777878778eee8eeee8eee8eeee88888e88888888888ff888ff888282282888222888888228882888888288888
888eee8e8ee8eeee8eee8eee888ee8eeee88ee8777888778eee888ee8eee888ee8888eee8888888888ff888ff888222222888888222888228882888822288888
888eee8e8ee8eeee8eee8eee8eeee8eeeee8ee8777778778eeeee8ee8eee8e8ee88888e88888888888ff888ff888822228888228222888882282888222288888
888eee888ee8eee888ee8eee888ee8eee888ee8777778778eee888ee8eee888ee888888888888888888ff8ff8888828828888228222888888822888222888888
888eeeeeeee8eeeeeeee8eeeeeeee8eeeeeeee8777777778eeeeeeee8eeeeeeee888888888888888888888888888888888888888888888888888888888888888
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
1eee1e1e1ee111ee1eee1eee11ee1ee1111116661666166616611666166616661111166616611666166616661666161116661666166611711171111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111116661616161616161616116116161171116116161161116111611616161111611116161117111117111111111111
1ee11e1e1e1e1e1111e111e11e1e1e1e111116161666166616161666116116661111116116161161116111611666161111611161166117111117111111111111
1e111e1e1e1e1e1111e111e11e1e1e1e111116161616161116161616116116161171116116161161116111611616161111611611161117111117111111111111
1e1111ee1e1e11ee11e11eee1ee11e1e111116161616161116661616116116161111166616161666116116661616166616661666166611711171111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e1111ee11ee1eee1e1111111666166616661111166616661611166611661111111111111177177111111111111111111111111111111111111111111111
11111e111e1e1e111e1e1e1111111666161616161111116111611611161116111111177711111171117111111111111111111111111111111111111111111111
11111e111e1e1e111eee1e1111111616166616661111116111611611166116661111111111111771117711111111111111111111111111111111111111111111
11111e111e1e1e111e1e1e1111111616161616111111116111611611161111161111177711111171117111111111111111111111111111111111111111111111
11111eee1ee111ee1e1e1eee11111616161616111666116116661666166616611111111111111177177111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111116111166116611711c1c11cc1ccc1cc11ccc1ccc1ccc1ccc1ccc1cc111cc11111ccc1ccc1ccc11111ccc1ccc1c111ccc11cc1c1c11711111111111111111
111116111616161117111c1c1c111c111c1c1c111c1c1c1c11c111c11c1c1c1111111ccc1c1c1c1c111111c111c11c111c111c111c1c11171111111111111111
1111161116161611171111111c111cc11c1c1cc11cc11ccc11c111c11c1c1c1111111c1c1ccc1ccc111111c111c11c111cc11ccc111111171111111111111111
1111161116161616171111111c1c1c111c1c1c111c1c1c1c11c111c11c1c1c1c11111c1c1c1c1c11111111c111c11c111c11111c111111171111111111111111
1111166616611666117111111ccc1ccc1c1c1ccc1c1c1c1c11c11ccc1c1c1ccc11111c1c1c1c1c11111111c11ccc1ccc1ccc1cc1111111711111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee11ee1eee1111161611111ccc11111cc11ccc11111ee111ee111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e1e1111161617771c1c111111c11c1111111e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111
11111ee11e1e1ee11111166611111c1c111111c11ccc11111e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e1e1111111617771c1c117111c1111c11111e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111
11111e111ee11e1e1111166611111ccc17111ccc1ccc11111eee1ee1111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee11ee1eee1111161611111ccc11111cc11ccc11111ee111ee11111111111111111111111111111111111111111111111111111111111111111111
111111111e111e1e1e1e1111161617771c1c111111c11c1111111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111
111111111ee11e1e1ee11111116111111c1c111111c11ccc11111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111
111111111e111e1e1e1e1111161617771c1c117111c1111c11111e1e1e1e11111111111111111111111111111111111111111111111111111111111111111111
111111111e111ee11e1e1111161611111ccc17111ccc1ccc11111eee1ee111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111116111166116611711616111111111c1c11111c1c1111111116161171111111111111111111111111111111111111111111111111111111111111
11111111111116111616161117111616111111111c1c11111c1c1111111116161117111111111111111111111111111111111111111111111111111111111111
11111111111116111616161117111161111111111111111111111111111116661117111111111111111111111111111111111111111111111111111111111111
1111111111111611161616161711161611111111111111c111111111111111161117111111111111111111111111111111111111111111111111111111111111
111111111111166616611666117116161171117111111c1111111171117116661171111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111161111661166117116161111161617171cc11c111171111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111611161616111711161611711616117111c11c111117111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111611161616111711116117771666177711c11ccc1117111111111111111111111111111111111111111111111111111111111111111111111111
1111111111111611161616161711161611711116117111c11c1c1117111111111111111111111111111111111111111111111111111111111111111111111111
111111111111166616611666117116161111166617171ccc1ccc1171111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111116111116116611711c1c1ccc1cc11cc11ccc1cc111cc11111c1c111111111111111116161111161617171cc11c11117111111111111111111111
11111111111116111171161117111c1c1c1c1c1c1c1c11c11c1c1c1111111c1c1111111111111111161611711616117111c11c11111711111111111111111111
111111111111161111771611171111111ccc1c1c1c1c11c11c1c1c11111111111111111111111111116117771666177711c11ccc111711111111111111111111
111111111111161111777116171111111c1c1c1c1c1c11c11c1c1c1c111111111111111111111111161611711116117111c11c1c111711111111111111111111
111111111111166611777716117111111c1c1ccc1ccc1ccc1c1c1ccc11111111111111711171111116161111166617171ccc1ccc117111111111111111111111
11111111111111111177111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111166616117166111116661666161116661166177116161111161617171cc11c111177111111111111166616661666166616661611166611111661
1111111111111666161616161111116111611611161116111711161611711616117111c11c111117111117771111166616161616116111611611161111711616
1111111111111616166616661111116111611611166116661711116117771666177711c11ccc1117111111111111161616661666116111611611166111111616
1111111111111616161616111111116111611611161111161711161611711116117111c11c1c1117111117771111161616161611116111611611161111711616
111111111111161616161611166611611666166616661661177116161111166617171ccc1ccc1177111111111111161616161611116116661666166611111616
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111166616661666111116661666161116661166177116161111161617171cc11c111177111116161111111111111616111111111111111111111111
1111111111111666161616161111116111611611161116111711161611711616117111c11c111117111116161111177711111616111111111111111111111111
1111111111111616166616661111116111611611166116661711116117771666177711c11ccc1117111111611111111111111161111111111111111111111111
1111111111111616161616111111116111611611161111161711161611711116117111c11c1c1117111116161111177711111616111111111111111111111111
111111111111161616161611166611611666166616661661177116161111166617171ccc1ccc1177117116161111111111111616111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111166616661666111116661666161116661166177116161111161617171cc11c111177111116161111111111111616111111111111111111111111
1111111111111666161616161111116111611611161116111711161611711616117111c11c111117111116161111177711111616111111111111111111111111
1111111111111616166616661111116111611611166116661711116117771666177711c11ccc1117111116661111111111111666111111111111111111111111
1111111111111616161616111111116111611611161111161711161611711116117111c11c1c1117111111161111177711111116111111111111111111111111
111111111111161616161611166611611666166616661661177116161111166617171ccc1ccc1177117116661111111111111666111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111166616661666111116661666161116661166177116161111161617171cc11c111177111116661661166111711c111ccc11711111111111111111
1111111111111666161616161111116111611611161116111711161611711616117111c11c111117117116161616161617111c111c1111171111111111111111
1111111111111616166616661111116111611611166116661711116117771666177711c11ccc1117111116661616161617111ccc1ccc11171111111111111111
1111111111111616161616111111116111611611161111161711161611711116117111c11c1c1117117116161616161617111c1c111c11171111111111111111
111111111111161616161611166611611666166616661661177116161111166617171ccc1ccc1177111116161666166611711ccc1ccc11711111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111166616661666111116661666161116661166177116161111161617171cc11c111177111116661661166111711c111c1c11711111111111111111
1111111111111666161616161111116111611611161116111711161611711616117111c11c111117117116161616161617111c111c1c11171111111111111111
1111111111111616166616661111116111611611166116661711116117771666177711c11ccc1117111116661616161617111ccc1ccc11171111111111111111
1111111111111616161616111111116111611611161111161711161611711116117111c11c1c1117117116161616161617111c1c111c11171111111111111111
111111111111161616161611166611611666166616661661177116161111166617171ccc1ccc1177111116161666166611711ccc111c11711111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111111166616661666111116661666161116661166177116161111161617171cc11c111177111116661661166111711ccc1ccc11711111111111111111
1111111111111666161616161111116111611611161116111711161611711616117111c11c11111711711616161616161711111c1c1c11171111111111111111
1111111111111616166616661111116111611611166116661711116117771666177711c11ccc111711111666161616161711111c1c1c11171111111111111111
1111111111111616161616111111116111611611161111161711161611711116117111c11c1c111711711616161616161711111c1c1c11171111111111111111
111111111111161616161611166611611666166616661661177116161111166617171ccc1ccc117711111616166616661171111c1ccc11711111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1ee11ee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111e111e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111ee11e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111e111e1e1e1e111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
111111111eee1e1e1eee111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111161111661166117116661166116616661666166616611166117116661666166611111666166616111666116611711171111111111111111111111111
11111111161116161611171111611616161111611616116116161611171116661616161611111161116116111611161111171117111111111111111111111111
11111111161116161611171111611616166611611661116116161611171116161666166611111161116116111661166611171117111111111111111111111111
11111111161116161616171111611616111611611616116116161616171116161616161111111161116116111611111611171117111111111111111111111111
11111111166616611666117111611661166111611616166616161666117116161616161116661161166616661666166111711171111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1ee11ee11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111ee11e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111e111e1e1e1e1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111eee1e1e1eee1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
82888222822882228888822282228882822882228222888888888888888888888888888888888888888882228222822282228882822282288222822288866688
82888828828282888888888282828828882888828282888888888888888888888888888888888888888888828882888282828828828288288282888288888888
82888828828282288888822282828828882888828222888888888888888888888888888888888888888888228222882282228828822288288222822288822288
82888828828282888888828882828828882888828882888888888888888888888888888888888888888888828288888282828828828288288882828888888888
82228222828282228888822282228288822288828882888888888888888888888888888888888888888882228222822282228288822282228882822288822288
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888

__map__
4343434343434343434343434343434300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4343434343434343434343434343434300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4343434343434343434343434343434300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4343434343434343434343434343434300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4343434343434343434343434343434300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4343434343434343434343434343434300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4343434343434343434343434343434300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4343434343434343434343434343434300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4343434343434343434343434343434300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

