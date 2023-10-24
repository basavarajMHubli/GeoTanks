extends Node3D

var SHELL_SPEED = 20
var SHELL_DAMAGE = 15

const KILL_TIMER = 1
var timer = 0
var hit_someting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area3D.connect("body_entered", self.collided)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var forward_dir = Vector3.FORWARD
	translate(forward_dir * SHELL_SPEED * delta)

	timer += delta
	if timer >= KILL_TIMER:
		queue_free()


func collided(body):
	print("Collided with " + body.name)
	if hit_someting == false:
		if body.has_method("shell_hit"):
			body.shell_hit(SHELL_DAMAGE, global_transform)
			
	hit_someting = true
	queue_free()
