extends CharacterBody3D

@export var move_speed = 16
@export var turn_speed = 2
@export var fall_acceleration = 25

var target_velocity = Vector3.ZERO

func _physics_process(delta):
	var direction = Vector3.ZERO
	
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
