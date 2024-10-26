shader_type canvas_item;

const vec3 VIEW_DIRECTION = vec3(0.0, -0.707, 0.707);

uniform sampler2D screen_texture: hint_screen_texture;

uniform sampler2D transition_gradient: hint_default_black;
uniform sampler2D distortion_map: hint_default_black;

uniform mat3 transform = mat3(vec3(1.0f, 0.0f, 0.0f), vec3(0.0f ,1.0f ,0.0f), vec3(0.0f, 0.0f, 1.0f));

uniform vec4 shadow_color: source_color;
uniform vec4 water_tint: source_color;

uniform vec2 distortion_scale = vec2(0.5f);
uniform float distortion_time_scale: hint_range(0.01f, 0.15f) = 0.05f;
uniform float distortion_amplitude: hint_range(0.005f, 0.4f) = 0.1f;

uniform float water_time_scale: hint_range(0.01f, 2.0f, 0.01f) = 0.1f;
uniform float scale_y_factor: hint_range(0.1f, 4.0f, 0.01f) = 2.0f;
uniform float tile_factor: hint_range(0.1f, 3.0f, 0.01f) = 1.4f;

uniform float parallax_factor: hint_range(0.0f, 1.0f) = 0.2f;

uniform float reflection_intensity: hint_range(0.01f, 1.0f, 0.01f) = 0.5f;

uniform vec2 scale;
uniform float zoom_y;
uniform float aspect_ratio;

vec2 calculate_distortion(vec2 uv, float time)
{
	vec2 base_uv_offset = uv * distortion_scale + time * distortion_time_scale;
	
	return texture(distortion_map, base_uv_offset).rg * 2.0f - 1.0f;
}

void fragment()
{
	vec3 projection = vec3(UV, 1.0) * transform;
	vec2 uv = projection.xy / projection.z;
	
	vec2 distortion = calculate_distortion(uv, TIME) * distortion_amplitude;
	vec2 uv_waves = uv * scale * tile_factor;
	uv_waves.y *= aspect_ratio * scale_y_factor;
	uv_waves += distortion * distortion_amplitude + vec2(water_time_scale, 0.0f) * TIME;
	
	float height =  texture(distortion_map, uv_waves * 0.05 + TIME * 0.004).r;
	vec2 parallax_offset = VIEW_DIRECTION.xy / VIEW_DIRECTION.z * height * parallax_factor + 0.2;
	uv_waves -= parallax_offset;
	
	float uv_size_ratio_v = SCREEN_PIXEL_SIZE.y / TEXTURE_PIXEL_SIZE.y;
	vec2 uv_reflected = vec2(SCREEN_UV.x, SCREEN_UV.y + uv.y * uv_size_ratio_v * 2.0 * scale.y * zoom_y);
	uv_reflected += vec2(0.0f, uv_size_ratio_v) * distortion * distortion_amplitude;
	uv_reflected -= parallax_offset * vec2(0.0, uv_size_ratio_v);
	
	vec4 color_reflection = texture(screen_texture, uv_reflected);
	vec4 color_water = texture(TEXTURE, uv_waves) * water_tint;
	color_water.rgb = mix(color_water.rgb, color_water.rgb * shadow_color.rgb, parallax_factor - height);
	float transition = texture(transition_gradient, vec2(1.0f - UV.y, 1.0f)).r;
	
	COLOR = mix(color_water, color_reflection, transition * reflection_intensity);
}