shader_type canvas_item;

const vec2 frames[] = {
	vec2(0.0, 0.0),
	vec2(0.25, 0.0),
	vec2(0.5, 0.0)
};

uniform int frame = 0;
uniform float light = 0.8;

void fragment() {
	vec4 color = texture(TEXTURE, UV + frames[frame]);
	COLOR.rgba = color.rrra * vec4(vec3(light), 1.0);
}
