@tool class_name GrassBlades extends MultiMeshInstance3D

@export var area_extends := Vector2(5.0, 5.0)

func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	for i: int in multimesh.instance_count:
		var blade_transform := Transform3D().rotated(Vector3.UP, rng.randf_range(-PI / 2.0, PI / 2.0))
		var x: float = rng.randf_range(-area_extends.x, area_extends.x)
		var y: float = rng.randf_range(-area_extends.y, area_extends.y)
		blade_transform.origin = Vector3(x, 0.0, y)
		
		multimesh.set_instance_transform(i, blade_transform)
		multimesh.set_instance_custom_data(i, Color(rng.randf(), 0.0, rng.randf(), 0.0))
