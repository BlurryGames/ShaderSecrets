shader_type canvas_item;

uniform sampler2D screen_texture: hint_screen_texture;

uniform vec4 color: source_color;
uniform float reflection_intensity = 0.5f;
uniform sampler2D transition_gradient: hint_default_black;

uniform float scale_y = 1.0f;
uniform float zoom_y = 1.0f;

void fragment()
{
	float uv_size_ratio_v = SCREEN_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.y;
	vec2 uv_reflected = vec2(SCREEN_UV.x, SCREEN_UV.y + uv_size_ratio_v * UV.y * 2.0f * scale_y * zoom_y);
	
	vec4 reflection_color = texture(screen_texture, uv_reflected);
	float transition = texture(transition_gradient, vec2(1.0f - UV.x)).r;
	
	COLOR = mix(color, reflection_color, transition * reflection_intensity);
}