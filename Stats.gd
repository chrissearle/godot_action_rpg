extends Node

signal no_health
signal health_changed(value)
signal max_health_changed(value)

export(int) var max_health = 1 setget set_max_health
onready var health = max_health setget set_health

func set_max_health(value):
	max_health = value
	
	if health != null:
		self.health = min(health, max_health)

	emit_signal("max_health_changed", max_health)
	
func set_health(value):
	health = value

	emit_signal("health_changed", health)
		
	if health <= 0:
		emit_signal("no_health")


