extends Area3D

var player_interactor: Node3D = null

@onready var help_text = $HelpText

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
		print("EnergyCore: Interacting")
		destroy_enery_core()


func destroy_enery_core():
	print("EnergyCore: Freeing")
	queue_free()
