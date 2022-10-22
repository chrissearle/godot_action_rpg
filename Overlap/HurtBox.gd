extends Area2D

const EFFECT = preload("res://Effects/HitEffect.tscn")

export(bool) var show_hit = true

func create_effect():
	var effect = EFFECT.instance()
	
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_HurtBox_area_entered(area):
	if show_hit:
		create_effect()
