shader_type canvas_item;

uniform float box_size : hint_range(0, 1) = 0.6;
uniform float box_radius : hint_range(0, 1) = 0.1;

float box_sdf(vec2 p, vec2 b, float r) {
	vec2 d = abs(p) - b;
	return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0) - r;
}

void fragment() {
	vec2 box_uv = (UV - 0.5) * 2.0;
	float sdf = max(0.0, box_sdf(box_uv, vec2(box_size), box_radius));
	sdf = smoothstep(0.0, box_size, sdf);

	COLOR.a *= sdf;
}
