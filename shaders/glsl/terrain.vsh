// __multiversion__
// This signals the loading code to prepend either #version 100 or #version 300 es as apropriate.

#include "vertexVersionCentroid.h"
#if __VERSION__ >= 300
	#ifndef BYPASS_PIXEL_SHADER
		_centroid out vec2 uv0;
		_centroid out vec2 uv1;
	#endif
#else
	#ifndef BYPASS_PIXEL_SHADER
		out vec2 uv0;
		out vec2 uv1;
	#endif
#endif

#include "uniformWorldConstants.h"
#include "uniformPerFrameConstants.h"
#include "uniformShaderConstants.h"
#include "uniformRenderChunkConstants.h"

uniform highp float TOTAL_REAL_WORLD_TIME;

#ifndef BYPASS_PIXEL_SHADER
varying vec4 color;
#endif

varying highp vec3 cpos;
varying highp vec3 wpos;
varying highp vec3 smpos;

#ifdef UNDERWATER
varying float fogr;
#endif

attribute POS4 POSITION;
attribute vec4 COLOR;
attribute vec2 TEXCOORD_0;
attribute vec2 TEXCOORD_1;

const float rA = 1.0;
const float rB = 1.0;
const vec3 UNIT_Y = vec3(0,1,0);
const float DIST_DESATURATION = 56.0 / 255.0; //WARNING this value is also hardcoded in the water color, don'tchange

/////////////////////////////////////////////////////////////////
///////////////////////// STOP! /////////////////////////////////
/////////////////////////////////////////////////////////////////
// Made by Sad - @bamboo_sapling
// successfully changed on Nov 2020.
// all of these assets are under MIT license.
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

#include "lib/hash.glsl"

void main()
{
highp vec3 wapos = vec3(POSITION.x==16.0 ? 0.0 : POSITION.x, abs(POSITION.y-8.), POSITION.z==16.0 ? 0.0 : POSITION.z);
	POS4 worldPos;
#ifdef AS_ENTITY_RENDERER
		POS4 pos = WORLDVIEWPROJ * POSITION;
		worldPos = pos;
#else
	worldPos.xyz = (POSITION.xyz * CHUNK_ORIGIN_AND_SCALE.w) + CHUNK_ORIGIN_AND_SCALE.xyz;
	worldPos.w = 1.0;
#if !defined(SEASONS) || !defined(ALPHA_TEST) || defined(WATERWAVE)
	if(COLOR.a < .95 && COLOR.a > .05)worldPos.y +=(sin(TOTAL_REAL_WORLD_TIME*3.+wapos.x+wapos.z+wapos.y)*hash(wapos.x+wapos.y+wapos.z))*.1*fract(POSITION.y);
#endif
	POS4 pos = WORLDVIEW * worldPos;
	pos = PROJ * pos;
#endif
	gl_Position = pos;

#ifndef BYPASS_PIXEL_SHADER
	uv0 = TEXCOORD_0;
	uv1 = TEXCOORD_1;
	color = COLOR;
#endif
	cpos = POSITION.xyz;
	wpos = worldPos.xyz;
 	smpos = (worldPos.x > 0.) ? worldPos.xyz -= worldPos.x * .45 : worldPos.xyz += worldPos.x * .45;
	highp float wave_factor = 0.0;
#ifdef ALPHA_TEST
	vec3 frp = fract(POSITION.xyz);
	//detection of plant and leaf movements by @McbeEringi
	if((color.r!=color.g&&color.g!=color.b && frp.y!=.015625)||(frp.y==.9375&&(frp.x==0.||frp.z==0.))){
		wave_factor = 0.2*(1.0-length(worldPos.xyz)/FAR_CHUNKS_DISTANCE);
		wave_factor *= uv1.y;
    }
#endif
#ifdef UNDERWATER
	wave_factor = mix(0.05,.1,pos.z);
#endif
if(wave_factor > 0.0){
	gl_Position.xy += (sin(TOTAL_REAL_WORLD_TIME*3.+wapos.x+wapos.z+wapos.y)*hash(wapos.x+wapos.y+wapos.z))*.2*wave_factor;
}
#ifdef UNDERWATER
	float len = length(-worldPos.xyz) / RENDER_DISTANCE;
	#ifdef ALLOW_FADE
		len += RENDER_CHUNK_FOG_ALPHA;
	#endif
	fogr = clamp((len - FOG_CONTROL.x) / (FOG_CONTROL.y - FOG_CONTROL.x), 0.0, 1.0);
#endif
}
