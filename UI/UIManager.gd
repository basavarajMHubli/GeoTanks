extends Control

@onready var obj_v_box_container = $CanvasLayer/ObjectiveVBoxContainer
@onready var canvas_layer = $CanvasLayer


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
	

func ui_visibility(state: bool):
	canvas_layer.visible = state
