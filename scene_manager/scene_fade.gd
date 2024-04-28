extends CanvasLayer

signal on_fade_out_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	color_rect.visible = false


func fade_out():
	color_rect.visible = true
	animation_player.play("fade_to_normal")
	on_fade_out_finished.emit()


func _on_animation_player_animation_finished(anim_name):
	color_rect.visible = false
