extends Node3D

func _on_button_pressed():
	print("MainMenu: Play button pressed")
	var loading_screen = load("res://scenes/loading_screen.tscn")
	get_tree().change_scene_to_packed(loading_screen)


func _on_quit_button_pressed():
	print("MainMenu: Quit button pressed")
	get_tree().quit()
