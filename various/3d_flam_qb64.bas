'*****************************************************************************
'*                                                                           *
'*  Vector Cube Rehash - Originally done by Phobia in 1996...                *
'*  Rehashed for speed and clarity by Andrew L. Ayers in 1997...             *
'*  Rehashed again for QB64 by Andrew L. Ayers in 2011 (I feel old)...       *
'*                                                                           *
'*****************************************************************************
'
DECLARE SUB pal (c%, r%, g%, B%)
DECLARE SUB flam ()
'
SCREEN 13
'
xoff% = 160 ' Center of the cube in x
yoff% = 100 ' Same but in y
zoff% = 200 ' Same but in z
'
xang = .15 ' Don't change these... they control the rotation.
yang = .1
zang = .05
'
points% = 8 ' Amount of vertexes in the cube...
points3% = points% * 3 ' This is to eliminate the multiply
'
DIM cube(points% * 3) ' All coordinates of the cube
DIM scr(points% * 2) ' Coordinates of where the vertexes should be
                      ' on the screen
'
FOR a% = 1 TO points3%
   READ value%
   cube(a%) = value% * 2
NEXT
'
FOR a% = 0 TO 63 ' Change the palette, colors 0-48
   pal a% / 4, a%, 0, 0
   pal a% / 4 + 16, 63, a%, 0
   pal a% / 4 + 32, 63, 63, a%
NEXT

inc% = 1

DO
  '
  xp = cube(inc%)
  yp = cube(inc% + 1)
  zp = cube(inc% + 2)
  '
  ' ********** Rotate around z-axis **********
  '
  rxp = COS(zang) * xp - SIN(zang) * yp
  ryp = SIN(zang) * xp + COS(zang) * yp
  '
  xp = rxp
  yp = ryp
  '
  ' ********** Rotate around y-axis **********
  '
  rxp = COS(yang) * xp - SIN(yang) * zp
  rzp = SIN(yang) * xp + COS(yang) * zp
  '
  xp = rxp
  zp = rzp
  '
  ' ********** Rotate around x-axis **********
  '
  ryp = COS(xang) * yp - SIN(xang) * zp
  rzp = SIN(xang) * yp + COS(xang) * zp
  '
  cube(inc%) = rxp
  cube(inc% + 1) = ryp
  cube(inc% + 2) = rzp
  '
  ' ***********************************
  '
  inc% = inc% + 3
  '
  IF inc% > points3% THEN
    '
    inc% = 1: inc2% = 1
    '
    flam ' Make the flameeffect
    '
    DO
      '
      scr(inc2%) = (cube(inc%) * 256) / (cube(inc% + 2) - zoff%) + xoff%
      scr(inc2% + 1) = (cube(inc% + 1) * 256) / (cube(inc% + 2) - zoff%) + yoff%
      '
      inc2% = inc2% + 2
      inc% = inc% + 3
      '
    LOOP WHILE inc% < points3% + 1
    '
    ' Draw Top
    '
    LINE (scr(1), scr(2))-(scr(3), scr(4)), 48
    LINE -(scr(5), scr(6)), 48
    LINE -(scr(7), scr(8)), 48
    LINE -(scr(1), scr(2)), 48
    '
    ' Draw Bottom
    '
    LINE (scr(9), scr(10))-(scr(11), scr(12)), 48
    LINE -(scr(13), scr(14)), 48
    LINE -(scr(15), scr(16)), 48
    LINE -(scr(9), scr(10)), 48
    '
    ' Draw Sides
    '
    LINE (scr(1), scr(2))-(scr(9), scr(10)), 48
    LINE (scr(3), scr(4))-(scr(11), scr(12)), 48
    LINE (scr(5), scr(6))-(scr(13), scr(14)), 48
    LINE (scr(7), scr(8))-(scr(15), scr(16)), 48
    '
    inc% = 1
    '
  END IF
  '
  IF INKEY$ = CHR$(27) THEN
    '
    SCREEN 0: WIDTH 80, 25
    '
    END
    '
  END IF
  '
  _DELAY 0.005
  '
LOOP
'
' *** Coordinates of the cube ***
' TOP
'      x   y   z
DATA -10,10,10
DATA -10,10,-10
DATA 10,10,-10
DATA 10,10,10
' BOTTOM
DATA -10,-10,10
DATA -10,-10,-10
DATA 10,-10,-10
DATA 10,-10,10


SUB flam
  '
  FOR py3% = 10 TO 148
    FOR px3% = 115 TO 206
      pol3% = POINT(px3%, py3%)
      pol3% = pol3% + POINT(px3% + 1, py3%)
      pol3% = pol3% + POINT(px3%, py3% + 1)
      pol3% = pol3% + POINT(px3% - 1, py3%)
      pol3% = pol3% + POINT(px3%, py3% - 1)
      '
      pol3% = pol3% \ 5 - 1
      '
      IF pol3% > 48 THEN
        pol3% = 48
      ELSE
        IF pol3% < 0 THEN pol3% = 0
      END IF
      '
      PSET (px3%, py3% - 3), pol3%
      '
    NEXT
  NEXT
  '
END SUB

SUB pal (slot AS INTEGER, red AS LONG, green AS LONG, blue AS LONG)
    '
    DIM palcolor AS LONG
    '
    palcolor = blue * 65536 + green * 256 + red
    '
    PALETTE slot, palcolor
    '
END SUB

