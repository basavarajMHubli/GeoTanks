extends Node3D

var SHELL_SPEED = 30
var SHELL_DAMAGE = 50
var shell_mesh: MeshInstance3D
var smoke_gpu_particles: GPUParticles3D
var explosion: AudioStreamPlayer3D

signal camera_shake

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area3D.connect("body_entered", self.collided)
	shell_mesh = $ShellMesh
	smoke_gpu_particles = $SmokeGPUParticles
	explosion = $ExplosionAudio

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var forward_dir = Vector3.FORWARD
	translate(forward_dir * SHELL_SPEED * delta)


func collided(body):
	print("Shell: collided with " + body.name)
	if body.has_method("shell_hit"):
		body.shell_hit(SHELL_DAMAGE, global_transform)

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

	# Play explosion sound
	explosion.play()

	camera_shake.emit()
	await get_tree().create_timer(1.0).timeout
	queue_free()
