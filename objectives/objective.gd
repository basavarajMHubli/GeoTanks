extends Node

@export var obj := {
	"id" = 0,
	"name" = "<Objective name>",
	"desc" = "<Objective desc>"
}


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("obj_complete", Callable(ObjectiveManager, "complete"))	
	ObjectiveManager.register(obj)


func mark_complete():
	ObjectiveManager.complete(obj["id"])
