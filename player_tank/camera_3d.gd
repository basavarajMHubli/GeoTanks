extends Camera3D

var amplitude := 1.0
var initial_rotation : Vector3

func _ready() -> void:
	initial_rotation = rotation_degrees
	set_process(false)


func _process(_delta: float) -> void:
	var x = randf_range(-amplitude, amplitude)
	var y = randf_range(-amplitude, amplitude)
	var z = randf_range(-amplitude, amplitude)
	rotation_degrees = Vector3(x, y, z)


func _on_player_tank_camera_shake() -> void:
	print("camera shake")
	$shake_timer.start()
	set_process(true)


func _on_shake_timer_timeout() -> void:
	set_process(false)
	rotation_degrees = initial_rotation
