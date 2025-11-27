extends Node3D

const INTENSITY:float = 8.0

func _ready() -> void:
	for pieces:RigidBody3D in self.get_children():
		pieces.apply_impulse(pieces.get_child(0).position * INTENSITY, 
							 self.global_position)

	await get_tree().create_timer(3).timeout
	queue_free()
