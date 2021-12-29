// __multiversion__
// This signals the loading code to prepend either #version 100 or #version 300 es as apropriate.

#include "fragmentVersionCentroid.h"

#if __VERSION__ >= 300

#if defined(TEXEL_AA) && defined(TEXEL_AA_FEATURE)
_centroid in highp vec2 uv;
#else
_centroid in vec2 uv;
#endif

#else

varying vec2 uv;

#endif

#include "uniformShaderConstants.h"
#include "util.h"
#include "uniformPerFrameConstants.h"
#include "uniformShaderConstants.h"

uniform sampler2D TEXTURE_0;

varying vec3 w_pos;

void main()
{
#if !defined(TEXEL_AA) || !defined(TEXEL_AA_FEATURE)
	vec4 diffuse = texture2D( TEXTURE_0, uv );
#else
	vec4 diffuse = texture2D_AA(TEXTURE_0, uv );
#endif

vec4 fc =FOG_COLOR;
vec4 sfc =max(fc,vec4(1.0));

float sore =pow(max(min(1.0-fc.b*1.2,1.0),0.0),0.5);
float bengi =pow(max(min(1.0-fc.r*1.5,1.0),0.0),0.3);
float udan =pow(FOG_CONTROL.y,5.0);

float tipis = mix(0.5, 0.75, sore);
tipis = mix(tipis, 1.0, bengi);

float tbl = mix(2.0,2.0,sore);
tbl = mix(tbl, 1.0, bengi);

float bsr = mix(90.0, 90.0, sore);
bsr = mix(bsr, 65.0, bengi);

float bundar_kecil =1.0-pow(length(w_pos*bsr),bengi*9.0+0.6);

float silau =1.0-pow(length(w_pos*2.0),0.5*(pow(fc.g,5.0))*(1.0-sore)+(1.0-fc.b)*0.1);

vec4 matahari=vec4(sfc.r*0.9,1.65-fc.b,1.2-fc.b,1.0);

    vec4 silauan = vec4(matahari.rgb,tipis*(min(max(silau*udan,0.0),1.0)));

	gl_FragColor = mix(silauan,matahari,(max(min((bundar_kecil)*udan,1.0),0.0)));
}
