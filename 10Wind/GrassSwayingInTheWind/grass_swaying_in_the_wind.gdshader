shader_type spatial;
render_mode cull_disabled, unshaded;

uniform sampler2D color_ramp: hint_default_black;
uniform sampler2D wind_noise: hint_default_black;

uniform float wind_speed = 0.2f;
uniform float wind_strenght = 2.0f;
uniform float wind_randomness = 0.5f;

void vertex()
{
	vec2 uv = (INSTANCE_CUSTOM.xz * wind_randomness) + (TIME * wind_speed);
	vec2 bump_wind = (textureLod(wind_noise, uv, 0.0f).rg - 0.5f) * wind_strenght;
	
	VERTEX += vec3(bump_wind.x, 0.0f, bump_wind.y) * (1.0f - UV.y);
}

void fragment()
{
	ALBEDO = texture(color_ramp, vec2(1.0f - UV.y, 0.0f)).rgb;
}