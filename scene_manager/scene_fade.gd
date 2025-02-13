extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	color_rect.visible = false


func fade_out():
	color_rect.visible = true
	animation_player.play("fade_to_normal")


func _on_animation_player_animation_finished(_anim_name):
	color_rect.visible = false
