shader_type canvas_item;

uniform vec4 light_color : hint_color = vec4(1., 1., 1., 1.);
uniform vec4 dark_color : hint_color = vec4(0., 0., 0., 1.);

vec2 random(vec2 uv){
    uv = vec2( dot(uv, vec2(127.1,311.7) ),
               dot(uv, vec2(269.5,183.3) ) );
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise(vec2 uv) {
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);

    vec2 blur = smoothstep(0.0, 1.0, uv_fract);

    return mix( mix( dot( random(uv_index + vec2(0.0,0.0) ), uv_fract - vec2(0.0,0.0) ),
                     dot( random(uv_index + vec2(1.0,0.0) ), uv_fract - vec2(1.0,0.0) ), blur.x),
                mix( dot( random(uv_index + vec2(0.0,1.0) ), uv_fract - vec2(0.0,1.0) ),
                     dot( random(uv_index + vec2(1.0,1.0) ), uv_fract - vec2(1.0,1.0) ), blur.x), blur.y) + 0.5;
}

uniform float noisiness : hint_range(0.0, 64.0) = 32.0;
uniform float noise_bounds : hint_range(0.0, 0.3) = 0.15;
uniform float hole_factor : hint_range(0.0, 1.0) = 0.5;
uniform float distortion_severity : hint_range(0.0, 1.0) = 1.0;

const float PI = 3.14159;

void fragment()
{
	vec4 image = texture(TEXTURE, UV);
	
	float itime = floor(TIME / PI / 2.0 + PI / 2.0);
	float itime2 = floor(TIME / PI / 2.0);
	float time = sin(TIME) * 0.5 + 0.5;
	
	vec2 uv = UV * 2.0 - 1.0;
	uv = uv * 1.0 - image.a * distortion_severity;
	uv = uv * 0.5 + 0.5;
	
	vec2 pos_1 = uv * noisiness + noisiness * itime;
	vec2 pos_2 = uv * noisiness + noisiness * itime2 + noisiness;
	
	float noise_1 = step(noise(pos_1) + 0.1, smoothstep(0.0, 1.0, time) * hole_factor);
	float noise_2 = step(noise(pos_2) + 0.1, smoothstep(0.0, 1.0, 1.0 - time) * hole_factor);
	
	float result = clamp(1.0 - noise_1 - noise_2, 0.0, 1.0);
	vec4 color = mix(dark_color, light_color, result);
	
//	float n = step(noise_1, sin(TIME) * 0.5 + 0.5);
	COLOR = texture(TEXTURE, UV) * color;
}