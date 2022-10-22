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
onready var soft_collision = $SoftCollision
onready var wander_controller = $WanderController

func _ready():
	pick_wander_state()

func _physics_process(delta):
	# Friction
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			accelerate(Vector2.ZERO, delta)
			seek_player()
			
			if wander_controller.get_time_left() == 0:
				pick_wander_state()

		WANDER:
			seek_player()
			
			if wander_controller.get_time_left() == 0:
				pick_wander_state()

			accelerate_towards_point(wander_controller.target_position, delta)
	
			if global_position.distance_to(wander_controller.target_position) <= 4:
				pick_wander_state()
	
		CHASE:
			var player = player_detection_zone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
	
	if soft_collision.is_colliding():
		velocity += soft_collision.get_push_vector() * delta * 400
	
	move_and_slide(velocity)

func accelerate_towards_point(target_position, delta):
	var direction = global_position.direction_to(target_position)
	accelerate(direction, delta)

func accelerate(destination, delta):
	velocity = velocity.move_toward(destination * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func pick_wander_state():
		state = pick_random_state([IDLE, WANDER])
		wander_controller.start_wander_timer(rand_range(1,3))	

func seek_player():
	if player_detection_zone.can_see_player():
		state = CHASE

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

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
