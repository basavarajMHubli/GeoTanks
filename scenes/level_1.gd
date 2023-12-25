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

@onready var player_tank = $PlayerTank
@onready var shell_crate = $NavigationRegion3D/ShellCrate
@onready var health_crate = $NavigationRegion3D/HealthCrate
@onready var objective_check_timer = $ObjectiveCheckTimer

func _ready():
	UIManager.ui_visibility(true)
	for obj in objectives:
		UIManager.display_obj(obj["name"])


func _process(_delta):
	get_tree().call_group("enemies", "update_target_location",
						  player_tank.global_transform.origin)


func _on_objective_check_timer_timeout():
	if not obj_remaining:
		objective_check_timer.stop()
		print("Level-1 No objectives remaining")
		# TODO: Load next level
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
					var enemies: Array = get_tree().get_nodes_in_group("enemies")
					if enemies.size() == 0:
						UIManager.remove_obj(obj["name"])
						obj["status"] = ObjectiveStatus.done
						obj_remaining -= 1
				_:
					print("Level-1: No matching obj id")
