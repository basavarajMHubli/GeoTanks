extends ColorRect

var pause_state := false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		print("PauseMenu: Esc pressed")
		UIManager.ui_visibility(pause_state)
		pause_state = !pause_state
		visible = pause_state
		get_tree().paused = pause_state


func _on_resume_button_pressed():
	print("PauseMenu: Resume button pressed")
	visible = false
	get_tree().paused = false
	pause_state = false
	UIManager.ui_visibility(true)


func _on_quit_button_pressed():
	print("PauseMenu: Quit button pressed")
	visible = false
	pause_state = false
	get_tree().quit()
