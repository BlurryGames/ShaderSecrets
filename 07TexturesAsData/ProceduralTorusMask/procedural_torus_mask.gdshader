shader_type canvas_item;

uniform vec2 center = vec2(0.5f);
uniform vec2 size = vec2(1.0f);

uniform float thickness: hint_range(0.001f, 1.0f, 0.01f) = 0.25f;
uniform float radius: hint_range(0.0f, 100.0f, 0.01f) = 1.0f;
uniform float hardness = 0.2f;

uniform bool invert = false;

void fragment()
{
	float torus_distance = length((UV - center) * size);
	float radius_distance = thickness /  2.0f;
	float inner_radius = radius - radius_distance;

	float circle_value = clamp(abs(torus_distance - inner_radius) / thickness, 0.0f, 1.0f);
	float circle_alpha = pow(circle_value, pow(hardness, 2.0f));

	float mask = abs(float(!invert) - circle_alpha);
	COLOR.rgb = vec3(mask);
}