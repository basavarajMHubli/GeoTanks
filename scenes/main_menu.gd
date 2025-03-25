extends Node3D

var intro_story = "res://scenes/intro_story/intro_story.tscn"


func _on_button_pressed():
	print("MainMenu: Play button pressed")
	SceneManager.load_scene(intro_story)


func _on_quit_button_pressed():
	print("MainMenu: Quit button pressed")
	get_tree().quit()
