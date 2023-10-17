extends Node2D

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var SPEED = Globals.SPEED
	position.x += -SPEED * delta

func _on_pipe_body_entered(body):
	if body is BirdClass:
		Globals.is_game_over = true


func _on_pipe_2_body_entered(body):
	if body is BirdClass:
		Globals.is_game_over = true
	


func _on_area_2d_body_entered(body):
	if body is BirdClass:
		Globals.SCORE +=1
