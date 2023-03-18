shader_type canvas_item;

uniform vec2 texture_offset;
uniform vec2 texture_size;
uniform vec2 sprite_size;
uniform vec2 repeat;

void fragment() {
	vec2 tiled_uv = mod(UV * repeat, vec2(1.0, 1.0));
	vec2 region_uv = (tiled_uv * texture_size) / sprite_size;
	COLOR = texture(TEXTURE, (texture_offset / sprite_size) + region_uv); //read from texture
}
