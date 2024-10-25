shader_type canvas_item;

uniform float progress: hint_range(0.0f, 1.0f, 0.01f) = 0.5f;

void fragment()
{
	vec4 texture_color = texture(TEXTURE, UV);
	float wipe = (UV.x - UV.y + 1.0f) / 2.0f;
	float wipe_area = step(progress, wipe + 0.1f) - step(progress, wipe);
	
	COLOR = mix(texture_color, vec4(1.0f, 1.0f, 1.0f, texture_color.a), wipe_area);
}