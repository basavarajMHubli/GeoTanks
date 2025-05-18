extends Node3D

var SHELL_SPEED = 20
var SHELL_DAMAGE = 50

const KILL_TIMER = 1
var timer = 0
var hit_someting = false
var smoke_gpu_particles: GPUParticles3D
var shell_mesh: MeshInstance3D

signal camera_shake

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area3D.connect("body_entered", self.collided)
	smoke_gpu_particles = $SmokeGPUParticles
	shell_mesh = $ShellMesh

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
	# Hide and disable shell
	smoke_gpu_particles.visible = false
	shell_mesh.visible = false
	set_physics_process(false)

	# Show blast particles
	var blast_particles : GPUParticles3D = $BlastGPUParticles
	blast_particles.global_transform = global_transform
	blast_particles.visible = true
	blast_particles.emitting = true

	camera_shake.emit()
	await get_tree().create_timer(5.0).timeout
	queue_free()
