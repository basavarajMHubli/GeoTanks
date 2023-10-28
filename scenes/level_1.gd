extends Node3D

@onready var player_tank = $PlayerTank


func _physics_process(delta):
	get_tree().call_group("enemies", "update_target_location",
						  player_tank.global_transform.origin)
