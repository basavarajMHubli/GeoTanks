extends CharacterBody3D

@export var move_speed := 16
@export var turn_speed := 2
@export var fall_acceleration := 25
@export var max_health = 100
@export var cur_health = 0
@export var shell_count = 0
@export var reload_time := 1.0

var target_velocity := Vector3.ZERO
var is_reloading := false
var shell_scene := preload("res://shells/shell.tscn")
const RAY_LENGTH := 2000
signal airstrike_requested
signal airstrike_ammo(ammo)

@onready var health_bar = $StatsSubViewport/HealthBar
@onready var reload_timer: Timer = $ReloadTimer
@onready var shell_fire_audio: AudioStreamPlayer3D = $ShellFireAudio
@onready var empty_fire_audio: AudioStreamPlayer3D = $EmptyFireAudio

func _ready():
	# Init health
	cur_health = max_health
	health_bar.value = cur_health
	UIManager.update_shells(shell_count)


func _physics_process(delta: float):
	var direction := Vector3.ZERO

	rotate_turret()

	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_backward"):
		direction.z += 1
	if Input.is_action_pressed("turn_left"):
		rotate_y(turn_speed * delta)
	if Input.is_action_pressed("turn_right"):
		rotate_y(-turn_speed * delta)

	if direction != Vector3.ZERO:
		direction = direction.normalized()

	target_velocity.z = direction.z * move_speed

	if not is_on_floor():
		target_velocity.y -= (fall_acceleration * delta)

	velocity = target_velocity.rotated(Vector3.UP, rotation.y) * move_speed * delta
	move_and_slide()


func _process(_delta: float):
	if Input.is_action_just_pressed("fire"):
		fire_shell()

	if Input.is_action_just_pressed("airstrike"):
		call_airstrike()


func fire_shell():
	if shell_count == 0:
		empty_fire_audio.play()
	elif not is_reloading:
		is_reloading = true
		shell_count -= 1
		var shell := shell_scene.instantiate()
		shell.set_player_type()
		shell.position = $turret/FirePoint.global_position
		shell.rotation = $turret/FirePoint.global_rotation
		get_parent().add_child(shell)
		shell_fire_audio.play()
		UIManager.update_shells(shell_count)
		shell.connect("camera_shake", $SpringArm3D/Camera3D._on_player_tank_camera_shake)
		reload_timer.start(reload_time)
		UIManager.start_shell_reload(reload_time)

	print("Player: shell count " + str(shell_count))


func enable_airstrike(call_count):
	print("Player: Enabling airstrike, count " + str(call_count))
	emit_signal("airstrike_ammo", call_count)


func call_airstrike():
	emit_signal("airstrike_requested")


func rotate_turret():
	var space_state := get_world_3d().direct_space_state
	var mouse_pos := get_viewport().get_mouse_position()

	var ray_origin = $SpringArm3D/Camera3D.project_ray_origin(mouse_pos)
	var ray_end = ray_origin + $SpringArm3D/Camera3D.project_ray_normal(mouse_pos) * RAY_LENGTH

	var query := PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	query.collide_with_areas = true
	query.exclude = [self]

	var result := space_state.intersect_ray(query)
	if not result.is_empty():
		var look_pos = result.position
		look_pos.y = $turret.global_position.y
		$turret.look_at(look_pos)


func shell_hit(damage_value, _hit_point):
	print("Player: took damage " + str(damage_value))
	cur_health -= damage_value
	health_bar.value = cur_health

	if cur_health <= 0:
		player_die()


func player_die():
	print("Player: died")
	set_process(false)
	set_physics_process(false)


# This method is called in health crate collectible class
# @param gain: number of health points gained
func health_update(gain):
	cur_health += gain
	if cur_health > 100:
		cur_health = 100

	health_bar.value = cur_health
	print("Player: Health update to " + str(cur_health))


# This method is called in shell crate collectible class
# @param gain: number of shells gained
func shell_count_update(gain):
	shell_count += gain
	UIManager.update_shells(shell_count)
	print("Player: shell count updated to " + str(shell_count))


func _on_reload_timer_timeout() -> void:
	is_reloading = false
	print("Shell reloading done")
