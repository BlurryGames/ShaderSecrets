shader_type spatial;
render_mode depth_prepass_alpha, cull_disabled;

uniform sampler2D texture_albedo: source_color;
uniform sampler2D dissolve_texture: hint_default_white;

uniform vec3 color: source_color = vec3(1.0f);
uniform vec3 emission_color: source_color = vec3(1.0f);

uniform float emission_amount = 1.0f;
uniform float burn_size: hint_range(0.0f, 2.0f, 0.01f) = 1.0f;
uniform float dissolve_amount: hint_range(0.0f, 1.0f, 0.01f) = 0.0f;

void fragment()
{
	float sample = texture(dissolve_texture, UV).r;
	float emission_value = 1.0f - smoothstep(dissolve_amount, dissolve_amount + burn_size, sample);
	
	ALBEDO = color * texture(texture_albedo, UV).rgb;
	EMISSION = vec3(emission_value * emission_amount * emission_color);
	ALPHA = smoothstep(dissolve_amount - burn_size, dissolve_amount, sample);
}