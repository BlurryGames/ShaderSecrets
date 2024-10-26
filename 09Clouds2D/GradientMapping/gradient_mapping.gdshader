shader_type canvas_item;
render_mode unshaded;

uniform sampler2D gradient: hint_default_black;
uniform float mix_amount = 1.0f;

void fragment()
{
	vec4 input_color = texture(TEXTURE, UV);
	float greyscale_value = dot(input_color.rgb, vec3(0.299f, 0.587f, 0.114f));
	vec3 sampled_color = texture(gradient, vec2(greyscale_value, 0.0f)).rgb;
	
	COLOR.rgb = mix(input_color.rgb, sampled_color, mix_amount);
	COLOR.a = input_color.a;
}