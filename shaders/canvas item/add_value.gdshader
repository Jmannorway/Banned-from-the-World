shader_type canvas_item;

uniform float strength : hint_range(-1.0, 4.0) = 0.0;
uniform float base_factor : hint_range(0.0, 1.0) = 0.7;

void fragment()
{
	vec4 img = texture(TEXTURE, UV);
	COLOR = img + vec4(mix(img.rgb, vec3(1.0), 1.0 - base_factor) * strength, 0.0);
}
	