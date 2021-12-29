//Playing Grains
//Officially called the "Genghar's Cuatom Pseudo Random Noise".
//Yes, CUATOM. Called so from my misspelled "custom". Sounds deliberate eh?

float grain(vec2 UV, float seed) {
    UV = mod(UV, 147.0);
    float uv1 = fract(dot(UV, vec2(5412.051,241.053)));
    float uv2 = fract(dot(UV, vec2(182.051,2186.15)));

    vec2 hax = vec2(uv1, uv2) * fract(dot(UV,UV)) * 42610.0 * abs(seed);

    vec4 dis = vec4(hax.y, fract(seed) * 1.0-hax.x, fract(seed) * 1.0-hax.y, hax.x);
    vec4 haxr = vec4(hax, hax * fract(seed));
    float final = (distance(dis, haxr)+length(dis)+length(haxr))/3.0;

    return mod(final, 1.0);
}

float sineWave(float dimension, float amplitude, float frequency, float phase) {
	return amplitude * sin(frequency + (dimension + phase));
}