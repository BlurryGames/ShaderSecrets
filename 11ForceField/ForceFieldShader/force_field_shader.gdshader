shader_type spatial;
render_mode depth_draw_opaque, cull_disabled, ambient_light_disabled, shadows_disabled, blend_add;

uniform sampler2D pattern_texture: source_color;

uniform vec4 color: source_color = vec4(1.0f);

uniform vec2 pattern_uv_offset = vec2(6.0f, 3.0f);

uniform float pattern_scroll_speed = 0.025f;
uniform float frensel_power: hint_range(0.0f, 100.0f, 0.01f) = 1.0f;
uniform float edge_intensity: hint_range(0.0f, 100.0f, 0.01f) = 2.0f;
uniform float fill_amount: hint_range(0.0f, 1.0f, 0.01f) = 0.1f;

void fragment()
{
	float scrolling_time = TIME * pattern_scroll_speed;
	vec4 patter = texture(pattern_texture, (UV * pattern_uv_offset) + vec2(scrolling_time));
	
	float frensel = pow(1.0f - dot(NORMAL, VIEW), frensel_power) * edge_intensity;
	frensel += fill_amount;
	frensel *= patter.r;
	
	ALBEDO = vec3(0.0f);
	EMISSION = color.rgb;
	ALPHA = smoothstep(0.0f, 1.0f, frensel);
}