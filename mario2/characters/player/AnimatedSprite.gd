extends AnimatedSprite2D


func _on_animation_finished():
	if animation == "small_to_big":
		reset_player_properties()
		get_parent().player_mode = Player.PlayerMode.BIG
	if animation == "small_to_shooting":
		reset_player_properties()
		get_parent().player_mode = Player.PlayerMode.SHOOTING
	if animation == "shooting":
		get_parent().set_physics_process(true)
	if animation == "big_to_small":
		get_parent().set_physics_process(true)
		get_parent().player_mode = get_parent().PlayerMode.SMALL
		get_parent().set_collision_shapes(true)
func reset_player_properties():
	offset = Vector2.ZERO
	get_parent().set_physics_process(true)
