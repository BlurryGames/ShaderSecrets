shader_type spatial;

uniform sampler2D offset_texture: hint_default_black;

uniform vec2 offset_scale = vec2(-0.2f, -0.1f);
uniform vec2 time_scale = vec2(0.3f, 0.0f);

uniform float face_distortion = 0.5f;

void vertex()
{
	vec2 base_uv_offset = UV * offset_scale;
	base_uv_offset += TIME * time_scale;
	
	float noise = texture(offset_texture, base_uv_offset).r;
	float texture_based_offset = noise * 2.0f - 1.0f;
	texture_based_offset *= UV.x;
	
	VERTEX.y += texture_based_offset;
	VERTEX.z += texture_based_offset * face_distortion;
	VERTEX.x += texture_based_offset * -face_distortion;
}