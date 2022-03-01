shader_type canvas_item;

uniform vec4 noise_color_1 : hint_color;
uniform vec4 noise_color_2 : hint_color;

float random(vec2 st)
{
	return fract(sin(dot(mod(st, 10.0), vec2(49.2834, 13.4573))) * 44821.6873);
}

void fragment()
{
	COLOR *= mix(noise_color_1, noise_color_2, random(UV + TIME)) * texture(TEXTURE, UV);
}