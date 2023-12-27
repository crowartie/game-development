extends Area2D

class_name Magic_mushroom
@export_group("speed")
@export var horizontal_speed = 20
@export var max_vertical_speed = 150.0
@export var vertical_speed = 0.0
@export_group("")
@onready var ray_cast = $RayCast2D

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"position",position + Vector2(0, -16), .4)


func _process(delta):
	if ray_cast.is_colliding():
		position.x += delta  * horizontal_speed
	else:
		vertical_speed = lerp(vertical_speed, max_vertical_speed, 0.3)
		position.y += delta * vertical_speed
		position.x += delta  * horizontal_speed
		
var can_flip = true
func _on_body_entered(body):
	if can_flip and (body is Pipe or body is HardBlock):
		horizontal_speed *= -1
		can_flip = false
		await get_tree().create_timer(1.0).timeout
		can_flip = true
	
