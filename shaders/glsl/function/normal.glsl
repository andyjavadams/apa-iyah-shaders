vec3 ComputeDetailNormal(sampler2D tex, vec2 uv, float depth, float strength)
{
    const vec4 avgRGB0 = vec4(1.0/3.0, 1.0/3.0, 1.0/3.0, 0.0);
    vec2 du = vec2(1.0/depth, 0.0);
    vec2 dv = vec2(0.0, 1.0/depth);

    float h0  = dot(avgRGB0, texture2D(tex, uv)) * strength;
    float hpx = dot(avgRGB0, texture2D(tex, uv + du)) * strength;
    float hmx = dot(avgRGB0, texture2D(tex, uv - du)) * strength;
    float hpy = dot(avgRGB0, texture2D(tex, uv + dv)) * strength;
    float hmy = dot(avgRGB0, texture2D(tex, uv - dv)) * strength;
    
    float dHdU = (hmx - hpx) / (2.0 * du.x);
    float dHdV = (hmy - hpy) / (2.0 * dv.y);
    
    return normalize(vec3(dHdU, dHdV, 1.0)) * 0.5 + 0.5;
}