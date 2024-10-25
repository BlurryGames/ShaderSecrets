shader_type canvas_item;

void fragment()
{
	COLOR.rgb = vec3(texture(TEXTURE, UV).a);
	COLOR.a = 1.0f;
}