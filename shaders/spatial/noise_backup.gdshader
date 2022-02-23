// NOTE: Shader automatically converted from Godot Engine 3.4.2.stable's SpatialMaterial.

shader_type spatial;

const float PI = 3.14159;

uniform sampler2D noise;
uniform float speed = 1.0;
uniform float line_thickness = 0.1;
uniform vec2 squares = vec2(6.0, 5.0);
uniform vec3 color = vec3(1.0, 0.0, 0.0);
uniform float color_strength = 3.0;
uniform float alpha = 1.0;

float make_wave(float x, float amp, float freq)
{
	return sin(x * freq * PI) * amp;
}

void vertex()
{
	float t = TIME * speed;
	
	float n = texture(noise, VERTEX.xz + t).r;
	
	VERTEX.y += n;
}

float make_line(float x, float y, float thickness, float falloff)
{
	return smoothstep(x - thickness, x, y) - smoothstep(x, x + thickness, y);
}

void fragment()
{
	vec2 pos = UV * squares;
	vec2 fpos = fract(pos);
	
	// make lines
	float lines = 1.0 - step(line_thickness, fpos.x) * step(line_thickness, fpos.y);
	
	// cut edges
	lines *= step(line_thickness, pos.x) * step(line_thickness, pos.y);
	
	ALBEDO = color * lines * color_strength;
	ALPHA = lines * alpha;
}