extends Control

@onready var obj_v_box_container = $CanvasLayer/ObjectiveVBoxContainer
@onready var canvas_layer = $CanvasLayer
@onready var shells_label = $CanvasLayer/ShellsLabel
@onready var air_shells_label: Label = $CanvasLayer/AirShellsLabel
@onready var airstrike_background: Sprite2D = $CanvasLayer/AirstrikeBackground


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


func ui_visibility(state: bool):
	canvas_layer.visible = state
