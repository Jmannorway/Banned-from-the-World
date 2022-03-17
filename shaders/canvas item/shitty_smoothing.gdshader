shader_type canvas_item;

void fragment()
{
	COLOR =
		texture(TEXTURE, UV + vec2(-TEXTURE_PIXEL_SIZE.x, -TEXTURE_PIXEL_SIZE.y)) +
		texture(TEXTURE, UV + vec2(0., -TEXTURE_PIXEL_SIZE.y)) +
		texture(TEXTURE, UV + vec2(TEXTURE_PIXEL_SIZE.x, -TEXTURE_PIXEL_SIZE.y)) +
		texture(TEXTURE, UV + vec2(TEXTURE_PIXEL_SIZE.x, 0.)) +
		texture(TEXTURE, UV) +
		texture(TEXTURE, UV + vec2(-TEXTURE_PIXEL_SIZE.x, 0.)) +
		texture(TEXTURE, UV + vec2(-TEXTURE_PIXEL_SIZE.x, TEXTURE_PIXEL_SIZE.y)) +
		texture(TEXTURE, UV + vec2(0., TEXTURE_PIXEL_SIZE.y)) +
		texture(TEXTURE, UV + TEXTURE_PIXEL_SIZE);
	COLOR /= 9.0;
}