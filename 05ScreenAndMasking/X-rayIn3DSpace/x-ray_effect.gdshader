shader_type spatial;
render_mode ambient_light_disabled;

uniform float xray_color_intensity = 1.0f;
uniform float outline_sharpness = 2.0f;
uniform vec4 outline_color: source_color = vec4(1.0f);

void fragment()
{
	float fresnel_dot = 1.0f - dot(NORMAL, VIEW) * outline_sharpness;
	
	ALBEDO = vec3(0.0f);
	EMISSION = smoothstep(0.0f, 1.0f, fresnel_dot) * outline_color.rgb * xray_color_intensity;
}