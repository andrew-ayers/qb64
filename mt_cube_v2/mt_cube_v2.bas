'
' QB64 _MAPTRIANGLE Spinning Cube Demo V2 by Andrew L. Ayers
'
' Now with different textures on each cube face, and interactive controls!
'
' Keyboard controls are as follows:
'
'   a = zoom in
'   z = zoom out
'   . = yaw CCW
'   , = yaw CW
'   s = pitch up
'   x = pitch down
'   n = roll CCW
'   m = roll CW
'   r = reset all
'   f = show/hide FPS
'   b = show/hide markers
'   q or ESC = quit
'
' GNU GENERAL PUBLIC LICENSE
' Version 3, 29 June 2007
'
' Copyright (C) 2011 by Andrew L. Ayers
'
' This program is free software: you can redistribute it and/or modify
' it under the terms of the GNU General Public License as published by
' the Free Software Foundation, either version 3 of the License, or
' (at your option) any later version.
'
' This program is distributed in the hope that it will be useful,
' but WITHOUT ANY WARRANTY; without even the implied warranty of
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
' GNU General Public License for more details:
'
' <http://www.gnu.org/licenses/>
'
DIM OBJECT(9, 9, 4, 2) AS LONG
'
' OBJECTS DEFINED AS FOLLOWS:
'   (#OBJECTS,#PLANES PER OBJECT,#POINTS PER PLANE, XYZ TRIPLE)
'
DIM DPLANE2D(4, 1) AS LONG ' SCREEN PLANE COORDINATES
'
' DPLANE2D DEFINED AS FOLLOWS:
'   (#POINTS PER PLANE, XY DOUBLE)
'
DIM DPLANE3D(4, 2) AS LONG ' 3D PLANE COORDINATES
'
' DPLANE3D DEFINED AS FOLLOWS:
'   (#POINTS PER PLANE, XYZ TRIPLE)
'
DIM PLANETEX(9) AS INTEGER
'
DIM TEXTURE(9) AS LONG ' TEXTURE BUFFERS
'
DIM STAB(1023), CTAB(1023) ' SINE/COSINE TABLES
'
D& = 400: MX& = 0: MY& = 0: MZ& = -100: RD& = 0: PD& = 0: YD& = 0: fp% = -1: fdm% = 0
'
' COMPUTE SINE/COSINE TABLES
'
tau! = 3.14159 * 2
'
FOR i& = 0 TO 1023
  STAB(i&) = SIN((tau! / 1024) * i&)
  CTAB(i&) = COS((tau! / 1024) * i&)
NEXT
'
' BUILD CUBE IN OBJECT ARRAY
'
' PLANE 0
OBJECT(0, 0, 0, 0) = -30: OBJECT(0, 0, 0, 1) = 30: OBJECT(0, 0, 0, 2) = -30
OBJECT(0, 0, 1, 0) = -30: OBJECT(0, 0, 1, 1) = -30: OBJECT(0, 0, 1, 2) = -30
OBJECT(0, 0, 2, 0) = 30: OBJECT(0, 0, 2, 1) = -30: OBJECT(0, 0, 2, 2) = -30
OBJECT(0, 0, 3, 0) = 30: OBJECT(0, 0, 3, 1) = 30: OBJECT(0, 0, 3, 2) = -30
OBJECT(0, 0, 4, 0) = 0: OBJECT(0, 0, 4, 1) = 0: OBJECT(0, 0, 4, 2) = -30
'
' PLANE 1
OBJECT(0, 1, 0, 0) = 30: OBJECT(0, 1, 0, 1) = 30: OBJECT(0, 1, 0, 2) = -30
OBJECT(0, 1, 1, 0) = 30: OBJECT(0, 1, 1, 1) = -30: OBJECT(0, 1, 1, 2) = -30
OBJECT(0, 1, 2, 0) = 30: OBJECT(0, 1, 2, 1) = -30: OBJECT(0, 1, 2, 2) = 30
OBJECT(0, 1, 3, 0) = 30: OBJECT(0, 1, 3, 1) = 30: OBJECT(0, 1, 3, 2) = 30
OBJECT(0, 1, 4, 0) = 30: OBJECT(0, 1, 4, 1) = 0: OBJECT(0, 1, 4, 2) = 0
'
' PLANE 2
OBJECT(0, 2, 0, 0) = 30: OBJECT(0, 2, 0, 1) = 30: OBJECT(0, 2, 0, 2) = 30
OBJECT(0, 2, 1, 0) = 30: OBJECT(0, 2, 1, 1) = -30: OBJECT(0, 2, 1, 2) = 30
OBJECT(0, 2, 2, 0) = -30: OBJECT(0, 2, 2, 1) = -30: OBJECT(0, 2, 2, 2) = 30
OBJECT(0, 2, 3, 0) = -30: OBJECT(0, 2, 3, 1) = 30: OBJECT(0, 2, 3, 2) = 30
OBJECT(0, 2, 4, 0) = 0: OBJECT(0, 2, 4, 1) = 0: OBJECT(0, 2, 4, 2) = 30
'
' PLANE 3
OBJECT(0, 3, 0, 0) = -30: OBJECT(0, 3, 0, 1) = 30: OBJECT(0, 3, 0, 2) = 30
OBJECT(0, 3, 1, 0) = -30: OBJECT(0, 3, 1, 1) = -30: OBJECT(0, 3, 1, 2) = 30
OBJECT(0, 3, 2, 0) = -30: OBJECT(0, 3, 2, 1) = -30: OBJECT(0, 3, 2, 2) = -30
OBJECT(0, 3, 3, 0) = -30: OBJECT(0, 3, 3, 1) = 30: OBJECT(0, 3, 3, 2) = -30
OBJECT(0, 3, 4, 0) = -30: OBJECT(0, 3, 4, 1) = 0: OBJECT(0, 3, 4, 2) = 0
'
' PLANE 4
OBJECT(0, 4, 0, 0) = -30: OBJECT(0, 4, 0, 1) = -30: OBJECT(0, 4, 0, 2) = -30
OBJECT(0, 4, 1, 0) = -30: OBJECT(0, 4, 1, 1) = -30: OBJECT(0, 4, 1, 2) = 30
OBJECT(0, 4, 2, 0) = 30: OBJECT(0, 4, 2, 1) = -30: OBJECT(0, 4, 2, 2) = 30
OBJECT(0, 4, 3, 0) = 30: OBJECT(0, 4, 3, 1) = -30: OBJECT(0, 4, 3, 2) = -30
OBJECT(0, 4, 4, 0) = 0: OBJECT(0, 4, 4, 1) = -30: OBJECT(0, 4, 4, 2) = 0
'
' PLANE 5
OBJECT(0, 5, 0, 0) = -30: OBJECT(0, 5, 0, 1) = 30: OBJECT(0, 5, 0, 2) = -30
OBJECT(0, 5, 1, 0) = 30: OBJECT(0, 5, 1, 1) = 30: OBJECT(0, 5, 1, 2) = -30
OBJECT(0, 5, 2, 0) = 30: OBJECT(0, 5, 2, 1) = 30: OBJECT(0, 5, 2, 2) = 30
OBJECT(0, 5, 3, 0) = -30: OBJECT(0, 5, 3, 1) = 30: OBJECT(0, 5, 3, 2) = 30
OBJECT(0, 5, 4, 0) = 0: OBJECT(0, 5, 4, 1) = 30: OBJECT(0, 5, 4, 2) = 0
'
' SET UP PLANE TEXTURES FOR CUBE
'
PLANETEX(0) = 0
PLANETEX(1) = 1
PLANETEX(2) = 2
PLANETEX(3) = 3
PLANETEX(4) = 4
PLANETEX(5) = 5
'
_TITLE "QB64 _MAPTRIANGLE CUBE DEMO V2"
'
SCREENIMAGE& = _NEWIMAGE(800, 600, 32)
'
SCREEN SCREENIMAGE&
'
TEXTURE(0) = _LOADIMAGE("images\neon_256.png")
TEXTURE(1) = _LOADIMAGE("images\lena_256.png")
TEXTURE(2) = _LOADIMAGE("images\qb64_256.png")
TEXTURE(3) = _LOADIMAGE("images\baboon_256.png")
TEXTURE(4) = _LOADIMAGE("images\metal_256.png")
TEXTURE(5) = _LOADIMAGE("images\kingtut_256.png")
'
Background& = _LOADIMAGE("images\quasar_800.png")
'
DO
  '
  ' LIMIT TO 100 FPS
  '
  _LIMIT 100
  '
  ' ERASE LAST IMAGE
  '
  _PUTIMAGE , Background&
  '
  '
  ' CALCULATE POSITION OF NEW IMAGE
  '
  FOR OB& = 0 TO 0 ' UP TO 9 OBJECTS
    '
    SP = STAB(PIT(OB&)): CP = CTAB(PIT(OB&))
    SY = STAB(YAW(OB&)): CY = CTAB(YAW(OB&))
    SR = STAB(ROL(OB&)): CR = CTAB(ROL(OB&))
    '
    FOR PL& = 0 TO 5 ' CONSISTING OF UP TO 9 PLANES
      '
      FOR PN& = 0 TO 3 ' EACH PLANE WITH UP TO 4 POINTS (#5 TO PAINT)
        '
        ' TRANSLATE, THEN ROTATE
        '
        TX& = OBJECT(OB&, PL&, PN&, 0)
        TY& = OBJECT(OB&, PL&, PN&, 1)
        TZ& = OBJECT(OB&, PL&, PN&, 2)
        '
        RX& = (TZ& * CP - TY& * SP) * SY - ((TZ& * SP + TY& * CP) * SR + TX& * CR) * CY
        RY& = (TZ& * SP + TY& * CP) * CR - TX& * SR
        RZ& = (TZ& * CP - TY& * SP) * CY + ((TZ& * SP + TY& * CP) * SR + TX& * CR) * SY
        '
        ' ROTATE, THEN TRANSLATE
        '
        RX& = RX& + MX&
        RY& = RY& + MY&
        RZ& = RZ& + MZ&
        '
        DPLANE3D(PN&, 0) = RX&: DPLANE3D(PN&, 1) = RY&: DPLANE3D(PN&, 2) = RZ&
        '
        DPLANE2D(PN&, 0) = 399 + (D& * RX& / RZ&)
        DPLANE2D(PN&, 1) = 299 + (D& * RY& / RZ&)
        '
      NEXT
      '
      ' CHECK TO SEE IF PLANE IS VISIBLE
      '
      x1& = DPLANE3D(0, 0): y1& = DPLANE3D(0, 1): Z1& = DPLANE3D(0, 2)
      x2& = DPLANE3D(1, 0): y2& = DPLANE3D(1, 1): Z2& = DPLANE3D(1, 2)
      x3& = DPLANE3D(2, 0): y3& = DPLANE3D(2, 1): Z3& = DPLANE3D(2, 2)
      '
      T1& = -x1& * (y2& * Z3& - y3& * Z2&)
      T2& = x2& * (y3& * Z1& - y1& * Z3&)
      T3& = x3& * (y1& * Z2& - y2& * Z1&)
      '
      VISIBLE& = T1& - T2& - T3&
      '
      IF VISIBLE& > 0 THEN
        '
        ' DRAW PLANE
        '
        xx1% = DPLANE2D(0, 0): yy1% = DPLANE2D(0, 1)
        xx2% = DPLANE2D(1, 0): yy2% = DPLANE2D(1, 1)
        xx3% = DPLANE2D(2, 0): yy3% = DPLANE2D(2, 1)
        xx4% = DPLANE2D(3, 0): yy4% = DPLANE2D(3, 1)
        '
        tex% = PLANETEX(PL&)
        '
        _MAPTRIANGLE (0, 0)-(255, 0)-(0, 255), TEXTURE(tex%) TO(xx4%, yy4%)-(xx1%, yy1%)-(xx3%, yy3%)
        _MAPTRIANGLE (255, 0)-(0, 255)-(255, 255), TEXTURE(tex%) TO(xx1%, yy1%)-(xx3%, yy3%)-(xx2%, yy2%)
        '
        IF fdm% = -1 THEN
          CIRCLE (xx1%, yy1%), 5, _RGB(255, 0, 0)
          CIRCLE (xx2%, yy2%), 5, _RGB(0, 255, 0)
          CIRCLE (xx3%, yy3%), 5, _RGB(0, 0, 255)
          CIRCLE (xx4%, yy4%), 5, _RGB(255, 255, 0)
        END IF
        '
      END IF
      '
    NEXT
    '
    ' ROTATE OBJECT
    '
    PIT(OB&) = PIT(OB&) + PD&
    IF PIT(OB&) < 0 THEN PIT(OB&) = 1023
    IF PIT(OB&) > 1023 THEN PIT(OB&) = 0
    '
    YAW(OB&) = YAW(OB&) + YD&
    IF YAW(OB&) < 0 THEN YAW(OB&) = 1023
    IF YAW(OB&) > 1023 THEN YAW(OB&) = 0
    '
    ROL(OB&) = ROL(OB&) + RD&
    IF ROL(OB&) < 0 THEN ROL(OB&) = 1023
    IF ROL(OB&) > 1023 THEN ROL(OB&) = 0
    '
  NEXT
  '
  ' Calculate Frames per Second
  '
  frames% = frames% + 1
  '
  IF oldtime$ <> TIME$ THEN
    fps% = frames%
    frames% = 1
    oldtime$ = TIME$
  END IF
  '
  COLOR _RGB(255, 255, 255): LOCATE 1, 1
  '
  IF fp% = -1 THEN
    PRINT "FPS :"; fps%
  END IF
  '
  ' Get user key input
  '
  k$ = INKEY$
  '
  IF k$ <> "" THEN
    keys% = ASC(k$)
  ELSE
    keys% = -1
  END IF
  '
  SELECT CASE keys%
    CASE 97 ' a = zoom in
      MZ& = MZ& + 5
    CASE 122 ' z = zoom out
      MZ& = MZ& - 5
    CASE 46 ' . = yaw CCW
      YD& = YD& - 1
    CASE 44 ' , = yaw CW
      YD& = YD& + 1
    CASE 115 ' s = pitch up
      PD& = PD& + 1
    CASE 120 ' x = pitch down
      PD& = PD& - 1
    CASE 110 ' n = roll CCW
      RD& = RD& - 1
    CASE 109 ' m = roll CW
      RD& = RD& + 1
    CASE 114 ' r = reset all
      MZ& = -100: PD& = 0: YD& = 0: RD& = 0
      PIT(0) = 0: YAW(0) = 0: ROL(0) = 0
      fp% = -1: fdm% = 0
    CASE 102 ' f = show/hide FPS
      fp% = NOT fp%
    CASE 98 ' b = show/hide markers
      fdm% = NOT fdm%
    CASE 27, 113 ' esc or q = quit
      EXIT DO
    CASE ELSE
      ' do nothing
  END SELECT
  '
  'PRINT "KEY :"; keys%
  '
  ' Show image on screen
  '
  _DISPLAY
  '
LOOP
'
WIDTH 80: SCREEN 0: CLS
'
FOR i& = 0 TO 5
  _FREEIMAGE TEXTURE(i&)
NEXT
'
_FREEIMAGE Background&
'
_FREEIMAGE SCREENIMAGE&
'
SYSTEM
