extends KinematicBody2D

const FRICTION = 200

var knockback = Vector2.ZERO

func _physics_process(delta):
	# Friction
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

func _on_HurtBox_area_entered(area):
	knockback = area.knockback_vector * 120
