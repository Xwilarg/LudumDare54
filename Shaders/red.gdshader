shader_type spatial;

uniform float alpha_blend: hint_range(0.0, 1.0, 0.1) = 0.3;

void fragment() {
	// Place fragment code here.
	ALBEDO = vec3(1.0, 0.0, 0.0) * alpha_blend + (1.0 - alpha_blend) * COLOR.rgb;
}