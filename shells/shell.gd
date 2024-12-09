extends Node3D

var SHELL_SPEED = 20
var SHELL_DAMAGE = 50

const KILL_TIMER = 1
var timer = 0
var hit_someting = false

signal camera_shake

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area3D.connect("body_entered", self.collided)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var forward_dir = Vector3.FORWARD
	translate(forward_dir * SHELL_SPEED * delta)

	timer += delta
	if timer >= KILL_TIMER:
		destroy()


func collided(body):
	print("Shell: collided with " + body.name)
	if hit_someting == false:
		if body.has_method("shell_hit"):
			body.shell_hit(SHELL_DAMAGE, global_transform)
			
	hit_someting = true
	destroy()


func destroy():
	camera_shake.emit()
	queue_free()
