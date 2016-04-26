'
' Program    : Explosion Generator by Andrew L. Ayers
'              Palette routine by PHOBIA
' Date       : 03/03/1997
' Description: This program creates explosions which resemble gasoline
'              or hydrogen style, sorta like nebulas... Can be used to
'              build up a multi frame explosion sprite...
'
DECLARE SUB SetExplodePalette ()
DECLARE SUB Explode (ex%, ey%, rad%, den%, iter%)
'
SCREEN 13
'
' Initialize pallete
'
CALL SetExplodePalette
'
' Draw some explosions
'
CALL Explode(120, 60, 40, 1350, 3)
CALL Explode(160, 100, 50, 2350, 3)
CALL Explode(200, 70, 30, 900, 3)
CALL Explode(220, 150, 45, 1300, 3)

SUB Explode (ex%, ey%, rad%, den%, iter%)
'
' Calculate palette step rate based on explosion radius
'
stepr! = 48 / rad%
'
' Set up random particles for explosion, with pixel color
' becoming "cooler" with distance...
'
FOR t% = 0 TO den%
    th! = RND * 6.28
    ds% = INT(RND * rad%)
    px% = ex% + SIN(th!) * ds%
    py% = ey% + COS(th!) * ds%
    PSET (px%, py%), 47 - (ds% * stepr!)
NEXT
'
' Loop through onscreen matrix of points, doing an 8x8 smoothing
' interpolation pixel filter to blend adjacent pixels together...
'
FOR t% = 1 TO iter%
    FOR y% = ey% - rad% TO ey% + rad%
        FOR x% = ex% - rad% TO ex% + rad%
            col1% = POINT(x% - 1, y% - 1)
            col2% = POINT(x%, y% - 1)
            col3% = POINT(x% + 1, y% - 1)
            col4% = POINT(x% - 1, y%)
            col5% = POINT(x% + 1, y%)
            col6% = POINT(x% - 1, y% + 1)
            col7% = POINT(x%, y% + 1)
            col8% = POINT(x% + 1, y% + 1)
            colm% = POINT(x%, y%)
            '
            col% = (col1% + col2% + col3% + col4% + col5% + col6% + col7% + col8% + colm%) \ 9
            '
            PSET (x%, y%), col%
        NEXT
    NEXT
NEXT
'
END SUB

SUB SetExplodePalette
'
' Original routine by PHOBIA
'

FOR slot% = 0 TO 63
    '
    ' Fade from black to red

    CALL setpal(slot% / 4, slot%, 0, 0)
    '
    ' Fade from red to yellow
    '
    CALL setpal(slot% / 4 + 16, 63, slot%, 0)
    '
    ' Fade from yellow to white
    '
    CALL setpal(slot% / 4 + 32, 63, 63, slot%)
    '
NEXT
'
END SUB

SUB setpal (slot AS INTEGER, red AS LONG, green AS LONG, blue AS LONG)
    '
    DIM palcolor AS LONG
    '
    palcolor = blue * 65536 + green * 256 + red
    '
    PALETTE slot, palcolor
    '
END SUB

