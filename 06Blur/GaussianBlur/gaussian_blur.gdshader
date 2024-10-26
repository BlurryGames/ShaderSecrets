shader_type canvas_item;

const float SAMPLES = 71.0f;

uniform vec2 blur_scale = vec2(1.0f, 0.0f);

float gaussian(float x)
{
	float x_squared = x * x;
	float width = 1.0f / sqrt(TAU * SAMPLES);
	
	return width * exp((x_squared / (2.0f * SAMPLES)) * -1.0f);
}

void fragment()
{
	vec2 scale = TEXTURE_PIXEL_SIZE * blur_scale;
	float total_weight = 0.0f;
	vec4 color = vec4(0.0f);
	for (int i = -int(SAMPLES / 2.0f); i < int(SAMPLES / 2.0f); i++)
	{
		float weight = gaussian(float(i));
		color += texture(TEXTURE, UV + scale * vec2(float(i))) * weight;
		total_weight += weight;
	}
	
	COLOR = color / total_weight;
}