DECLARE SUB GetUserInput (camera AS ANY)
DECLARE SUB Animate3D (object AS ANY)
DECLARE SUB TranslateObject3D (object AS ANY)
DECLARE SUB RotateObject3D (object AS ANY)
DECLARE SUB ScaleObject3D (object AS ANY)
DECLARE SUB TranslateCamera3D (object AS ANY, camera AS ANY)
DECLARE SUB RotateCamera3D (object AS ANY, camera AS ANY)
DECLARE SUB Project3D (object AS ANY, camera AS ANY)
DECLARE SUB DrawObject3D (object AS ANY)
'
TYPE PNT3D
  '
  ' World Coordinates
  '
  x AS SINGLE
  y AS SINGLE
  z AS SINGLE
  '
  ' Screen Coordinates
  '
  sx AS SINGLE
  sy AS SINGLE
  '
END TYPE
'
TYPE ROT3D
  '
  yaw AS SINGLE
  pit AS SINGLE
  rol AS SINGLE
  '
END TYPE
'
TYPE OBJECT3D
  '
  posn AS PNT3D ' Position (X,Y,Z)
  rotn AS ROT3D ' Rotation (Yaw, Pitch and Roll)
  scal AS PNT3D ' Scale (X,Y,Z)
  '
  ' Points
  '
  p1 AS PNT3D
  p2 AS PNT3D
  p3 AS PNT3D
  p4 AS PNT3D
  p5 AS PNT3D
  p6 AS PNT3D
  p7 AS PNT3D
  p8 AS PNT3D
  '
END TYPE
'
TYPE CAMERA3D
  '
  posn AS PNT3D ' Position (X,Y,Z)
  rotn AS ROT3D ' Rotation (Yaw, Pitch and Roll)
  '
  viewd AS SINGLE ' Distance from viewer to image plane
  '
END TYPE
'
DIM Cube1 AS OBJECT3D
DIM TempObject AS OBJECT3D
DIM Player1 AS CAMERA3D
'
' ***************************************************************************
'                               Set up user position
' ***************************************************************************
'
Player1.posn.x = 250: Player1.posn.y = 300: Player1.posn.z = -450
Player1.rotn.yaw = 5.8: Player1.rotn.pit = .5: Player1.rotn.rol = 0
Player1.viewd = 750
'
' ***************************************************************************
'                                 Set up an object
' ***************************************************************************
'
' Cube Top
'
Cube1.p1.x = -50: Cube1.p2.x = -50: Cube1.p3.x = 50: Cube1.p4.x = 50
Cube1.p1.y = -50: Cube1.p2.y = -50: Cube1.p3.y = -50: Cube1.p4.y = -50
Cube1.p1.z = 50: Cube1.p2.z = -50: Cube1.p3.z = -50: Cube1.p4.z = 50
'
' Cube Bottom
'
Cube1.p5.x = -50: Cube1.p6.x = -50: Cube1.p7.x = 50: Cube1.p8.x = 50
Cube1.p5.y = 50: Cube1.p6.y = 50: Cube1.p7.y = 50: Cube1.p8.y = 50
Cube1.p5.z = 50: Cube1.p6.z = -50: Cube1.p7.z = -50: Cube1.p8.z = 50
'
Cube1.posn.x = 0: Cube1.posn.y = 0: Cube1.posn.z = 0
Cube1.rotn.yaw = 0: Cube1.rotn.pit = 0: Cube1.rotn.rol = 0
Cube1.scal.x = .5: Cube1.scal.y = .5: Cube1.scal.z = .5
'
SCREEN 13
'
CONST SWID = 319 ' 639
CONST SHGT = 199 ' 349
CONST SCX = 159 ' 319
CONST SCY = 99 ' 174
'
' ***************************************************************************
'
DO
  '
  CLS
  '
  CALL GetUserInput(Player1)
  '
  TempObject = Cube1
  '
  CALL ScaleObject3D(TempObject)
  CALL RotateObject3D(TempObject)
  CALL TranslateObject3D(TempObject)
  CALL TranslateCamera3D(TempObject, Player1)
  CALL RotateCamera3D(TempObject, Player1)
  CALL Project3D(TempObject, Player1)
  CALL DrawObject3D(TempObject)
  '
  _DISPLAY
  '
LOOP

SUB DrawObject3D (object AS OBJECT3D)
  '
  ' Draw Top
  '
  LINE (object.p5.sx, object.p5.sy)-(object.p6.sx, object.p6.sy), 15
  LINE -(object.p7.sx, object.p7.sy), 15
  LINE -(object.p8.sx, object.p8.sy), 15
  LINE -(object.p5.sx, object.p5.sy), 15
  '
  ' Draw bottom
  '
  LINE (object.p1.sx, object.p1.sy)-(object.p2.sx, object.p2.sy), 15
  LINE -(object.p3.sx, object.p3.sy), 15
  LINE -(object.p4.sx, object.p4.sy), 15
  LINE -(object.p1.sx, object.p1.sy), 15
  '
  ' Draw sides
  '
  LINE (object.p1.sx, object.p1.sy)-(object.p5.sx, object.p5.sy), 15
  LINE (object.p2.sx, object.p2.sy)-(object.p6.sx, object.p6.sy), 15
  LINE (object.p3.sx, object.p3.sy)-(object.p7.sx, object.p7.sy), 15
  LINE (object.p4.sx, object.p4.sy)-(object.p8.sx, object.p8.sy), 15
  '
END SUB

SUB GetUserInput (camera AS CAMERA3D)
  '
  ' Get user input
  '
  A$ = INKEY$
  '
  SELECT CASE A$
    CASE ">", "."
      camera.rotn.yaw = camera.rotn.yaw + .005
      IF camera.rotn.yaw > 6.28318 THEN camera.rotn.yaw = 0
    CASE "<", ","
      camera.rotn.yaw = camera.rotn.yaw - .005
      IF camera.rotn.yaw < 0 THEN camera.rotn.yaw = 6.28318
    CASE "Z", "z"
      camera.posn.x = camera.posn.x - SIN(camera.rotn.yaw) * 5
      camera.posn.z = camera.posn.z - COS(camera.rotn.yaw) * 5
    CASE "A", "a"
      camera.posn.x = camera.posn.x + SIN(camera.rotn.yaw) * 5
      camera.posn.z = camera.posn.z + COS(camera.rotn.yaw) * 5
    CASE "S", "s"
      camera.rotn.pit = camera.rotn.pit - .005
      IF camera.rotn.pit < 0 THEN camera.rotn.pit = 6.28318
    CASE "X", "x"
      camera.rotn.pit = camera.rotn.pit + .005
      IF camera.rotn.pit > 6.28318 THEN camera.rotn.pit = 0
    CASE "D", "d"
      camera.posn.y = camera.posn.y - SIN(camera.rotn.yaw) * 5
      'camera.posn.z = camera.posn.z - COS(camera.rotn.yaw) * 5
    CASE "C", "c"
      camera.posn.y = camera.posn.y + SIN(camera.rotn.yaw) * 5
      'camera.posn.z = camera.posn.z + COS(camera.rotn.yaw) * 5
    CASE "Q", "q"
      STOP
  END SELECT
  '
END SUB

SUB Project3D (object AS OBJECT3D, camera AS CAMERA3D)
  '
  ' Project each world coordinate to screen coordinate
  '
  object.p1.sx = SCX + ((camera.viewd * object.p1.x) / object.p1.z): object.p1.sy = SCY + ((camera.viewd * object.p1.y) / object.p1.z)
  object.p2.sx = SCX + ((camera.viewd * object.p2.x) / object.p2.z): object.p2.sy = SCY + ((camera.viewd * object.p2.y) / object.p2.z)
  object.p3.sx = SCX + ((camera.viewd * object.p3.x) / object.p3.z): object.p3.sy = SCY + ((camera.viewd * object.p3.y) / object.p3.z)
  object.p4.sx = SCX + ((camera.viewd * object.p4.x) / object.p4.z): object.p4.sy = SCY + ((camera.viewd * object.p4.y) / object.p4.z)
  object.p5.sx = SCX + ((camera.viewd * object.p5.x) / object.p5.z): object.p5.sy = SCY + ((camera.viewd * object.p5.y) / object.p5.z)
  object.p6.sx = SCX + ((camera.viewd * object.p6.x) / object.p6.z): object.p6.sy = SCY + ((camera.viewd * object.p6.y) / object.p6.z)
  object.p7.sx = SCX + ((camera.viewd * object.p7.x) / object.p7.z): object.p7.sy = SCY + ((camera.viewd * object.p7.y) / object.p7.z)
  object.p8.sx = SCX + ((camera.viewd * object.p8.x) / object.p8.z): object.p8.sy = SCY + ((camera.viewd * object.p8.y) / object.p8.z)
  '
END SUB

SUB RotateCamera3D (object AS OBJECT3D, camera AS CAMERA3D)
  '
  yaw = -camera.rotn.yaw
  pit = -camera.rotn.pit
  rol = -camera.rotn.rol
  '
  ' Rotate each point by the yaw, pitch and roll amounts for the camera
  '
  ' Yaw
  '
  rx = object.p1.x * COS(yaw) + object.p1.z * SIN(yaw): ry = object.p1.y: rz = object.p1.x * SIN(yaw) - object.p1.z * COS(yaw): object.p1.x = rx: object.p1.y = ry: object.p1.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p2.x * COS(yaw) + object.p2.z * SIN(yaw): ry = object.p2.y: rz = object.p2.x * SIN(yaw) - object.p2.z * COS(yaw): object.p2.x = rx: object.p2.y = ry: object.p2.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p3.x * COS(yaw) + object.p3.z * SIN(yaw): ry = object.p3.y: rz = object.p3.x * SIN(yaw) - object.p3.z * COS(yaw): object.p3.x = rx: object.p3.y = ry: object.p3.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p4.x * COS(yaw) + object.p4.z * SIN(yaw): ry = object.p4.y: rz = object.p4.x * SIN(yaw) - object.p4.z * COS(yaw): object.p4.x = rx: object.p4.y = ry: object.p4.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p5.x * COS(yaw) + object.p5.z * SIN(yaw): ry = object.p5.y: rz = object.p5.x * SIN(yaw) - object.p5.z * COS(yaw): object.p5.x = rx: object.p5.y = ry: object.p5.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p6.x * COS(yaw) + object.p6.z * SIN(yaw): ry = object.p6.y: rz = object.p6.x * SIN(yaw) - object.p6.z * COS(yaw): object.p6.x = rx: object.p6.y = ry: object.p6.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p7.x * COS(yaw) + object.p7.z * SIN(yaw): ry = object.p7.y: rz = object.p7.x * SIN(yaw) - object.p7.z * COS(yaw): object.p7.x = rx: object.p7.y = ry: object.p7.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p8.x * COS(yaw) + object.p8.z * SIN(yaw): ry = object.p8.y: rz = object.p8.x * SIN(yaw) - object.p8.z * COS(yaw): object.p8.x = rx: object.p8.y = ry: object.p8.z = rz + (NOT (INT(rz)) * .0001)
  '
  ' Pitch
  '
  rx = object.p1.x: ry = object.p1.y * COS(pit) + object.p1.z * SIN(pit): rz = object.p1.y * SIN(pit) - object.p1.z * COS(pit): object.p1.x = rx: object.p1.y = ry: object.p1.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p2.x: ry = object.p2.y * COS(pit) + object.p2.z * SIN(pit): rz = object.p2.y * SIN(pit) - object.p2.z * COS(pit): object.p2.x = rx: object.p2.y = ry: object.p2.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p3.x: ry = object.p3.y * COS(pit) + object.p3.z * SIN(pit): rz = object.p3.y * SIN(pit) - object.p3.z * COS(pit): object.p3.x = rx: object.p3.y = ry: object.p3.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p4.x: ry = object.p4.y * COS(pit) + object.p4.z * SIN(pit): rz = object.p4.y * SIN(pit) - object.p4.z * COS(pit): object.p4.x = rx: object.p4.y = ry: object.p4.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p5.x: ry = object.p5.y * COS(pit) + object.p5.z * SIN(pit): rz = object.p5.y * SIN(pit) - object.p5.z * COS(pit): object.p5.x = rx: object.p5.y = ry: object.p5.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p6.x: ry = object.p6.y * COS(pit) + object.p6.z * SIN(pit): rz = object.p6.y * SIN(pit) - object.p6.z * COS(pit): object.p6.x = rx: object.p6.y = ry: object.p6.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p7.x: ry = object.p7.y * COS(pit) + object.p7.z * SIN(pit): rz = object.p7.y * SIN(pit) - object.p7.z * COS(pit): object.p7.x = rx: object.p7.y = ry: object.p7.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p8.x: ry = object.p8.y * COS(pit) + object.p8.z * SIN(pit): rz = object.p8.y * SIN(pit) - object.p8.z * COS(pit): object.p8.x = rx: object.p8.y = ry: object.p8.z = rz + (NOT (INT(rz)) * .0001)
  '
  ' Roll
  '
  rx = object.p1.x * COS(rol) + object.p1.y * SIN(rol): ry = object.p1.x * SIN(rol) - object.p1.y * COS(rol): rz = object.p1.z: object.p1.x = rx: object.p1.y = ry: object.p1.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p2.x * COS(rol) + object.p2.y * SIN(rol): ry = object.p2.x * SIN(rol) - object.p2.y * COS(rol): rz = object.p2.z: object.p2.x = rx: object.p2.y = ry: object.p2.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p3.x * COS(rol) + object.p3.y * SIN(rol): ry = object.p3.x * SIN(rol) - object.p3.y * COS(rol): rz = object.p3.z: object.p3.x = rx: object.p3.y = ry: object.p3.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p4.x * COS(rol) + object.p4.y * SIN(rol): ry = object.p4.x * SIN(rol) - object.p4.y * COS(rol): rz = object.p4.z: object.p4.x = rx: object.p4.y = ry: object.p4.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p5.x * COS(rol) + object.p5.y * SIN(rol): ry = object.p5.x * SIN(rol) - object.p5.y * COS(rol): rz = object.p5.z: object.p5.x = rx: object.p5.y = ry: object.p5.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p6.x * COS(rol) + object.p6.y * SIN(rol): ry = object.p6.x * SIN(rol) - object.p6.y * COS(rol): rz = object.p6.z: object.p6.x = rx: object.p6.y = ry: object.p6.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p7.x * COS(rol) + object.p7.y * SIN(rol): ry = object.p7.x * SIN(rol) - object.p7.y * COS(rol): rz = object.p7.z: object.p7.x = rx: object.p7.y = ry: object.p7.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p8.x * COS(rol) + object.p8.y * SIN(rol): ry = object.p8.x * SIN(rol) - object.p8.y * COS(rol): rz = object.p8.z: object.p8.x = rx: object.p8.y = ry: object.p8.z = rz + (NOT (INT(rz)) * .0001)
  '
END SUB

SUB RotateObject3D (object AS OBJECT3D)
  '
  yaw = object.rotn.yaw
  pit = object.rotn.pit
  rol = object.rotn.rol
  '
  ' Rotate each point by the yaw, pitch and roll amounts for the object
  '
  ' Yaw
  '
  rx = object.p1.x * COS(yaw) + object.p1.z * SIN(yaw): ry = object.p1.y: rz = object.p1.x * SIN(yaw) - object.p1.z * COS(yaw): object.p1.x = rx: object.p1.y = ry: object.p1.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p2.x * COS(yaw) + object.p2.z * SIN(yaw): ry = object.p2.y: rz = object.p2.x * SIN(yaw) - object.p2.z * COS(yaw): object.p2.x = rx: object.p2.y = ry: object.p2.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p3.x * COS(yaw) + object.p3.z * SIN(yaw): ry = object.p3.y: rz = object.p3.x * SIN(yaw) - object.p3.z * COS(yaw): object.p3.x = rx: object.p3.y = ry: object.p3.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p4.x * COS(yaw) + object.p4.z * SIN(yaw): ry = object.p4.y: rz = object.p4.x * SIN(yaw) - object.p4.z * COS(yaw): object.p4.x = rx: object.p4.y = ry: object.p4.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p5.x * COS(yaw) + object.p5.z * SIN(yaw): ry = object.p5.y: rz = object.p5.x * SIN(yaw) - object.p5.z * COS(yaw): object.p5.x = rx: object.p5.y = ry: object.p5.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p6.x * COS(yaw) + object.p6.z * SIN(yaw): ry = object.p6.y: rz = object.p6.x * SIN(yaw) - object.p6.z * COS(yaw): object.p6.x = rx: object.p6.y = ry: object.p6.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p7.x * COS(yaw) + object.p7.z * SIN(yaw): ry = object.p7.y: rz = object.p7.x * SIN(yaw) - object.p7.z * COS(yaw): object.p7.x = rx: object.p7.y = ry: object.p7.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p8.x * COS(yaw) + object.p8.z * SIN(yaw): ry = object.p8.y: rz = object.p8.x * SIN(yaw) - object.p8.z * COS(yaw): object.p8.x = rx: object.p8.y = ry: object.p8.z = rz + (NOT (INT(rz)) * .0001)
  '
  ' Pitch
  '
  rx = object.p1.x: ry = object.p1.y * COS(pit) + object.p1.z * SIN(pit): rz = object.p1.y * SIN(pit) - object.p1.z * COS(pit): object.p1.x = rx: object.p1.y = ry: object.p1.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p2.x: ry = object.p2.y * COS(pit) + object.p2.z * SIN(pit): rz = object.p2.y * SIN(pit) - object.p2.z * COS(pit): object.p2.x = rx: object.p2.y = ry: object.p2.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p3.x: ry = object.p3.y * COS(pit) + object.p3.z * SIN(pit): rz = object.p3.y * SIN(pit) - object.p3.z * COS(pit): object.p3.x = rx: object.p3.y = ry: object.p3.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p4.x: ry = object.p4.y * COS(pit) + object.p4.z * SIN(pit): rz = object.p4.y * SIN(pit) - object.p4.z * COS(pit): object.p4.x = rx: object.p4.y = ry: object.p4.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p5.x: ry = object.p5.y * COS(pit) + object.p5.z * SIN(pit): rz = object.p5.y * SIN(pit) - object.p5.z * COS(pit): object.p5.x = rx: object.p5.y = ry: object.p5.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p6.x: ry = object.p6.y * COS(pit) + object.p6.z * SIN(pit): rz = object.p6.y * SIN(pit) - object.p6.z * COS(pit): object.p6.x = rx: object.p6.y = ry: object.p6.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p7.x: ry = object.p7.y * COS(pit) + object.p7.z * SIN(pit): rz = object.p7.y * SIN(pit) - object.p7.z * COS(pit): object.p7.x = rx: object.p7.y = ry: object.p7.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p8.x: ry = object.p8.y * COS(pit) + object.p8.z * SIN(pit): rz = object.p8.y * SIN(pit) - object.p8.z * COS(pit): object.p8.x = rx: object.p8.y = ry: object.p8.z = rz + (NOT (INT(rz)) * .0001)
  '
  ' Roll
  '
  rx = object.p1.x * COS(rol) + object.p1.y * SIN(rol): ry = object.p1.x * SIN(rol) - object.p1.y * COS(rol): rz = object.p1.z: object.p1.x = rx: object.p1.y = ry: object.p1.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p2.x * COS(rol) + object.p2.y * SIN(rol): ry = object.p2.x * SIN(rol) - object.p2.y * COS(rol): rz = object.p2.z: object.p2.x = rx: object.p2.y = ry: object.p2.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p3.x * COS(rol) + object.p3.y * SIN(rol): ry = object.p3.x * SIN(rol) - object.p3.y * COS(rol): rz = object.p3.z: object.p3.x = rx: object.p3.y = ry: object.p3.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p4.x * COS(rol) + object.p4.y * SIN(rol): ry = object.p4.x * SIN(rol) - object.p4.y * COS(rol): rz = object.p4.z: object.p4.x = rx: object.p4.y = ry: object.p4.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p5.x * COS(rol) + object.p5.y * SIN(rol): ry = object.p5.x * SIN(rol) - object.p5.y * COS(rol): rz = object.p5.z: object.p5.x = rx: object.p5.y = ry: object.p5.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p6.x * COS(rol) + object.p6.y * SIN(rol): ry = object.p6.x * SIN(rol) - object.p6.y * COS(rol): rz = object.p6.z: object.p6.x = rx: object.p6.y = ry: object.p6.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p7.x * COS(rol) + object.p7.y * SIN(rol): ry = object.p7.x * SIN(rol) - object.p7.y * COS(rol): rz = object.p7.z: object.p7.x = rx: object.p7.y = ry: object.p7.z = rz + (NOT (INT(rz)) * .0001)
  rx = object.p8.x * COS(rol) + object.p8.y * SIN(rol): ry = object.p8.x * SIN(rol) - object.p8.y * COS(rol): rz = object.p8.z: object.p8.x = rx: object.p8.y = ry: object.p8.z = rz + (NOT (INT(rz)) * .0001)
  '
END SUB

SUB ScaleObject3D (object AS OBJECT3D)
  '
  ' Scale object points by object scale
  '
  ox = object.scal.x
  oy = object.scal.y
  oz = object.scal.z
  '
  object.p1.x = object.p1.x * ox: object.p1.y = object.p1.y * oy: object.p1.z = object.p1.z * oz
  object.p2.x = object.p2.x * ox: object.p2.y = object.p2.y * oy: object.p2.z = object.p2.z * oz
  object.p3.x = object.p3.x * ox: object.p3.y = object.p3.y * oy: object.p3.z = object.p3.z * oz
  object.p4.x = object.p4.x * ox: object.p4.y = object.p4.y * oy: object.p4.z = object.p4.z * oz
  object.p5.x = object.p5.x * ox: object.p5.y = object.p5.y * oy: object.p5.z = object.p5.z * oz
  object.p6.x = object.p6.x * ox: object.p6.y = object.p6.y * oy: object.p6.z = object.p6.z * oz
  object.p7.x = object.p7.x * ox: object.p7.y = object.p7.y * oy: object.p7.z = object.p7.z * oz
  object.p8.x = object.p8.x * ox: object.p8.y = object.p8.y * oy: object.p8.z = object.p8.z * oz
  '
END SUB

SUB TranslateCamera3D (object AS OBJECT3D, camera AS CAMERA3D)
  '
  ' Translate object points to camera position
  '
  ox = -camera.posn.x
  oy = -camera.posn.y
  oz = -camera.posn.z
  '
  object.p1.x = object.p1.x + ox: object.p1.y = object.p1.y + oy: object.p1.z = object.p1.z + oz
  object.p2.x = object.p2.x + ox: object.p2.y = object.p2.y + oy: object.p2.z = object.p2.z + oz
  object.p3.x = object.p3.x + ox: object.p3.y = object.p3.y + oy: object.p3.z = object.p3.z + oz
  object.p4.x = object.p4.x + ox: object.p4.y = object.p4.y + oy: object.p4.z = object.p4.z + oz
  object.p5.x = object.p5.x + ox: object.p5.y = object.p5.y + oy: object.p5.z = object.p5.z + oz
  object.p6.x = object.p6.x + ox: object.p6.y = object.p6.y + oy: object.p6.z = object.p6.z + oz
  object.p7.x = object.p7.x + ox: object.p7.y = object.p7.y + oy: object.p7.z = object.p7.z + oz
  object.p8.x = object.p8.x + ox: object.p8.y = object.p8.y + oy: object.p8.z = object.p8.z + oz
  '
END SUB

SUB TranslateObject3D (object AS OBJECT3D)
  '
  ' Translate object points to object position
  '
  ox = object.posn.x
  oy = object.posn.y
  oz = object.posn.z
  '
  object.p1.x = object.p1.x + ox: object.p1.y = object.p1.y + oy: object.p1.z = object.p1.z + oz
  object.p2.x = object.p2.x + ox: object.p2.y = object.p2.y + oy: object.p2.z = object.p2.z + oz
  object.p3.x = object.p3.x + ox: object.p3.y = object.p3.y + oy: object.p3.z = object.p3.z + oz
  object.p4.x = object.p4.x + ox: object.p4.y = object.p4.y + oy: object.p4.z = object.p4.z + oz
  object.p5.x = object.p5.x + ox: object.p5.y = object.p5.y + oy: object.p5.z = object.p5.z + oz
  object.p6.x = object.p6.x + ox: object.p6.y = object.p6.y + oy: object.p6.z = object.p6.z + oz
  object.p7.x = object.p7.x + ox: object.p7.y = object.p7.y + oy: object.p7.z = object.p7.z + oz
  object.p8.x = object.p8.x + ox: object.p8.y = object.p8.y + oy: object.p8.z = object.p8.z + oz
  '
END SUB

