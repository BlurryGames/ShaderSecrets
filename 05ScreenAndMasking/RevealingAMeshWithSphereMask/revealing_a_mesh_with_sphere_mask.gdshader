shader_type spatial;
render_mode cull_disabled, ambient_light_disabled;

uniform vec3 mask_center = vec3(0.0f);
uniform float mask_radius = 5.0f;
uniform vec4 object_color: source_color = vec4(1.0f);
uniform vec4 mask_color: source_color = vec4(1.0f);

uniform float mask_border_radius = 0.1f;
uniform float emission_energy = 3.0f;

uniform sampler2D ghost_noise;

float mix_overlay(float a, float b)
{
	return mix(
			a * b * 2.0f,
			1.0f - 2.0f * (1.0f - a) * (1.0f - b),
			step(0.5f, a));
}
void fragment()
{
	vec3 world_space_vert = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float view_space_distance = length(mask_center - world_space_vert);
	if (view_space_distance >= mask_radius)
	{
		discard;
	}

	world_space_vert.x += TIME;
	float noise_value = texture(ghost_noise, world_space_vert.xz).r;
	float border_value = smoothstep(
			0.0f,
			mask_border_radius,
			mask_border_radius + view_space_distance - mask_radius);
	float mask_value = step(0.7f, mix_overlay(border_value, noise_value));
	if (!FRONT_FACING)
	{
		mask_value = 1.0f;
	}

	ALBEDO = mix(object_color.rgb, mask_color.rgb, mask_value);
	EMISSION = emission_energy * mask_color.rgb * mask_value;
}