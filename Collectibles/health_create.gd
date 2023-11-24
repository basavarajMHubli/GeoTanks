extends Area3D

@export var health_gain := 25

@onready var help_text = $HelpText


func _on_body_entered(body):
	if body.is_in_group("player"):
		help_text.visible = true		
		body.set_interactive(true)


func _on_body_exited(body):
	if body.is_in_group("player"):
		help_text.visible = false
		body.set_interactive(false)


func get_health_gain():
	return health_gain
