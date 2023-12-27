extends CharacterBody2D

class_name Player

@onready var animated_sprite = $AnimatedSprite2D
@onready var area_collision_shape = $Area2D/CollisionShape2D
@onready var area = $Area2D
@onready var body_collision_shape = $CollisionShape2D
@onready var shooting_point = $Marker2D
@onready var is_dead = false
@onready var direction = 0
@onready var is_kill_on_floor = false
@onready var player_mode = PlayerMode.SMALL
const PLAYER_COLLISION_SMALL = preload("res://characters/player/Collisions/CollisionMarioSmall.tres")
const PLAYER_COLLISION_BIG = preload("res://characters/player/Collisions/CollisionMarioBig.tres")
const POINTS_LABEL = preload("res://labels/label.tscn")
const FIREBALL = preload("res://characters/player/Fireball.tscn")

enum PlayerMode {
	SMALL,
	BIG,
	SHOOTING
}

@export_group("speed")
@export var run_speed = 1.8
@export var speed = 250
@export var jump_force = -300
@export_group("")
@export_group("angle of collision with enemy")
@export var min_angle_of_collision = 35
@export var max_angle_of_collision = 145
@export_group("")
var kill_streak = 1
@export_group("gravity")
@export var gravity = 600
@export_group("")

@export_group("Camera sync")
@export var camera_sync: Camera2D
@export var should_camera_sync: bool = true
@export_group("")

var move = Vector2()

func _process(delta):
	# Следование камеры за игроком
	if global_position.x > camera_sync.global_position.x && should_camera_sync:
		camera_sync.global_position.x = global_position.x

func _physics_process(delta):
	# расчёт расположения камеры относительно игрока, запрет уходить за пределы камеры по левой стороне
	var camera_left_bound = camera_sync.global_position.x - camera_sync.get_viewport_rect().size.x / 2 / camera_sync.zoom.x
	if global_position.x < camera_left_bound + 8 && sign(move.x) == -1:
		move = Vector2.ZERO
		return
	if Input.is_action_pressed('ui_right'):
		direction = 1
	elif Input.is_action_pressed('ui_left'):
		direction = -1
	else:
		direction = 0
	if direction !=0:
		move.x = lerp(move.x, speed * float(direction), run_speed * delta)
	else:
		move.x = move_toward(move.x, 0, speed * delta)
	
# Анимация
	var animation_name
	if player_mode == PlayerMode.SMALL:
		animation_name = 'small'
	elif player_mode == PlayerMode.BIG:
		animation_name = 'big'
	elif player_mode == PlayerMode.SHOOTING:
		animation_name = 'shooting'

	if direction != 0 and is_on_floor():
		if move.x>=0 and direction == 1:
			animated_sprite.flip_h = false
			animated_sprite.play('move_' + animation_name)
		elif move.x>0 and direction == -1:
			animated_sprite.flip_h = true
			animated_sprite.play('slide_' + animation_name)
		elif move.x<=0 and direction == -1:
			animated_sprite.flip_h = true
			animated_sprite.play('move_' + animation_name)
		elif move.x<0 and direction == 1:
			animated_sprite.flip_h = false
			animated_sprite.play('slide_' + animation_name)
	else:
		animated_sprite.play('idle_' + animation_name)
	# Вертикальное движение
	
	if is_on_floor():
		kill_streak = 1
		if Input.is_action_just_pressed('ui_up'):
			move.y = jump_force
			animated_sprite.play('jump_' + animation_name)  # Воспроизводим анимацию прыжка
	else:
		move.y += gravity * delta
		if not is_on_floor():
			animated_sprite.play('jump_' + animation_name)  # Воспроизводим анимацию полета
	# Высота прыжка в зависимости от длительности нажатия
	if Input.is_action_just_released('ui_up'):
		move.y *= 0.5 

	if Input.is_action_just_pressed("ui_accept") and player_mode == PlayerMode.SHOOTING:
		shoot()
	velocity = move
	# Применяем движение
	move_and_slide()

	var collision = get_last_slide_collision()
	if collision !=null:
		handle_interaction_with_blocks(collision)
		
		
func shoot():
	animated_sprite.play("shooting")
	set_physics_process(false)
	var fireball = FIREBALL.instantiate()
	fireball.direction = -1 if animated_sprite.flip_h == true else 1
	fireball.global_position = shooting_point.global_position
	get_tree().root.add_child(fireball)		
func handle_interaction_with_blocks(collision: KinematicCollision2D):
	if collision.get_collider() is Brick:
		var collision_angle = rad_to_deg(collision.get_angle())
		if roundf(collision_angle) ==180:
			move.y = 100
			collision.get_collider().selection(player_mode)
	if collision.get_collider() is MysteryBox:
		var collision_angle = rad_to_deg(collision.get_angle())
		if roundf(collision_angle) ==180:
			move.y = 100
			collision.get_collider().bump()

func die():
	if player_mode == PlayerMode.SMALL:
		is_dead = true
		animated_sprite.play("death")
		area.set_collision_layer_value(2,false)
		area.set_collision_mask_value(4,false)
		set_physics_process(false)	
		var death_tween = get_tree().create_tween()
		death_tween.tween_property(self, "position", position + Vector2(0, -48), .5)
		death_tween.chain().tween_property(self, "position", position + Vector2(0, 256), 1)
		death_tween.tween_callback(func(): get_tree().reload_current_scene())
	else:
		set_physics_process(false)
		animated_sprite.play("big_to_small")
func _on_area_2d_area_entered(area):
	if area is Magic_mushroom:
		handle_magic_mushroom_collision(area)
		Global.score += 1000
		area.queue_free()
		
	elif area is Shooting_flower:
		handle_flower_collision(area)
		Global.score += 1000
		area.queue_free()
	elif area is Koopa:
		handle_koopa_collision(area)
		kill_streak += 1
		Global.score += 100 * kill_streak
		
	elif area is Goomba:
		handle_goomba_collision(area)
		kill_streak += 1
		Global.score += 100 * kill_streak

func handle_koopa_collision(koopa: Koopa):
	if koopa.is_shell_sliding and !koopa.is_sliding:
		koopa.shell_sliding(global_position)
	elif koopa.is_sliding:
		pass
	else:
		var angle_of_collision = rad_to_deg(position.angle_to_point(koopa.position))
		if angle_of_collision > min_angle_of_collision && angle_of_collision < max_angle_of_collision:
			koopa.die()
			move.y = -150
			spawn_point_label(koopa)
func handle_goomba_collision(goomba: Goomba):
	
	var angle_of_collision = rad_to_deg(position.angle_to_point(goomba.position))
	if angle_of_collision > min_angle_of_collision && angle_of_collision < max_angle_of_collision:
		goomba.die()
		move.y = -150
		goomba.collision_mask = 0
		spawn_point_label(goomba)	
		get_tree().create_timer(1.5).timeout.connect(goomba.queue_free)		
	else:
		die()
func handle_magic_mushroom_collision(area: Node2D):
	if player_mode == PlayerMode.SMALL:
		set_physics_process(false)
		animated_sprite.play("small_to_big")
		set_collision_shapes(false)

func handle_flower_collision(area: Node2D):
	if player_mode == PlayerMode.SMALL or player_mode == PlayerMode.BIG:
		set_physics_process(false)
		animated_sprite.play("small_to_shooting")
		set_collision_shapes(false) 

func spawn_point_label(enemy):
	var point_label = POINTS_LABEL.instantiate()
	point_label.text = str(kill_streak * 100) 
	point_label.position = enemy.position + Vector2(-20, -20)
	get_tree().root.add_child(point_label)
func set_collision_shapes(is_small: bool):
	var collision_shape = PLAYER_COLLISION_SMALL if is_small else PLAYER_COLLISION_BIG
	body_collision_shape.set_deferred("shape", collision_shape)
	area_collision_shape.set_deferred("shape", collision_shape)
