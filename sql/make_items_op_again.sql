# make melee weapons op
# bronze axe - 16640
# onion dagger - 16482
# onion staff - 17104
# onion rod - 17068
# onion sword - 16534
# onion knife - 16483
# deathbringer - 16637
# butterfly axe - 16704
# bronze zaghnal - 16768
# harpoon - 16832
# kunai - 16896
# tachi - 16966
# shortbow - 17152
# light crossbow - 17216 
update item_weapon set dmg = 321, delay = 30 where itemid in (16640, 16482, 17104, 17068, 16534, 16483, 16637, 16704, 16768, 16832, 16896, 16966, 17152, 17216);

# special for monk weapons
# cesti - 16385
# cat baghnakhs - 16405
update item_weapon set dmg = 600, delay = 300 where itemid in (16405, 16385);

# make some weapons two-hit weapons because they are hard to hit with and the users are weak
# onion staff - 17104
# deathbringer - 16637
# butterfly axe - 16704
# bronze zaghnal - 16768
# harpoon - 16832
# tachi - 16966
update item_weapon set hit = 2 where itemid in (17104, 16637, 16704, 16768, 16832, 16966);
