// __multiversion__
// This signals the loading code to prepend either #version 100 or #version 300 es as apropriate.

#include "fragmentVersionCentroid.h"

#if __VERSION__ >= 300
	#ifndef BYPASS_PIXEL_SHADER
		#if defined(TEXEL_AA) && defined(TEXEL_AA_FEATURE)
			_centroid in highp vec2 uv0;
			_centroid in highp vec2 uv1;
		#else
			_centroid in vec2 uv0;
			_centroid in vec2 uv1;
		#endif
	#endif
#else
	#ifndef BYPASS_PIXEL_SHADER
		varying vec2 uv0;
		varying vec2 uv1;
	#endif
#endif

varying vec4 color;
varying highp vec3 cpos;
varying highp vec3 wpos;
varying highp vec3 smpos;

#ifdef UNDERWATER
varying float fogr;
#endif

uniform highp float TOTAL_REAL_WORLD_TIME;
#include "uniformShaderConstants.h"
#include "uniformPerFrameConstants.h"
#include "util.h"

LAYOUT_BINDING(0) uniform sampler2D TEXTURE_0;
LAYOUT_BINDING(1) uniform sampler2D TEXTURE_1;
LAYOUT_BINDING(2) uniform sampler2D TEXTURE_2;

/////////////////////////////////////////////////////////////////
///////////////////////// STOP! /////////////////////////////////
/////////////////////////////////////////////////////////////////
// Made by Sad - @bamboo_sapling
// successfully changed on Dec 2020.
// all of these assets are under MIT license.
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

#include "lib/hash.glsl"
#include "lib/bsbe.glsl"
#include "lib/colorp.glsl"

vec3 fogg(vec3 c, float dusk){
	float far = length(wpos.xz)/RENDER_DISTANCE;
	float atmo = clamp(.3-abs(wpos.y)*.002,.15,1.)*.8;
	c = mix(c,sky(atmo),clamp(far*.5,0.,1.));
return c;
}

void main()
{
#ifdef BYPASS_PIXEL_SHADER
	gl_FragColor = vec4(0, 0, 0, 0);
	return;
#else

#if USE_TEXEL_AA
	vec4 diffuse = texture2D_AA(TEXTURE_0, uv0);
#else
	vec4 diffuse = texture2D(TEXTURE_0, uv0);
#endif

#ifdef SEASONS_FAR
	diffuse.a = 1.0;
#endif

#if USE_ALPHA_TEST
	#ifdef ALPHA_TO_COVERAGE
	#define ALPHA_THRESHOLD 0.05
	#else
	#define ALPHA_THRESHOLD 0.5
	#endif
	if(diffuse.a < ALPHA_THRESHOLD)
		discard;
#endif

vec4 inColor = color;

#if defined(BLEND)
	diffuse.a *= inColor.a;
#endif

#if !defined(ALWAYS_LIT)
	diffuse *= texture2D(TEXTURE_1,vec2(pow(uv1.x,2.),uv1.y));
#endif

#ifndef SEASONS
	#if !USE_ALPHA_TEST && !defined(BLEND)
		diffuse.a = inColor.a;
	#endif
if(color.g + color.g > color.b + color.r && color.a != 0.){
	diffuse.rgb *= mix(normalize(inColor.rgb),inColor.rgb,0.5);
}else{
	diffuse.rgb *= (color.a ==0.)?inColor.rgb: sqrt(inColor.rgb);
}
#else
	vec2 uv = inColor.xy;
	diffuse.rgb *= mix(vec3(1.0,1.0,1.0), texture2D( TEXTURE_2, uv).rgb*2.0, inColor.b);
	diffuse.rgb *= inColor.aaa;
	diffuse.a = 1.0;
#endif

	vec4 lm = texture2D(TEXTURE_1, vec2(0., 1.));
	vec3 n = normalize(cross(dFdx(cpos.xyz), dFdy(cpos.xyz)));
	float dusk = min(smoothstep(.3, .5, lm.r), smoothstep(1., .8, lm.r))*(1.-rain);
	float night = smoothstep(1., .2, lm.r);
		dusk *= uv1.y;
		night *= uv1.y;

	highp float smap = 0.;
#if !USE_ALPHA_TEST
	smap = dside(smap,1.,n.x);
#endif
		smap = mix(smap,1.,smoothstep(.87, .845, uv1.y));
		smap = mix(smap,0.,rain);
	float rim = smoothstep(1.,0.,dot(n,normalize(-wpos)));
	float dvalue = mix(mix(mix(mix(nlc,0.,uv1.y),llc,dusk),nlc+llc, night),nlc,rain);

	vec3 lsc = mix(vec3(1.,1.,1.), lcolor*dvalue, sl)*pow(uv1.x*ls,lp);
	bool waterd = (color.a < .95 && color.a > .05);
	
#if !defined(SEASONS) && !defined(ALPHA_TEST)
	if(waterd){
		diffuse = vec4(diffuse.rgb,.3);
		vec3 skyc = sky(pow(rim,6.)*.2);
		diffuse = mix(diffuse,vec4(skyc+lsc,1.),rim);
		diffuse.rgb *= max(uv1.x,uv1.y);
    } else {
		smap = mix(smap,1.1,smoothstep(.6,.3,color.g));
  	 }
#endif
		smap = mix(smap,0.,smoothstep(lm.r*smoothstep(.85,1.,uv1.y), 1., uv1.x));

	vec3 amb = mix(mix(mix(tdcolor,tscolor,dusk),tncolor,night), trcolor,rain*uv1.y);
	diffuse.rgb = cg(diffuse.rgb,gamma);
	diffuse.rgb *= mix(vec3(2.)+2.*max(n.z,0.)*dusk,shcolor-ss,smap);
	diffuse.rgb *= amb;
	diffuse.rgb = cg(diffuse.rgb,(1./gamma));
	diffuse.rgb = fogg(diffuse.rgb, dusk);
	diffuse.rgb += lsc;

#ifdef UNDERWATER
	if(!waterd){diffuse.rgb = uwcolor*diffuse.rgb;}
	diffuse.rgb += (1.-uv1.y)*pow(uv1.x*ls,lp)*sqrt(diffuse.rgb);
	diffuse.rgb = mix(diffuse.rgb, fc.rgb, pow(fogr,8.));
#else
	diffuse.rgb = mix(diffuse.rgb,sky(rim*.5),(pow(rim,2.)*(smap*ri+(rain*n.y)*.2))*uv1.y);
#endif

	diffuse.rgb = final(diffuse.rgb);

	gl_FragColor = diffuse;

#endif
}
