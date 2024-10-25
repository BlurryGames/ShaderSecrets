shader_type canvas_item;

const vec2 OFFSETS[8] =
{
	vec2(-1.0f, -1.0f), vec2(-1.0f, 0.0f), vec2(-1.0f, 1.0f), vec2(0.0f, -1.0f),
	vec2(0.0f, 1.0f), vec2(1.0f, -1.0f), vec2(1.0f, 0.0f), vec2(1.0f, 1.0f)
};

uniform vec4 line_color: source_color = vec4(1.0f);

uniform float line_thickness:  hint_range(0.0f, 10.0f, 0.01f) = 1.0f;

void fragment()
{
	vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;
	float outline = 0.0f;
	for (int i = 0; i < OFFSETS.length(); i++)
	{
		outline += texture(TEXTURE, UV + size * OFFSETS[i]).a;
	}
	
	outline = min(outline, 1.0f);
	vec4 color = texture(TEXTURE, UV);
	
	COLOR = mix(color, line_color, outline - color.a);
}