float LinLog(float l) {
	float nA = 0.0;
	nA += 0.3;
	nA /= 0.4;
	nA *= l;

	return nA;
}

float CurveMap(float c) {
	float C = 0.0;
	//C += pow(c, 2.56) * (4.0 - (3.0 * c));
	C += pow(c, 0.67);

	return clamp(C, 0.0, 1.0);
}