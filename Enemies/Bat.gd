extends KinematicBody2D

const MAX_SPEED = 50
const ACCELERATION = 300
const FRICTION = 200

const EFFECT = preload("res://Effects/EnemyDeathEffect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

var knockback = Vector2.ZERO
var velocity = Vector2.ZERO

var state = CHASE

onready var stats = $Stats
onready var player_detection_zone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurt_box = $HurtBox

func _physics_process(delta):
	# Friction
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		
		WANDER:
			pass
		
		CHASE:
			var player = player_detection_zone.player
			if player != null:
				var player_vector = (player.global_position - global_position).normalized()
				velocity = velocity.move_toward(player_vector * MAX_SPEED, ACCELERATION * delta)
				sprite.flip_h = velocity.x < 0
			else:
				state = IDLE
	
	move_and_slide(velocity)

func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE

func _on_HurtBox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 120
	hurt_box.create_effect()

func _on_Stats_no_health():
	create_effect()
	queue_free()

func create_effect():
	var effect = EFFECT.instance()
	
	get_parent().add_child(effect)
	effect.global_position = global_position
