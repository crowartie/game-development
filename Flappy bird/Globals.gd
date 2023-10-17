extends Node


var SPEED
var is_game_over 
var is_touch_ground
var SCORE 

func _ready():
	SPEED = 200
	is_game_over = false
	is_touch_ground = false
	SCORE = 0
