shader_type canvas_item;

uniform vec3 multiply_color: source_color = vec3(1.0f);

void fragment()
{
	vec4 texture_color = texture(TEXTURE, UV);
	
	COLOR.rgb = texture_color.rgb * multiply_color;
	COLOR.a = texture_color.a;
}