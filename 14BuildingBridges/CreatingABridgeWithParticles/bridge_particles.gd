@tool class_name BridgeParticles extends GPUParticles3D

@onready var character_node: RigidBody3D = %RigidBody3D

func _process(_delta: float) -> void:
	process_material.set_shader_parameter("character_position", character_node.global_transform.origin)
