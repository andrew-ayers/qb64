CONST TRUE = -1
CONST FALSE = 0

CONST pi = 3.14159265

CONST RBOX_NO = 0 ' None (no rounding)
CONST RBOX_UL = 1 ' Upper Left
CONST RBOX_UR = 2 ' Upper Right
CONST RBOX_LR = 4 ' Lower Right
CONST RBOX_LL = 8 ' Lower Left
CONST RBOX_FF = 16 ' Flood Fill

' Regular Screens
SCREEN 12
FOR t = 0 TO 80 STEP 10
  c = c + 1
  x = rbox(100 + t, 100 + t, 400 - t, 300 - t, c, c - 1, 15, RBOX_UL + RBOX_LR + RBOX_FF)
NEXT t

' _NEWIMAGE 32-bit screen
'SCREEN _NEWIMAGE(640, 480, 32)
'x = rbox(100, 100, 400, 300, _RGB(255, 255, 255), _RGB(0, 0, 0), 25, RBOX_UL + RBOX_LR)

END

FUNCTION rbox (x1 AS INTEGER, y1 AS INTEGER, x2 AS INTEGER, y2 AS INTEGER, fgcolor AS LONG, bgcolor AS LONG, radius AS INTEGER, style AS INTEGER)

  LINE (x1, y1)-(x2, y2), fgcolor, B

  IF ((x2 - x1) / 2 >= radius AND (y2 - y1) / 2 >= radius) THEN ' simple bounds check
    IF style > 0 THEN
      IF (style AND 1) THEN
        ' upper left round
        LINE (x1, y1)-(x1 + radius - 1, y1), bgcolor
        LINE (x1, y1)-(x1, y1 + radius - 1), bgcolor
        CIRCLE (x1 + radius, y1 + radius), radius, fgcolor, pi / 2, pi
      END IF

      IF (style AND 2) THEN
        ' upper right round
        LINE (x2, y1)-(x2 - radius + 1, y1), bgcolor
        LINE (x2, y1)-(x2, y1 + radius - 1), bgcolor
        CIRCLE (x2 - radius - 1, y1 + radius), radius, fgcolor, 0, pi / 2
      END IF

      IF (style AND 4) THEN
        ' lower right round
        LINE (x2, y2)-(x2 - radius + 1, y2), bgcolor
        LINE (x2, y2)-(x2, y2 - radius + 1), bgcolor
        CIRCLE (x2 - radius, y2 - radius), radius, fgcolor, pi * 1.5, 0
      END IF

      IF (style AND 8) THEN
        ' lower left round
        LINE (x1, y2)-(x1 + radius - 1, y2), bgcolor
        LINE (x1, y2)-(x1, y2 - radius + 1), bgcolor
        CIRCLE (x1 + radius + 1, y2 - radius), radius, fgcolor, pi, pi * 1.5
      END IF

      IF (style AND 16) THEN
        PAINT (x1 + (x2 - x1) / 2, y1 + (y2 - y1) / 2), fgcolor, fgcolor
      END IF
    END IF
  END IF
END FUNCTION
