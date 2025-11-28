extends Node3D

var camera : Camera3D
var viewport_centre : Vector2
var reticle_offset := Vector2(60, 60)
var border_offset := Vector2(60, 60)
var max_reticle_position : Vector2

@onready var indicator: TextureRect = $Indicator


func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	viewport_centre = Vector2(get_viewport().size) / 2.0
	max_reticle_position = viewport_centre - border_offset


func _process(_delta: float) -> void:
	if not camera.is_position_in_frustum(global_position):
		indicator.show()

		var local_to_camera = camera.to_local(global_position)
		var reticle_position = Vector2(local_to_camera.x, -local_to_camera.y)
		if reticle_position.abs().aspect() > max_reticle_position.aspect():
			reticle_position *= max_reticle_position.x / abs(reticle_position.x)
		else:
			reticle_position *= max_reticle_position.y / abs(reticle_position.y)

		indicator.set_global_position(viewport_centre + reticle_position - reticle_offset)
	else:
		indicator.hide()
