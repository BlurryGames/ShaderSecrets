shader_type spatial;
render_mode unshaded, cull_front;

uniform vec4 outline_color: source_color = vec4(1.0f);

uniform float thickness: hint_range(0.0f, 1.0f, 0.01f) = 0.1f;

void vertex()
{
	VERTEX *= 1.0f + thickness;
}

void fragment()
{
	ALBEDO = outline_color.rgb;
	ALPHA = outline_color.a;
}