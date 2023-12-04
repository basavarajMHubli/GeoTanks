extends Area3D

@export var shell_gain := 25

var player_interactor: Node3D = null

@onready var help_text = $HelpText
@onready var objective = $Objective

func _on_body_entered(body):
	if body.is_in_group("player"):
		help_text.visible = true		
		player_interactor = body


func _on_body_exited(body):
	if body.is_in_group("player"):
		help_text.visible = false
		player_interactor = null


func _input(event):
	if player_interactor and event.is_action_pressed("interact"):
		print("shellCrate: Interacting")
		player_interactor.shell_count_update(shell_gain)
		destroy_shell_crate()


func destroy_shell_crate():
	# TODO: Check if objective artifacts can be decoupled entirely
	if objective:
		objective.mark_complete()

	queue_free()
