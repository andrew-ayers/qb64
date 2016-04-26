' 3d world map data

TYPE pt

    x AS SINGLE
    y AS SINGLE

END TYPE

TYPE wall

    p1 AS INTEGER
    p2 AS INTEGER
    s1 AS INTEGER
    s2 AS INTEGER
    wcolor AS INTEGER
    flag AS INTEGER

END TYPE

TYPE sector

    numwalls AS INTEGER
    f AS SINGLE
    c AS SINGLE
    fcolor AS INTEGER
    ccolor AS INTEGER
    midx AS SINGLE
    midy AS SINGLE

END TYPE

DIM SHARED maxpts AS INTEGER
DIM SHARED maxwalls AS INTEGER
DIM SHARED maxsectors AS INTEGER
DIM SHARED maxswalls AS INTEGER
DIM SHARED pi AS SINGLE
DIM SHARED radpi AS SINGLE
DIM SHARED fov AS INTEGER
DIM SHARED midx AS INTEGER
DIM SHARED midy AS INTEGER
DIM SHARED vh AS INTEGER

' 3d world info
maxpts = 5
maxwalls = 5
maxsectors = 5
maxswalls = 5

pi = 3.14159
radpi = pi

DIM SHARED pts(maxpts) AS pt
DIM SHARED walls(maxwalls) AS wall
DIM SHARED sectors(maxsectors) AS sector
DIM SHARED swalls(maxsectors, maxswalls) AS INTEGER

DIM SHARED numsectors AS INTEGER

pts(0).x = -150
pts(0).y = 150

pts(1).x = 0
pts(1).y = 200

pts(2).x = 150
pts(2).y = 100

pts(3).x = 130
pts(3).y = -100

pts(4).x = -130
pts(4).y = -120

walls(0).p1 = 0
walls(0).p2 = 1
walls(1).p1 = 1
walls(1).p2 = 2
walls(2).p1 = 2
walls(2).p2 = 3
walls(3).p1 = 3
walls(3).p2 = 4
walls(4).p1 = 4
walls(4).p2 = 0

walls(0).wcolor = 1
walls(1).wcolor = 2
walls(2).wcolor = 3
walls(3).wcolor = 2
walls(4).wcolor = 1

sectors(0).numwalls = 5
sectors(0).c = -50
sectors(0).f = 70

swalls(0, 0) = 0
swalls(0, 1) = 1
swalls(0, 2) = 2
swalls(0, 3) = 3
swalls(0, 4) = 4

SCREEN 13

fov = 100
midx = 160
midy = 100
vh = 25

hit = -1

FOR i = 0 TO sectors(s).numwalls - 1

    wi = swalls(s, i)

    IF NOT wi = -1 THEN

        DIM tx1 AS SINGLE
        DIM ty1 AS SINGLE
        DIM tx2 AS SINGLE
        DIM ty2 AS SINGLE

        DIM pt AS SINGLE

        p1 = walls(wi).p1
        p2 = walls(wi).p2

        tx1 = pts(p1).x
        ty1 = pts(p1).y

        tx2 = pts(p2).x
        ty2 = pts(p2).y

        a1 = angleize(ty1, tx1)
        a2 = angleize(ty2, tx2)

        IF greater(a1, a2) = 1 THEN

            tp = a1
            a1 = a2
            a2 = tp

        END IF

        IF between(a1, left, a2) = 1 THEN hit = i

    END IF

NEXT i

lnext = left

WHILE hit <> -1

    '
    ' get wall index from list of walls in sector
    '
    '

    w = swalls(s, hit)

    '
    ' if end of wall list is reached, go to beginning again to continue
    ' in clockwise order around the sector
    '
    '

    IF w = -1 THEN

        hit = 0
        w = swalls(s, 0)

    END IF

    IF w = 0 AND s = 0 THEN

    END IF

    ' color data for wall
    '

    wcolor = walls(w).wcolor

    '
    ' increment counter
    '

    hit = hit + 1

    '
    ' get boundary points on wall
    '
    '

    p1 = walls(w).p1
    p2 = walls(w).p2

    tx1 = pts(p1).x
    ty1 = pts(p1).y

    tx2 = pts(p2).x
    ty2 = pts(p2).y

    a1 = angleize(ty1, tx1)
    a2 = angleize(ty2, tx2)

    ' make sure that a2! is clockwise to a1!

    IF greater(a1, a2) = 1 THEN

        pt = tx1
        tx1 = tx2
        tx2 = pt

        pt = ty1
        ty1 = ty2
        ty2 = pt

        at = a1
        a1 = a2
        a2 = at

    END IF

    ' move left-hand boundary marker to next position

    lmark = lnext

    ' get viewing distances to start and end of walls

    dstart! = getdist!(tx1, ty1, tx2, ty2, lmark)

    ' make sure that if wall is clipped by right boundary, to make dend! correct
    '

    IF greater(right, a2) = 1 THEN

        ' right boundary is beyond wall, use clockwise farthest point of wall

        dend! = getdist!(tx1, ty1, tx2, ty2, a2)

        r = getx(a2)
        lnext = a2

    ELSE

        ' use right boundary to find distance instead

        dend! = getdist!(tx1, ty1, tx2, ty2, right)

        r = getx(right)
        lnext = right

        ' set drawing on this sector to end because boundary has been reached

        hit = -1

    END IF

    l = getx(lmark)

    dx! = r - l

    IF dx! < 1 THEN dx! = 1

    ltop = gety(sectors(s).c, dstart!)
    lbot = gety(sectors(s).f, dstart!)

    rtop = gety(sectors(s).c, dend!)
    rbot = gety(sectors(s).f, dend!)

    dytop! = (rtop - ltop) / dx!
    dybot! = (rbot - lbot) / dx!

    '
    ' draw the wall section already!!!
    ' for now, use very simple lines.
    '

    LINE (l, ltop)-(l, lbot), wcolor
    LINE (r - 1, rtop)-(r - 1, rbot), wcolor
    LINE (l, ltop)-(r - 1, rtop), wcolor
    LINE (l, lbot)-(r - 1, rbot), wcolor

WEND



FUNCTION getx (a!)

'
' from an angle value, find the x screen position it corresponds to
'

getx = fov * TAN(a!) + midx

END FUNCTION

FUNCTION gety (height!, dist!)

'
' find the y position on the screen for a point at a certain height
'

d! = dist!
IF d! < 1 THEN d! = 1

gety = fov * (height! - vh) / d! + midy

END FUNCTION

FUNCTION getdist! (p1x!, p1y!, p2x!, p2y!, vb)

' find distance to a spot on a wall from p1 to p2 '
' that is hit by a ray vb

dx! = p1x! - p2x!
dy! = p1y! - p2y!

IF ABS(dx!) > .05 THEN

    m! = dy! / dx!
    b! = p1y! - m! * p1x!
    gdist! = b! / (1 - m! * TAN(vb))
    oldx = gdist! * TAN(vb)
    getdist! = gdist!

ELSE

    m! = dx! / dy!
    b! = p1x! - m! * p1y!
    gdist! = b! / (TAN(vb) - m!)
    oldx = gdist! * TAN(vb)
    getdist! = gdist!

END IF
END FUNCTION

FUNCTION angleize% (x AS SINGLE, y AS SINGLE)

'
' take x, y and find an angle between 0 and 2pi rads
'
'

IF ABS(x) < 1 AND ABS(y) < 1 THEN angleize = 0: EXIT FUNCTION

IF x >= 0 AND y >= 0 THEN

    IF x > 1 THEN

        angleize = ATN(y / x)

    ELSE

        IF y < .01 THEN angleize = (radpi * .5 - 1.57): EXIT FUNCTION

        angleize = ((radpi * .5) - ATN(x / y))

    END IF

END IF

IF x < 0 AND y >= 0 THEN

    IF x > -1 THEN

        angleize = (radpi - ATN(y / -x))

    ELSE

        IF y < .01 THEN angleize = (radpi * .5 + 1.57): EXIT FUNCTION

        angleize = ((radpi * .5) + ATN(x / -y))

    END IF

END IF

IF x < 0 AND y < 0 THEN

    IF x > -1 THEN

        angleize = (radpi + ATN(y / x))

    ELSE

        IF y > -.01 THEN angleize = (radpi * 1.5 - 1.57): EXIT FUNCTION

        angleize = ((radpi * 1.5) - ATN(x / y))

    END IF

END IF

IF x >= 0 AND y < 0 THEN

    IF x > 1 THEN

        angleize = ((2 * radpi) - ATN(y / -x))

    ELSE

        IF y > -.01 THEN angleize = (radpi * 1.5 - 1.57): EXIT FUNCTION

        angleize = ((radpi * 1.5) + ATN(-x / y))

    END IF

END IF

END FUNCTION

FUNCTION greater (a2, a1)
'
' compare two angles (in rads) and see which is farther clockwise
' comparison is based on the shortest angle between them
' angles are fixed to be between 0 to 2pi rads
'
'

an1 = fixtheta(a1)
an2 = fixtheta(a2)

IF ABS(an2 - an1) > pi THEN

    an1 = an1 + pi
    an2 = an2 + pi

    an1 = fixtheta(an1)
    an2 = fixtheta(an2)

END IF

IF an2 > an1 THEN greater = 1 ELSE greater = 0
IF an2 = an1 THEN greater = 2

END FUNCTION

FUNCTION fixtheta (an)

'
' make an angle be between 0 and 2pi rads
'
'
'

a = an

WHILE a > 2 * pi
    a = a - 2 * pi
WEND

WHILE a < 0
    a = a + 2 * pi
WEND

fixtheta = a

END FUNCTION

FUNCTION between (a1, a2, a3)

'
' see whether a1! < a2! < a3! in a clockwise way
' comparison is done through the shorter angle between a1! and a3!
' where all are fixed to be within 0 to 2pi rads
'
'

an1 = fixtheta(a1)
an2 = fixtheta(a2)
an3 = fixtheta(a3)

IF ABS(an3 - an1) > pi THEN

    an1 = an1 + pi
    an3 = an3 + pi
    an2 = an2 + pi

    an1 = fixtheta(an1)
    an2 = fixtheta(an2)
    an3 = fixtheta(an3)

END IF

IF an1 <= an2 AND an2 <= an3 THEN between = 1 ELSE between = 0

END FUNCTION

