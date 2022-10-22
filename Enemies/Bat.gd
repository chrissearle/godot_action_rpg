extends KinematicBody2D

const FRICTION = 200
const EFFECT = preload("res://Effects/EnemyDeathEffect.tscn")

var knockback = Vector2.ZERO

onready var stats = $Stats

func _physics_process(delta):
	# Friction
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120


func _on_Stats_no_health():
	create_effect()
	queue_free()

func create_effect():
	var effect = EFFECT.instance()
	
	get_parent().add_child(effect)
	effect.global_position = global_position
