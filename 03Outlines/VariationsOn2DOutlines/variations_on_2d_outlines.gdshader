shader_type canvas_item;

const vec2 OFFSETS[8] =
{
	vec2(-1.0f, -1.0f), vec2(-1.0f, 0.0f), vec2(-1.0f, 1.0f), vec2(0.0f, -1.0f),
	vec2(0.0f, 1.0f), vec2(1.0f, -1.0f), vec2(1.0f, 0.0f), vec2(1.0f, 1.0f)
};

uniform vec4 line_color: source_color = vec4(1.0f);

uniform float line_thickness: hint_range(0.0f, 10.0f, 0.01f) = 1.0f;

void fragment()
{
	vec4 color = texture(TEXTURE, UV);
	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness / 2.0f;
	float inline = 1.0f;
	float outline = 0.0f;
	for (int i = 0; i < OFFSETS.length(); i++)
	{
		float sample = texture(TEXTURE, UV + size * OFFSETS[i]).a;
		outline += sample;
		inline *= sample;
	}
	
	outline = min(1.0f, outline) - color.a;
	inline = (1.0f - inline) * color.a;
	vec4 outlined_result = mix(color, line_color, outline + inline);
	
	COLOR = mix(color, outlined_result, outlined_result.a);
}