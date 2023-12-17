extends Node3D

var level1_path = "res://scenes/level_1.tscn"

func _on_button_pressed():
	print("MainMenu: Play button pressed")
	SceneManager.load_scene(level1_path)


func _on_quit_button_pressed():
	print("MainMenu: Quit button pressed")
	get_tree().quit()
