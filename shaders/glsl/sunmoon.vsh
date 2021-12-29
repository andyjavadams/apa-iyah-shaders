// __multiversion__
// This signals the loading code to prepend either #version 100 or #version 300 es as apropriate.

#include "vertexVersionCentroidUV.h"

#include "uniformWorldConstants.h"

attribute POS4 POSITION;
attribute vec2 TEXCOORD_0;

varying vec3 w_pos;

void main()
{
POS4 pp =POSITION*vec4(7.0,1.0,7.0,1.0)+vec4(0.0,0.0,0.0,0.0);
w_pos =POSITION.xyz;
    gl_Position = WORLDVIEWPROJ * pp;

    uv = TEXCOORD_0;
}