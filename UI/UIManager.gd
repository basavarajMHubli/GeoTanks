extends Control

var shell_reload_delay := 0.0
var airstrike_reload_delay := 0
var elapsed_delay_for_shell := 0.0
var elapsed_delay_for_airstrike := 0.0
var show_reload_request := false
var show_airstrike_reload_request := false
var base_theme = preload("res://UI/base_theme.tres")

@onready var obj_v_box_container = $CanvasLayer/ObjectiveVBoxContainer
@onready var canvas_layer = $CanvasLayer
@onready var shells_label = $CanvasLayer/ShellsLabel
@onready var air_shells_label: Label = $CanvasLayer/AirShellsLabel
@onready var airstrike_background: Sprite2D = $CanvasLayer/AirstrikeBackground
@onready var shell_reload_progress_bar: TextureProgressBar = $CanvasLayer/ShellReloadProgressBar
@onready var airstrike_shell_reload_progress_bar: TextureProgressBar = $CanvasLayer/AirstrikeShellReloadProgressBar


func _process(delta: float) -> void:
	if show_reload_request:
		elapsed_delay_for_shell += delta
		shell_reload_progress_bar.value = (elapsed_delay_for_shell / shell_reload_delay) * 100
		if elapsed_delay_for_shell >= shell_reload_delay:
			shell_reload_delay = 0.0
			elapsed_delay_for_shell = 0.0
			show_reload_request = false
			shell_reload_progress_bar.value = 0.0

	if show_airstrike_reload_request:
		elapsed_delay_for_airstrike += delta
		airstrike_shell_reload_progress_bar.value = (elapsed_delay_for_airstrike / airstrike_reload_delay) * 100
		if elapsed_delay_for_airstrike >= airstrike_reload_delay:
			airstrike_reload_delay = 0.0
			elapsed_delay_for_airstrike = 0.0
			show_airstrike_reload_request = false
			airstrike_shell_reload_progress_bar.value = 0.0


func display_obj(obj_text):
	var label = Label.new()
	label.text = obj_text
	label.theme = base_theme
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

	if call_count == 0:
		air_shells_label.modulate = Color.GRAY
		airstrike_background.modulate = Color.GRAY
	else:
		air_shells_label.modulate = Color.WHITE
		airstrike_background.modulate = Color.WHITE


func start_shell_reload(delay):
	show_reload_request = true
	shell_reload_delay = delay


func start_airstrike_reload(delay):
	show_airstrike_reload_request = true
	airstrike_reload_delay = delay


func ui_visibility(state: bool):
	canvas_layer.visible = state
