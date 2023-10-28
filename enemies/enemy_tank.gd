extends CharacterBody3D

@onready var nav_agent = $NavigationAgent3D

@export var move_speed = 1


func _physics_process(delta):
	# FIXME: target_desired_distance is not working in v4.1
	if not nav_agent.is_target_reached():
		move_towards_player()


func move_towards_player():
	var curr_loc = global_transform.origin
	var next_loc = nav_agent.get_next_path_position()
	var next_dir = next_loc - curr_loc
	var new_velocity = next_dir.normalized() * move_speed
	
	look_at(next_loc, Vector3.UP)
	nav_agent.set_velocity(new_velocity)


func update_target_location(target_loc):
	nav_agent.set_target_position(target_loc)


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()
