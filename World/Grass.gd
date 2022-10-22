extends Node2D

const EFFECT = preload("res://Effects/GrassEffect.tscn")

func _on_HurtBox_area_entered(area):
	create_effect()
	queue_free()

func create_effect():
	var effect = EFFECT.instance()
	
	get_parent().add_child(effect)
	effect.global_position = global_position
