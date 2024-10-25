shader_type canvas_item;

void fragment()
{
	COLOR = texture(TEXTURE, UV) * vec4(1.5f, 1.5f, 1.5f, 1.0f);
}