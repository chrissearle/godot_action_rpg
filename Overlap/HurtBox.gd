extends Area2D

const EFFECT = preload("res://Effects/HitEffect.tscn")

onready var timer = $Timer

var invincible = false setget set_invincible

signal invincibility_started
signal invincibility_ended


func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")

func create_effect():
	var effect = EFFECT.instance()
	
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func _on_Timer_timeout():
	self.invincible = false


func _on_HurtBox_invincibility_started():
	set_deferred("monitoring", false)


func _on_HurtBox_invincibility_ended():
	monitoring = true
