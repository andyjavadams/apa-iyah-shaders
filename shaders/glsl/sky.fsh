// __multiversion__
// This signals the loading code to prepend either #version 100 or #version 300 es as apropriate.

#include "uniformShaderConstants.h"
#include "fragmentVersionSimple.h"
#include "uniformPerFrameConstants.h"

varying highp vec3 pos;

#include "lib/bsbe.glsl"
#include "lib/colorp.glsl"

void main(){

    float lenpos = length(pos);
    vec3 skyr = sky(lenpos);
    skyr = final(skyr);
gl_FragColor = vec4(skyr, 1.);

}
