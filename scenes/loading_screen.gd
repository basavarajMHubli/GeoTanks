extends CanvasLayer

var progress = []
var scene_name
var load_status = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	scene_name = "res://scenes/level_1.tscn"
	ResourceLoader.load_threaded_request(scene_name)
	

func _process(_delta):
	load_status = ResourceLoader.load_threaded_get_status(scene_name, progress)
	$CenterContainer/LoadStatus.text = str(floor(progress[0] * 100)) + "%"
	
	if load_status == ResourceLoader.THREAD_LOAD_LOADED:
		print("LoadingScreen: background loading done")
		var scene_loaded = ResourceLoader.load_threaded_get(scene_name)
		get_tree().change_scene_to_packed(scene_loaded)
