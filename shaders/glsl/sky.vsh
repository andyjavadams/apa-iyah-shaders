// __multiversion__
// This signals the loading code to prepend either #version 100 or #version 300 es as apropriate.

#include "vertexVersionSimple.h"
#include "uniformWorldConstants.h"
#include "uniformPerFrameConstants.h"
#include "uniformShaderConstants.h"

attribute mediump vec4 POSITION;
attribute vec4 COLOR;

varying vec3 pos;
varying vec4 color;

const float fogNear = 0.3;

void main(){

    vec4 mpos = POSITION;
    mpos.y -=clamp(length(POSITION.xyz),0.,1.)*.35;
        gl_Position = WORLDVIEWPROJ * mpos;
    pos = POSITION.xyz;
    color = COLOR;
}
