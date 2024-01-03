extends CanvasLayer

var progress = []
var load_status = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	UIManager.ui_visibility(false)
	print("LoadingScreen: %s" % SceneManager.scene_to_load)
	ResourceLoader.load_threaded_request(SceneManager.scene_to_load)
	

func _process(_delta):
	load_status = ResourceLoader.load_threaded_get_status(SceneManager.scene_to_load, progress)
	$CenterContainer/LoadStatus.text = str(floor(progress[0] * 100)) + "%"
	
	if load_status == ResourceLoader.THREAD_LOAD_LOADED:
		print("LoadingScreen: background loading done")
		var scene_loaded = ResourceLoader.load_threaded_get(SceneManager.scene_to_load)
		get_tree().change_scene_to_packed(scene_loaded)

