extends RigidBody2D
class_name BirdClass

@export var FLAP_FORCE = -300
@onready var animation = $AnimationPlayer
var is_game_start
var last_flap_time
func _ready():
	gravity_scale = 0
	rotation_degrees = 0 
	last_flap_time = 0
	is_game_start = false

func _process(delta):
	if !Globals.is_game_over: 
		if Input.is_action_just_pressed("ui_accept"):
			is_game_start = true
			gravity_scale = 0.5
			flap()
			last_flap_time = Time.get_ticks_msec()
		elif is_game_start:
			if Input.is_action_just_pressed("ui_accept"):
				flap()
				last_flap_time = Time.get_ticks_msec()
			elif Time.get_ticks_msec() - last_flap_time > 1000:
				rotation_degrees = 90
				animation.seek(0.2)
			else:
				rotation_degrees = -30

func flap():
	rotation_degrees = -30
	linear_velocity.y = FLAP_FORCE
