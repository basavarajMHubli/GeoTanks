extends Control

var reload_delay := 0.0
var elapsed_delay := 0.0
var show_reload_request := false


@onready var obj_v_box_container = $CanvasLayer/ObjectiveVBoxContainer
@onready var canvas_layer = $CanvasLayer
@onready var shells_label = $CanvasLayer/ShellsLabel
@onready var air_shells_label: Label = $CanvasLayer/AirShellsLabel
@onready var airstrike_background: Sprite2D = $CanvasLayer/AirstrikeBackground
@onready var shell_reload_progress_bar: TextureProgressBar = $CanvasLayer/ShellReloadProgressBar


func _process(delta: float) -> void:
	if show_reload_request:
		elapsed_delay += delta
		shell_reload_progress_bar.value = (elapsed_delay / reload_delay) * 100
		if elapsed_delay >= reload_delay:
			reload_delay = 0.0
			elapsed_delay = 0.0
			show_reload_request = false
			shell_reload_progress_bar.value = 0.0


func display_obj(obj_text):
	var label = Label.new()
	label.text = obj_text
	obj_v_box_container.add_child(label)
	print("UIManager: Displayed obj " + obj_text)


func remove_obj(obj_text):
	print("UIManager: Removing obj " + obj_text)
	for child in obj_v_box_container.get_children():
		if child is Label:
			if child.text == obj_text:
				child.modulate = Color.GRAY


func clear_all_ojectives():
	print("UIManager: Clearing all objectives")
	for child in obj_v_box_container.get_children():
		obj_v_box_container.remove_child(child)
		child.queue_free()


func update_shells(shell_count: int):
	shells_label.text = str(shell_count)


func update_airstrike_count(call_count: int):
	air_shells_label.text = str(call_count)
	air_shells_label.modulate = Color.WHITE
	airstrike_background.modulate = Color.WHITE


func start_shell_reload(delay):
	show_reload_request = true
	reload_delay = delay


func ui_visibility(state: bool):
	canvas_layer.visible = state
