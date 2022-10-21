extends Node2D


func _on_HurtBox_area_entered(area):
	create_grass_effect()
	queue_free()

func create_grass_effect():
	var grass_effect_scene = load("res://Effects/GrassEffect.tscn")
	var grass_effect = grass_effect_scene.instance()
	
	var world = get_tree().current_scene
	
	world.add_child(grass_effect)
	grass_effect.global_position = global_position
