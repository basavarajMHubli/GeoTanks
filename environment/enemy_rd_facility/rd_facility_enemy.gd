extends StaticBody3D

@export var max_health = 100
@export var cur_health = 0

@onready var health_bar: ProgressBar = $StatsSubViewport/HealthBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_bar.value = 100
	cur_health = max_health


func shell_hit(damage_value, _hit_point):
	print("RD_Facility_Enemy: took damage " + str(damage_value))
	cur_health -= damage_value
	health_bar.value = cur_health

	if cur_health <= 0:
		print("RD_Facility_Enemy: Destroyed")
		$EnergyCore.visible = true
