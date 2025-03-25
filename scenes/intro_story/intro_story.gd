extends Control

var level1_path = "res://scenes/level_1.tscn"
var panels : Array
var fade_duration := 1.0

@onready var skip_story_button: Button = $SkipStoryButton

func _ready() -> void:
	panels = [$PanelTextureRect1, $PanelTextureRect2, $PanelTextureRect3, $PanelTextureRect4]
	start_story_panel()


func start_story_panel():
	print("Starting story panel")
	for panel in panels:
		var tween = create_tween()
		tween.tween_property(panel, "modulate:a", 1.0, fade_duration)
		await tween.finished

	print("Done displaying story panels")
	skip_story_button.text = "Click to continue"


func _on_skip_story_button_button_up() -> void:
	print("Skipping the story")
	SceneManager.load_scene(level1_path)
