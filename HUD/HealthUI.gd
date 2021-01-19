extends Control

export var hearts = 6 setget set_hearts
export var max_hearts = 6 setget set_max_hearts
var max_value = max_hearts

onready var healthbar = $Healthbar

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
		#label.text = "HP =" + str(hearts)
	healthbar.max_value = max_value
	healthbar.value = hearts
	
	
func set_max_hearts(value):
	max_hearts = max(value, 1)
	
func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", self, "set_hearts")
