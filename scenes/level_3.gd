extends Node3D

enum ObjectiveStatus {not_done = 0, done = 1}

var objectives := [
	{
		"id" = 0,
		"name" = "Wait for extraction!",
		"desc" = "Wait till Air Force extract you!",
		"status" = ObjectiveStatus.not_done
	}
]

var obj_remaining := objectives.size()
var is_extraction_timer_expired

@export var enemy: PackedScene = preload("res://enemies/enemy_tank.tscn")
@export var health_crate: PackedScene = preload("res://Collectibles/health_crate/health_crate.tscn")
@export var shell_crate: PackedScene = preload("res://Collectibles/shell_crate.tscn")
@onready var player_tank = $PlayerTank
@onready var extraction_timer_label: Label = $CanvasLayer/ExtractionTimerLabel
@onready var extraction_timer: Timer = $ExtractionTimer
@onready var enemy_spawn_path_location: PathFollow3D = $EnemySpawnPath/SpawnPathLocation
@onready var collectible_spawn_path_location: PathFollow3D = $CollectibleSpawnPath/SpawnPathLocation


func _ready():
	UIManager.ui_visibility(true)
	for obj in objectives:
		UIManager.display_obj(obj["name"])
	extraction_timer_label.text = str(extraction_timer.time_left)


func _process(_delta):
	get_tree().call_group("enemies", "update_target_location",
						  player_tank.global_transform.origin)
	extraction_timer_label.text = str(int(extraction_timer.time_left))


func _on_extraction_timer_timeout():
	print("Level-3: Extraction timer timeout")
	# TODO: Check below design be simplified/optimized
	for obj in objectives:
		if obj["status"] == ObjectiveStatus.not_done:
			match obj["id"]:
				0:
					UIManager.remove_obj(obj["name"])
					obj["status"] = ObjectiveStatus.done
					obj_remaining -= 1
					kill_all_enemies()
					get_tree().quit() # TODO: Play cut-scene and game over
				_:
					print("Level-3: No matching obj id")


func _on_enemy_spawn_timer_timeout():
	print("Level-3: Spawning enemy")
	enemy_spawn_path_location.progress_ratio = randf()

	var enemy_obj := enemy.instantiate()
	enemy_obj.transform = enemy_spawn_path_location.transform
	add_child(enemy_obj)


func kill_all_enemies():
	print("Level-3: Destroy all enemies")
	get_tree().call_group("enemies", "shell_hit", 1000, global_position)


func _on_collectible_spawn_timer_timeout() -> void:
	print("Level-3: Spawning collectible")
	collectible_spawn_path_location.progress_ratio = randf()

	if collectible_spawn_path_location.progress_ratio >= 0.5:
		print("Level-3: Spawning health crate")
		var health_crate_obj = health_crate.instantiate()
		add_child(health_crate_obj)
		health_crate_obj.transform = collectible_spawn_path_location.transform
		health_crate_obj.transform.origin.y += 1
	else:
		print("Level-3: Spawning shell crate")
		var shell_crate_obj = shell_crate.instantiate()
		add_child(shell_crate_obj)
		shell_crate_obj.transform = collectible_spawn_path_location.transform
		shell_crate_obj.transform.origin.y += 1
