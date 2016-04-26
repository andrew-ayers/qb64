DEFDBL A-Z

SCREEN 12

agn:
  x = 319
  y = 0
  ox = x
  oy = y

here:
  preset(ox, oy)

  ox = x
  oy = y

  x = x + (rnd - .5#) * (rnd * 5)
  y = y + .2

  if x < 0 then x = 639
  if x > 639 then x = 0

  if point(x, y + 1) > 0 then goto agn

  if y > 479 goto agn

  pset(x, y), rnd * 15

goto here
