shader_type canvas_item;

uniform float darken = 1.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	color.rgb *= darken;
	COLOR.rgba = color.rrra;
}
