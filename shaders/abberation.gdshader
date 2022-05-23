shader_type canvas_item;

uniform float abberation_size = 0.5;
uniform float abberation_strength = 0.5;

void fragment() {
	COLOR = texture(TEXTURE, UV);
	
	vec2 red_shift = abberation_size * vec2(0.5, 0.0);
	float red = texture(TEXTURE, (UV + red_shift * TEXTURE_PIXEL_SIZE)).r;
	COLOR.r = mix(COLOR.r, red, abberation_strength);
}
