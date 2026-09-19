shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec2 uv = UV;
	vec2 center = uv - vec2(0.5);
	float dist = length(center);

	float vignette = smoothstep(0.8, 0.2, dist);
	vignette = mix(1.0, vignette, progress);

	vec3 tint = mix(vec3(1.0), vec3(0.4, 0.6, 1.0), progress * 0.6);

	COLOR = vec4(tint * vignette, progress * 0.5);
}