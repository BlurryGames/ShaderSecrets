shader_type canvas_item;
render_mode blend_mul;

uniform vec4 tint: source_color = vec4(0.0f);
uniform sampler2D noise_texture2: hint_default_black;
uniform sampler2D gradient_texture: hint_default_black;

uniform vec2 scroll_direction1 = vec2(0.7f, -0.7f);
uniform float time_scale1: hint_range(0.001f, 0.25f) = 0.012f;
uniform float tile_factor1: hint_range(0.1f, 3.0f) = 0.6f;

uniform vec2 scroll_direction2 = vec2(0.75f, 0.25f);
uniform float time_scale2: hint_range(0.001f, 0.25f) = 0.005f;
uniform float tile_factor2: hint_range(0.1f, 3.0f) = 0.3f;

void fragment()
{
	vec2 noise2_uv = UV * tile_factor2 + scroll_direction2 * TIME * time_scale2;
	float noise2 = texture(noise_texture2, noise2_uv).r;

	vec2 noise1_uv = UV * tile_factor1 + scroll_direction1 * TIME * time_scale1;
	float noise1 = texture(TEXTURE, noise1_uv + noise2 * 0.02f).r;

	float clouds = texture(gradient_texture, vec2(noise1, 0.0f)).r;
	COLOR.rgb = mix(vec3(1.0f), tint.rgb, clouds * tint.a);
}