extends CharacterBody3D

@export var move_speed := 16
@export var turn_speed := 2
@export var fall_acceleration := 25

var target_velocity := Vector3.ZERO
var shell_scene := preload("res://shells/shell.tscn")

const RAY_LENGTH := 2000

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


func _process(delta: float):
	if Input.is_action_just_pressed("fire"):
		fire_shell()


func fire_shell():
	var shell := shell_scene.instantiate()
	shell.position = $turret/FirePoint.global_position
	shell.rotation = $turret/FirePoint.global_rotation
	owner.add_child(shell)


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
#		print(result)
		var look_pos = result.position
		look_pos.y = $turret.global_position.y
		$turret.look_at(look_pos)
