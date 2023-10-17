extends CharacterBody2D

var move=Vector2()
var speed = 250
var has_bounced = false
func _ready():
	randomize()
	move.x = [-1,1][randi() % 2]
	move.y = [-0.8, 0.8][randi() % 2]
	

func _physics_process(delta):
	
	
	var collision_object = move_and_collide(speed * move * delta)
	if collision_object:
		print(collision_object)
		move = move.bounce(collision_object.get_normal())
		print(collision_object.get_collider().name)
		if (collision_object.get_collider().name == "Player" or collision_object.get_collider().name == "Opponent") and !has_bounced:
			speed = 400 # увеличиваем скорость после первого отталкивания
			has_bounced = true

		
		
		


