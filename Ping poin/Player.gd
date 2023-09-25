extends CharacterBody2D

var speed = 250
var move = Vector2()
func _ready():
	var screen = get_viewport_rect().size
	position.y = screen.y/2
	
func _physics_process(delta):
	
	move.y = 0

	if Input.is_action_pressed("ui_up") and not Input.is_action_pressed('ui_down'):
		move.y -= speed
	elif Input.is_action_pressed("ui_down") and not Input.is_action_pressed('ui_up'):
		move.y += speed
	if move.length() > 0:
		move = move.normalized() * speed
	self.velocity = move
	
	move_and_slide()
	
	
