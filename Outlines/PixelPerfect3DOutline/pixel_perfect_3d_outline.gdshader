shader_type spatial;
render_mode cull_front, unshaded;

uniform vec4 outline_color: source_color = vec4(1.0f);

uniform float outline_width: hint_range(0.0f, 50.0f, 0.01f) = 1.0f;

void vertex()
{
	vec4 clip_position = PROJECTION_MATRIX * (MODELVIEW_MATRIX * vec4(VERTEX, 1.0f));
	vec3 clip_normal = mat3(PROJECTION_MATRIX) * (mat3(MODELVIEW_MATRIX) * NORMAL);
	vec2 offset = normalize(clip_normal.xy) / VIEWPORT_SIZE * clip_position.w * outline_width * 2.0f;
	clip_position.xy += offset;
	
	POSITION = clip_position;
}

void fragment()
{
	ALBEDO = outline_color.rgb;
	if (outline_color.a < 1.0f)
	{
		ALPHA = outline_color.a;
	}
}