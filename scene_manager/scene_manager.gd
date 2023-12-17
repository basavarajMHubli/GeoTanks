extends Node

var loading_screen = preload("res://scene_manager/loading_screen.tscn")
var scene_to_load

func load_scene(pkd_scene):
	# Set scene_to_load. This variable will be used by loading_screen for
	# background loading
	scene_to_load = pkd_scene
	get_tree().change_scene_to_packed(loading_screen)
