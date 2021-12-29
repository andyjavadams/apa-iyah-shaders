vec3 lightSource(vec3 C, float I) {
	return C * min(max(dot(I - 0.2, 0.5), 0.1), max(dot(I, 0.6), 0.0) * 0.4);
}

vec3 recolor(vec3 R, float M) {
	vec3 newR = R;

	newR.y *= ((2.0 + M) / 4.0);
	newR.y = 0.45 - newR.y;

	newR.z *= max(M - 0.7, 0.0);
	newR.z = 0.06 - newR.z;

	return clamp(newR, 0.0, 1.0);
}