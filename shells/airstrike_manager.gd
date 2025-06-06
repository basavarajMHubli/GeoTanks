extends Node3D

var shell_scene := preload("res://shells/airstrike_shell.tscn")
var airstrike_spawn_height := 10
var is_reloading := false
var call_count = 0
var player_tank
@export var reload_time := 2.0

@onready var jet_audio: AudioStreamPlayer3D = $JetAudio
@onready var reload_timer: Timer = $ReloadTimer

func _ready() -> void:
	player_tank = get_tree().get_first_node_in_group("player")

func _on_airstrike_request() -> void:
	if call_count == 0 or is_reloading:
		print("Airstrike: skipped, call_count " + str(call_count) + " reloading " + str(is_reloading))
		return

	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemies")
	if enemies.size() == 0:
		print("Airstrike: skipped, no enemies")
		return

	is_reloading = true
	reload_timer.start(reload_time)

	jet_audio.play()

	for enemy in enemies:
		var shell := shell_scene.instantiate()
		shell.position = player_tank.global_position
		shell.position.y += airstrike_spawn_height
		shell.rotation = player_tank.global_rotation
		get_parent().add_child(shell)
		shell.look_at(enemy.global_position, Vector3.UP)

	call_count -= 1
	UIManager.update_airstrike_count(call_count)
	UIManager.start_airstrike_reload(reload_time)


func _on_reload_timer_timeout() -> void:
	is_reloading = false
	print("Airstrike reloading done")


func _on_player_tank_airstrike_ammo(ammo: Variant) -> void:
	call_count = ammo
	UIManager.update_airstrike_count(call_count)
