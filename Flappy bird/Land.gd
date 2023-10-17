extends StaticBody2D
class_name LandClass
@onready var animation = $AnimationPlayer



func _on_game_over_zone_body_entered(body):
	if body is BirdClass:
		if Globals.is_game_over:
			Globals.is_touch_ground = true
		else:
			Globals.is_game_over = true
			Globals.is_touch_ground = true
