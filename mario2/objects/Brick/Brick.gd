extends StaticBody2D

class_name Brick

@onready var particles = $GPUParticles2D
@onready var sprite = $Sprite2D
func selection(player_mode: Player.PlayerMode):
	if player_mode == Player.PlayerMode.SMALL:
		bump()
	elif player_mode == Player.PlayerMode.BIG or player_mode == Player.PlayerMode.SHOOTING:
		destroy()

func bump():
	var bump_tween = get_tree().create_tween()
	bump_tween.tween_property(self,"position",position + Vector2(0, -5), .12)
	bump_tween.chain().tween_property(self, "position", position, .12)

func destroy():
	Global.score += 50
	particles.emitting = true
	sprite.visible = false
	self.collision_layer = 0

func _on_gpu_particles_2d_finished():
	queue_free()
