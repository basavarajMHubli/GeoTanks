extends Node3D

enum ObjectiveStatus {not_done = 0, done = 1}

var objectives := [
	{
		"id" = 0,
		"name" = "Collect health crate!",
		"desc" = "Heal yourself for the battle",
		"status" = ObjectiveStatus.not_done
	},
	{
		"id" = 1,
		"name" = "Collect shell crate!",
		"desc" = "Arm yourself for the battle",
		"status" = ObjectiveStatus.not_done
	},
	{
		"id" = 2,
		"name" = "Kill them all!",
		"desc" = "Kill all the enemies",
		"status" = ObjectiveStatus.not_done
	}
]

var obj_remaining := objectives.size()
var level2_path = "res://scenes/level_2.tscn"
var shell_scene := preload("res://shells/airstrike_shell.tscn")
var airstrike_spawn_height := 10
var enemies : Array[Node]

@onready var player_tank = $PlayerTank
@onready var shell_crate = $NavigationRegion3D/ShellCrate
@onready var health_crate = $NavigationRegion3D/HealthCrate
@onready var objective_check_timer = $ObjectiveCheckTimer
# TODO: Find better way for jet audio
@onready var jet_audio: AudioStreamPlayer3D = $JetAudio

func _ready():
	UIManager.ui_visibility(true)
	for obj in objectives:
		UIManager.display_obj(obj["name"])
	SceneFade.fade_out()


func _process(_delta):
	get_tree().call_group("enemies", "update_target_location",
						  player_tank.global_transform.origin)
	enemies = get_tree().get_nodes_in_group("enemies")


func _on_objective_check_timer_timeout():
	if not obj_remaining:
		print("Level-1 No objectives remaining")
		objective_check_timer.stop()
		UIManager.clear_all_ojectives()
		SceneManager.load_scene(level2_path)
		return

	# TODO: Check below design be simplified/optimized
	for obj in objectives:
		if obj["status"] == ObjectiveStatus.not_done:
			match obj["id"]:
				0:
					if health_crate == null:
						UIManager.remove_obj(obj["name"])
						obj["status"] = ObjectiveStatus.done
						obj_remaining -= 1
				1:
					if shell_crate == null:
						UIManager.remove_obj(obj["name"])
						obj["status"] = ObjectiveStatus.done
						obj_remaining -= 1
				2:
					var current_enemies: Array = get_tree().get_nodes_in_group("enemies")
					if current_enemies.size() == 0:
						UIManager.remove_obj(obj["name"])
						obj["status"] = ObjectiveStatus.done
						obj_remaining -= 1
				_:
					print("Level-1: No matching obj id")


func _on_player_tank_airstrike() -> void:
	jet_audio.play()
	for enemy in enemies:
		var shell := shell_scene.instantiate()
		shell.position = player_tank.global_position
		shell.position.y += airstrike_spawn_height
		shell.rotation = player_tank.global_rotation
		get_parent().add_child(shell)
		shell.look_at(enemy.global_position, Vector3.UP)
