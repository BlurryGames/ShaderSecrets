shader_type canvas_item;

uniform sampler2D dissolve_texture;

uniform vec3 burn_color: source_color = vec3(1.0f);

uniform float burn_size: hint_range(0.0f, 2.0f, 0.01f) = 1.0f;
uniform float dissolve_amount: hint_range(0.0f, 1.0f, 0.01f) = 0.0f;
uniform float emission_amount = 1.0f;

void fragment()
{
	vec4 out_color = texture(TEXTURE, UV);
	
	float sample = texture(dissolve_texture, UV).r;
	float emission_value = 1.0f - smoothstep(dissolve_amount, dissolve_amount + burn_size, sample);
	vec3 emission = burn_color * emission_value * emission_amount;
	
	COLOR = vec4(max(out_color.rgb, emission),
			smoothstep(dissolve_amount - burn_size, dissolve_amount, sample) * out_color.a);
}