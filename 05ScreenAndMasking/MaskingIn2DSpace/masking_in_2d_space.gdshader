shader_type canvas_item;

uniform sampler2D alternative_viewport;
uniform sampler2D mask_viewport;

uniform float dimness: hint_range(0.0f, 1.0f, 0.01f) = 0.2f;

void fragment()
{
	vec4 main_color = texture(TEXTURE, UV);
	vec4 alternative_color = texture(alternative_viewport, UV);
	float mask_color = texture(mask_viewport, UV).r;
	float brightness = 1.0f - dimness;
	
	main_color.rgb *= max(brightness, mask_color);
	COLOR = mix(main_color, alternative_color, alternative_color.a * mask_color);
}