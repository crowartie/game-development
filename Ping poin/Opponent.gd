extends CharacterBody2D


var speed = 250
var move
var ball

func _ready():
	ball = get_node_or_null("../Ball")

func _physics_process(delta):
	if ball!=null:
		var direction = get_direction()
		
		self.velocity = Vector2(0, direction * speed)
		move_and_slide()
		
func get_direction():
	if ball.position.y > position.y:
		return  1
	elif ball.position.y < position.y:
		return -1
	else:
		return 0
