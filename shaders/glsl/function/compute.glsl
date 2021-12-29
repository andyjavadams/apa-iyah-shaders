/*
Compute.glsl, by Nick Genghar.
Free, Open-Source, Modifiable, Redistributable, Creditable as well as Non-Creditable.

Feel free to credit me if you appreciate my hard work on these fancy functions...
*/

//Fractionals
	//Starts at 0
	float bpfractO1(float F) {
		return 2.0 * (F - round(F));
	}
	float bpfractO2(vec2 F) {
		return 2.0 * ((F.x * F.y) - round(F.x * F.y));
	}
	float bpfractO3(vec3 F) {
		return 2.0 * ((F.x * F.y * F.z) - round(F.x * F.y * F.z));
	}
	float bpfractO4(vec4 F) {
		return 2.0 * ((F.x * F.y * F.z * F.w) - round(F.x * F.y * F.z * F.w));
	}

	//Starts at -1
	float bpfractN1(float F) {
		return 2.0 * (F - floor(F)) - 1.0;
	}
	float bpfractN2(vec2 F) {
		return 2.0 * ((F.x * F.y) - floor(F.x * F.y)) - 1.0;
	}
	float bpfractN3(vec3 F) {
		return 2.0 * ((F.x * F.y * F.z) - floor(F.x * F.y * F.z)) - 1.0;
	}
	float bpfractN4(vec4 F) {
		return 2.0 * ((F.x * F.y * F.z * F.w) - floor(F.x * F.y * F.z * F.w)) - 1.0;
	}

	//Starts at +1
	float bpfractP1(float F) {
		return 2.0 * (F - ceil(F)) + 1.0;
	}
	float bpfractP2(vec2 F) {
		return 2.0 * ((F.x * F.y) - ceil(F.x * F.y)) + 1.0;
	}
	float bpfractP3(vec3 F) {
		return 2.0 * ((F.x * F.y * F.z) - ceil(F.x * F.y * F.z)) + 1.0;
	}
	float bpfractP4(vec4 F) {
		return 2.0 * ((F.x * F.y * F.z * F.w) - ceil(F.x * F.y * F.z * F.w)) + 1.0;
	}
//Fractionals

//Linearizers
	//Linearize N component to 1 component
	vec2 linearize2(vec2 x) {
		return vec2(x.x * x.y);
	}
	vec3 linearize3(vec3 x) {
		return vec3(x.x * x.y * x.z);
	}
	vec4 linearize4(vec4 x) {
		return vec4(x.x * x.y * x.z * x.w);
	}

	//Linearize 2 component to 1 component with N
	float linearize211(vec2 x, float f) {
		return x.x * f + x.y * f;
	}
	float linearize221(vec2 x, vec2 f) {
		return x.x * f.x + x.y * f.y;
	}
	float linearize231(vec2 x, vec3 f) {
		vec2 newF = vec2(f.x * f.z, f.y * f.z);
		return x.x * newF.x + x.y * newF.y;
	}
	float linearize241(vec2 x, vec4 f) {
		vec2 newF = vec2(f.x * f.z, f.y * f.w) * vec2(f.x * f.y, f.z * f.w);
		return x.x * newF.x + x.y * newF.y;
	}

	//Linearize 3 component to 1 component with N
	float linearize311(vec3 x, float f) {
		return x.x * f + x.y * f + x.z * f;
	}
	float linearize321(vec3 x, vec2 f) {
		vec3 newF = vec3(f.x, f.y, f.x * f.y);
		return x.x * newF.x + x.y * newF.y + x.z * newF.z;
	}
	float linearize331(vec3 x, vec3 f) {
		return x.x * f.x + x.y * f.y + x.z * f.z;
	}
	float linearize341(vec3 x, vec4 f) {
		vec4 newF = vec4(f.x * f.z, f.y * f.w, f.z * f.w, f.w * f.x);
		return x.x * newF.x * newF.w + x.y * newF.y * newF.w + x.z * newF.z * newF.w;
	}

	//Linearize 4 component to 1 component with N
	float linearize411(vec4 x, float f) {
		return x.x * f + x.y * f + x.z * f + x.w * f;
	}
	float linearize421(vec4 x, vec2 f) {
		vec4 newF = vec4(f.x, f.y, f.x, f.y) * vec4(f.x * f.y, f.x, f.y, f.x * f.y);
		return x.x * newF.x + x.y * newF.y + x.z * newF.z + x.w * newF.w;
	}
	float linearize431(vec4 x, vec3 f) {
		vec4 newF = vec4(f.x, f.y, f.z, f.x) * vec4(f.z, f.x, f.y, f.z);
		return x.x * newF.x + x.y * newF.y + x.z * newF.z + x.w * newF.w;
	}
	float linearize441(vec4 x, vec4 f) {
		return x.x * f.x + x.y * f.y + x.z * f.z + x.w * f.w;
	}
//Linearizers

//Polarizers
	//Polarize N component to N
	vec2 polarize2(vec2 P) {
		P /= 2.0;
		return vec2(P.x + P.y);
	}
	vec3 polarize3(vec3 P) {
		P /= 3.0;
		return vec3(P.x + P.y + P.z);
	}
	vec4 polarize4(vec4 P) {
		P /= 4.0;
		return vec4(P.x + P.y + P.z + P.w);
	}

	//Unipolarize N component to N
	float unipolar1(float U) {
		return 0.5 * U + 0.5;
	}
	vec2 unipolar2(vec2 U) {
		return vec2(0.5) * U + vec2(0.5);
	}
	vec3 unipolar3(vec3 U) {
		return vec3(0.5) * U + vec3(0.5);
	}
	vec4 unipolar4(vec4 U) {
		return vec4(0.5) * U + vec4(0.5);
	}

	//Bipolarize N component to N
	float bipolar1(float B) {
		return 2.0 * B - 1.0;
	}
	vec2 bipolar2(vec2 B) {
		return vec2(2.0) * B - vec2(1.0);
	}
	vec3 bipolar3(vec3 B) {
		return vec3(2.0) * B - vec3(1.0);
	}
	vec4 bipolar4(vec4 B) {
		return vec4(2.0) * B - vec4(1.0);
	}
//Polarizers

//Smoother Step
	float smootherstep1(float N) {
		return clamp(N * N * N * (N * (N * 6.0 - 15.0) + 10.0), 0.0, 1.0);
	}
	vec2 smootherstep2(vec2 N) {
		return clamp(N * N * N * (N * (N * vec2(6.0) - vec2(15.0)) + vec2(10.0)), 0.0, 1.0);
	}
	vec3 smootherstep3(vec3 N) {
		return clamp(N * N * N * (N * (N * vec3(6.0) - vec3(15.0)) + vec3(10.0)), 0.0, 1.0);
	}
	vec4 smootherstep4(vec4 N) {
		return clamp(N * N * N * (N * (N * vec4(6.0) - vec4(15.0)) + vec4(10.0)), 0.0, 1.0);
	}
//Smoother Step

//Rangers
	float range1(float oldValue, float oldMax, float oldMin, float newMax, float newMin) {
		float oldRange = oldMax - oldMin;
		float newRange = newMax - newMin;
		float newValue;

		if (oldRange == 0.0) {
			newValue = newMin;
		} else {
			newValue = (((oldValue - oldMin) * newRange) / oldRange) + newMin;
		}

		return newValue;
	}
	vec2 range2(vec2 oldValue, vec2 oldMax, vec2 oldMin, vec2 newMax, vec2 newMin) {
		vec2 oldRange = oldMax - oldMin;
		vec2 newRange = newMax - newMin;
		vec2 newValue;

		if (oldRange.x == 0.0 || oldRange.y == 0.0) {
			newValue = newMin;
		} else {
			newValue = (((oldValue - oldMin) * newRange) / oldRange) + newMin;
		}

		return newValue;
	}
	vec3 range3(vec3 oldValue, vec3 oldMax, vec3 oldMin, vec3 newMax, vec3 newMin) {
		vec3 oldRange = oldMax - oldMin;
		vec3 newRange = newMax - newMin;
		vec3 newValue;

		if (oldRange.x == 0.0 || oldRange.y == 0.0 || oldRange.z == 0.0) {
			newValue = newMin;
		} else {
			newValue = (((oldValue - oldMin) * newRange) / oldRange) + newMin;
		}

		return newValue;
	}
	vec4 range4(vec4 oldValue, vec4 oldMax, vec4 oldMin, vec4 newMax, vec4 newMin) {
		vec4 oldRange = oldMax - oldMin;
		vec4 newRange = newMax - newMin;
		vec4 newValue;

		if (oldRange.x == 0.0 || oldRange.y == 0.0 || oldRange.z == 0.0 || oldRange.w == 0.0) {
			newValue = newMin;
		} else {
			newValue = (((oldValue - oldMin) * newRange) / oldRange) + newMin;
		}

		return newValue;
	}
//Rangers