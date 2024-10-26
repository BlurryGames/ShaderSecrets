shader_type spatial;
render_mode depth_draw_opaque, cull_disabled, ambient_light_disabled, blend_add, shadows_disabled;

uniform sampler2D depth_texture: hint_depth_texture;

uniform vec4 color: source_color;
uniform float fresnel_power = 1.0f;
uniform float edge_intensity = 2.0f;
uniform float fill_amount: hint_range(0.0f, 1.0f, 0.01f) = 0.1f;

uniform float pulsing_strength = 0.25f;
uniform float pulsing_speed = 1.0f;

uniform float scanline_period = 0.5f;
uniform float scanline_width : hint_range(0.0f, 0.49f, 0.01f) = 0.1f;
uniform float scanline_intensity = 0.35f;

uniform float pattern_scroll_speed = 0.025f;
uniform vec2 pattern_uv_offset = vec2(6.0f, 3.0f);

uniform sampler2D pattern_texture: source_color;

void vertex()
{
	float pulse_distance = (sin(TIME * pulsing_speed) * 0.1) * pulsing_strength;
	
	VERTEX += NORMAL * pulse_distance;
}

void fragment()
{
	float fresnel = pow(1.0f - dot(NORMAL, VIEW), fresnel_power) * edge_intensity;
	fresnel += fill_amount;
	
	float depth = texture(depth_texture, SCREEN_UV).r * 2.0f - 1.0f;
	depth = PROJECTION_MATRIX[3][2] / (depth + PROJECTION_MATRIX[2][2]) + VERTEX.z;
	depth = pow(1.0f - clamp(depth, 0.0f, 1.0f), fresnel_power) * edge_intensity;
	
	fresnel += depth;
	
	float scrolling_time = TIME * pattern_scroll_speed;
	vec4 pattern = texture(pattern_texture, (UV * pattern_uv_offset) + vec2(scrolling_time));
	fresnel *= pattern.r;
	
	float uv_offset = mod(-TIME * scanline_period, 2.0f) - 1.0f;
	float scanline = smoothstep(0.5f - scanline_width, 0.5f, UV.y + uv_offset) * (1.0 - smoothstep(0.5f, 0.5f + scanline_width, UV.y + uv_offset)) * pattern.r;
	
	ALBEDO = vec3(0.0f);
	EMISSION = color.rgb;
	ALPHA = smoothstep(0.0f, 1.0f, fresnel + scanline * scanline_intensity);
}