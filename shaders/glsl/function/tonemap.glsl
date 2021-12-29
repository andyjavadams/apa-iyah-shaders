vec3 GBias(vec3 x) {
	//Second iteration, replace the first one for unsupported device.
	float A = 0.6;
	float B = 0.4;
	float C = 0.8;
	float D = 0.65;
	float E = 0.9;
	float F = 1.2;

	vec3 film = vec3(0.4, 0.3, 0.0);
	vec3 colorize = vec3(0.4, 0.3, 0.0);

	float newFilm = dot(film, film * x);
	vec3 newColor = colorize * newFilm;

	x = x * (x + newColor);
	x = clamp(x, 0.0, 1.0);
	x *= 3.0;

	return -((x * ((A + B) / (x + C)) + D) / (x * (A / B) + (A * E))) + F;
}