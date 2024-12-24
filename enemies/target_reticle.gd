extends Node3D

var camera : Camera3D
var viewport_centre : Vector2
var reticle_offset := Vector2(20, 20)
var border_offset := Vector2(20, 20)
var max_reticle_position : Vector2

@onready var offscreen_reticle: TextureRect = $OffscreenReticle


func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	viewport_centre = get_viewport().size / 2.0
	max_reticle_position = viewport_centre - border_offset
	print("Viewport size: " + str(get_viewport().size))
	print("Viewport centre: " + str(viewport_centre))
	print("Max reticle position: " + str(max_reticle_position))
	print("Global position: " + str(global_position))
	print("To local: " + str(camera.to_local(global_position)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not camera.is_position_in_frustum(global_position):
		offscreen_reticle.show()

		var local_to_camera = camera.to_local(global_position)
		var reticle_position = Vector2(local_to_camera.x, -local_to_camera.y)
		if reticle_position.abs().aspect() > max_reticle_position.abs().aspect():
			reticle_position *= max_reticle_position.x / abs(reticle_position.x)
		else:
			reticle_position *= max_reticle_position.y / abs(reticle_position.y)
		
		offscreen_reticle.set_global_position(viewport_centre + reticle_position - reticle_offset)
	else:
		offscreen_reticle.hide()
