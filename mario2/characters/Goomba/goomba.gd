extends Area2D

class_name Goomba
@export_group("speed")
@export var horisontal_speed = 0
@export var vertical_speed = 150
@export_group("")

const GOOMBA_FULL_COLLISION_SHAPE = preload("res://characters/Goomba/Collisions/GoombaWalk.tres")
const GOOMBA_DIE_COLLISION_SHAPE = preload("res://characters/Goomba/Collisions/GoombaDie.tres")
@onready var rayCast = $RayCast2D
@onready var animatedSprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
func _ready():
	animatedSprite.play("walk")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= delta * horisontal_speed 
	
	if !rayCast.is_colliding():
		position.y +=delta * vertical_speed

func die():
	set_collision_layer_value(4,false)
	set_collision_mask_value(1,false)
	set_collision_mask_value(5,false)
	collision_shape.set_deferred("shape",GOOMBA_DIE_COLLISION_SHAPE)
	collision_shape.set_deferred("position",GOOMBA_DIE_COLLISION_SHAPE)
	horisontal_speed = 0
	vertical_speed = 0
	animatedSprite.play("die")
	
func die_sliding_koopa():
	horisontal_speed = 0
	vertical_speed = 0
	animatedSprite.flip_v = true
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",position + Vector2(0, -25), .3)
	tween.chain().tween_property(self, "position", position + Vector2(0, 500), 3)
	


var can_flip = true
func _on_body_entered(body):
	if can_flip and (body is Pipe or body is HardBlock):
		print("qqqqqqqqqq1111111")
		horisontal_speed *= -1
		can_flip = false
		await get_tree().create_timer(1.0).timeout
		can_flip = true


func _on_visible_on_screen_notifier_2d_screen_entered():
	horisontal_speed = 20
