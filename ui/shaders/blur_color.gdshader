shader_type canvas_item;

uniform float blur : hint_range(0.0, 4.0) = 2.0;

void fragment() {
	vec4 background = textureLod(SCREEN_TEXTURE, SCREEN_UV, blur);

	COLOR = mix(background, COLOR, COLOR.a);
	COLOR.a = 1.0;
}
