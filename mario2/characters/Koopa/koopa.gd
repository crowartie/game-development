extends Area2D

class_name Koopa
var is_sliding = false
var is_shell_sliding = false
@export_group("speed")
@export var horisontal_speed = 20
@export var vertical_speed = 100
@export var slide_speed = 200
@export_group("")
const KOOPA_FULL_COLLISION_SHAPE = preload("res://characters/Koopa/Collisions/KoopaWalk.tres")
const KOOPA_DIE_COLLISION_SHAPE = preload("res://characters/Koopa/Collisions/KoopaShell.tres")
const POINTS_LABEL = preload("res://labels/label.tscn")
@onready var rayCast = $RayCast2D
@onready var animated = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
func _ready():
	animated.play("walk")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	position.x += delta * horisontal_speed
	
	if !rayCast.is_colliding():
		position.y +=delta * vertical_speed

func die():
	
	collision_shape.set_deferred("shape",KOOPA_DIE_COLLISION_SHAPE)
	collision_shape.set_deferred("position",KOOPA_DIE_COLLISION_SHAPE)
	horisontal_speed = 0
	vertical_speed = 0
	print("qweasd")
	animated.play("die")
	is_shell_sliding = true

func shell_sliding(player_position: Vector2):
	is_sliding = true
	var movement_direction = 1 if player_position.x <= global_position.x else - 1
	horisontal_speed = -movement_direction * slide_speed
	
func spawn_point_label(enemy):
	Global.score+=100
	var point_label = POINTS_LABEL.instantiate()
	point_label.position = enemy.position + Vector2(-20, -20)
	get_tree().root.add_child(point_label)
	
func die_sliding_koopa():
	horisontal_speed = 0
	vertical_speed = 0
	animated.play("die")
	animated.flip_v = true
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",position + Vector2(0, -25), .3)
	tween.chain().tween_property(self, "position", position + Vector2(0, 500), 3)

func _on_area_entered(area):
	if is_sliding and area is Goomba:  # Если Koopa скользит и сталкивается с врагом
		area.die_sliding_koopa()  # Убейте врага
		spawn_point_label(area)
	if is_sliding and area is Koopa:  # Если Koopa скользит и сталкивается с врагом
		area.die_sliding_koopa()  # Убейте врага
		spawn_point_label(area)
	if is_sliding and area is Player:
		area.die()
	

var can_flip = true
func _on_body_entered(body):
	if (body is Pipe or body is HardBlock):
		horisontal_speed *= -1
		can_flip = false
		await get_tree().create_timer(1.0).timeout
		can_flip = true
	
