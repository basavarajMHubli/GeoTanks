extends Node

var objectives: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func register(obj):
	print("ObjectiveManager: registering ", obj["id"])
	objectives.append(obj)
	UIManager.display_obj(obj["name"])


func complete(obj_id):
	print("ObjectiveManager: objective ", str(obj_id), " is complete")
	# Remove objectives from list
	for obj in objectives:
		if obj["id"] == obj_id:
			objectives.erase(obj)
			UIManager.remove_obj(obj["name"])

	if objectives.is_empty():
		print("ObjectiveManager: All objective completed")
