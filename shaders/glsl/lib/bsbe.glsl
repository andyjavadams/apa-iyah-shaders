/////////////////////////////////////////////////////////////////
///////////////////////// STOP! /////////////////////////////////
/////////////////////////////////////////////////////////////////
// Made by Sad - @SIN_Dev
// successfully changed on Dec 2020.
// all of these assets are under MIT license.
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
//////////////////// global variable ////////////////////
////////////////////////////////////////////////////////////////
// this is not a setting to change
// I made it like this because it makes adjustments easier
// all values ​​here have been adjusted and not to be changed / customized !!

const vec3 dscolor = vec3(0.,.3,.8);
const vec3 nscolor = vec3(0.,.04,.1);
const vec3 sscolor = vec3(.5,.4,.6);
const vec3 lcolor = vec3(1.,.4,0.);
const vec3 scolor = vec3(1.,.6,0.);
const vec3 mcolor = vec3(.6,.8,1.);
const vec3 tdcolor = vec3(1.,.9,.9);
const vec3 tscolor = vec3(1.,.5,.3);
const vec3 tncolor = vec3(1.,1.3,1.4);
const vec3 trcolor = vec3(0.,0.,0.);
const vec3 shcolor = vec3(.5,.75,1.1);
const vec3 uwcolor = vec3(.3,.5,.8);

const float sl = 1.;
const float lp = 5.;
const float ls = 1.1;
const float nlc = .5;
const float llc = .2;
const float ss = .1;
const float ri = .15;
const float gamma = 2.2;
const float sat = 1.1;

#define fc FOG_COLOR
#define rain (1.-pow(FOG_CONTROL.y,5.))
#define nfog pow(clamp(1. - FOG_COLOR.r*1.5, 0., 1.), 1.2)
#define dfog clamp((FOG_COLOR.r-.15)*1.25,0.,1.)*(1.-FOG_COLOR.b)
#define dside(x,y,z) mix(x, y, clamp(abs(z), 0., 1.))

vec3 sky(float lenpos){
	vec3 skyc = mix(mix(mix(dscolor+.1, nscolor,nfog),sscolor,dfog),fc.rgb*2.,rain);
	vec3 scc = mix(mix(mix(vec3(1.,.98,.97),vec3(1.,.4,.5),dfog),skyc+.3,nfog),fc.rgb*2.,rain);
		skyc = mix(skyc,scc,clamp(lenpos*3.3,0.,1.));
    if(FOG_CONTROL.x==0.)skyc=fc.rgb;
return skyc;
}
