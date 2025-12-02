extends CharacterBody3D

@export var move_speed = 1
@export var fire_delay = 3.0
@export var max_health = 100
@export var cur_health = 0

var fire_timer = Timer.new()
var shell_scene = preload("res://shells/shell.tscn")
var fractured_model:PackedScene = preload("res://enemies/enemy_tank_fractured.tscn")

@onready var nav_agent = $NavigationAgent3D
@onready var health_bar = $StatsSubViewport/ProgressBar
@onready var shell_fire_audio: AudioStreamPlayer3D = $ShellFireAudio
@onready var recoil_animation_player: AnimationPlayer = $RecoilAnimationPlayer

func _ready():
	# Initialize timer for firing shell
	add_child(fire_timer)
	fire_timer.wait_time = fire_delay
	fire_timer.connect("timeout", _on_fire_timer_timeout)
	fire_timer.start()

	# Init health
	cur_health = max_health
	health_bar.value = cur_health


func _physics_process(_delta):
	if not nav_agent.is_target_reached():
		move_towards_player()


func move_towards_player():
	var curr_loc = global_transform.origin
	var next_loc = nav_agent.get_next_path_position()
	var next_dir = next_loc - curr_loc
	var new_velocity = next_dir.normalized() * move_speed

	next_loc.y = curr_loc.y # We don't want tank to look at ground
	if not curr_loc.is_equal_approx(next_loc):
		look_at(next_loc, Vector3.UP)

	nav_agent.set_velocity(new_velocity)


func update_target_location(target_loc):
	nav_agent.set_target_position(target_loc)


func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	velocity = velocity.move_toward(safe_velocity, 0.25)
	move_and_slide()


func _on_fire_timer_timeout():
	print("Enemy: firing")
	recoil_animation_player.play("recoil")

	var shell := shell_scene.instantiate()
	shell.set_enemy_type()
	shell.position = $turret/FirePoint.global_position
	shell.rotation = $turret/FirePoint.global_rotation
	shell_fire_audio.play()
	get_parent().add_child(shell)
	fire_timer.wait_time = randf_range(fire_delay, fire_delay + 3)


func shell_hit(damage_value, hit_point):
	printt("Enemy:", damage_value, hit_point)

	cur_health -= damage_value
	health_bar.value = cur_health
	if cur_health <= 0:
		destroy()


func destroy():
	var fractured_model_obj:Node3D = fractured_model.instantiate()
	get_parent().add_child(fractured_model_obj)
	fractured_model_obj.transform = self.transform
	
	printt("queue_free", self)
	self.queue_free()
