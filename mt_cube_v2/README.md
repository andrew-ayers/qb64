# mt_cube_v2.bas - QB64 _MAPTRIANGLE Spinning Cube Demo V2

### Features ###

* Affine texture-mapping using QB64 _MAPTRIANGLE function
* Backface culling
* SIN/COS table pre-calculated
* Keyboard controls

### About ###

This spinning cube demo was originally developed using QuickBASIC 4.5 and a
custom affine texture-mapping triangle rastorization algorithm implemented with
the help of some 80x86 assembler.

As an exercise I decided to re-implement it using QB64 and its built-in triangle
rasterizing function _MAPTRIANGLE, which conveniently allowed for images to be
used. Part of my reasoning was to see how well it would turn out using QB64, and
to demonstrate a method of implementing 3D functionality (at the time) for the
Linux port of QB64 (which at the time didn't support OpenGL - I believe the
latest version of QB64 for Linux does have support).

It turns out that QB64 and _MAPTRIANGLE work rather well for this task, at least
for a simple spinning cube.

As an affine texture-mapper, though, it does suffer from the "swimming texture"
artifacting, especially as the cube is zoomed in. From what I understand, the
latest version of _MAPTRIANGLE has some means to correct for this, and in effect
turn it into a "perspective correct" texture-mapper, but I haven't experimented
with it yet.

For now, I will leave it up to the reader to improve.

### Controls ###

The keyboard controls are as follows:

* a = zoom in
* z = zoom out
* . = yaw CCW
* , = yaw CW
* s = pitch up
* x = pitch down
* n = roll CCW
* m = roll CW
* r = reset all
* f = show/hide FPS
* b = show/hide markers
* q or ESC = quit

### License ###

Copyright (C) 2016 by Andrew L. Ayers

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 3 of the License, or (at your option) any later 
version.

This program is distributed in the hope that it will be useful, but WITHOUT 
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with 
this program; if not, write to the Free Software Foundation, Inc., 51 Franklin 
Street, Fifth Floor, Boston, MA 02110-1301  USA

### Who do I cuss out? ###

* Andrew L. Ayers - junkbotix@gmail.com
* http://www.phoenixgarage.org/
