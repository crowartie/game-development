extends Area2D
class_name Fireball

@onready var ray_cast = $RayCast2D
@onready var ray_cast_left = $RayCastLeft
@onready var ray_cast_right = $RayCastRight
@onready var particles= $GPUParticles2D
@export_group("speed")
@export var horizontal_speed = 200
@export var vertical_speed = 100
@export_group("")
var amplitude = 20
var is_noving_up = false
var direction
var vertical_movement_position

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += delta * horizontal_speed * direction
	if ray_cast.is_colliding():
		is_noving_up = true
		vertical_movement_position = position
	if is_noving_up:
		position.y -= vertical_speed * delta
		if vertical_movement_position.y - amplitude >= position.y:
			is_noving_up = false
	if !is_noving_up:
		position.y += delta * vertical_speed 
	
			
func _on_area_entered(area):
	if area is Goomba:
		area.die_sliding_koopa()
		explode()
	if area is Koopa:
		area.die_sliding_koopa()
		explode()
	

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if ray_cast_left.is_colliding():
		horizontal_speed = 0
		vertical_speed = 0
		position.x = position.x
		explode()


func explode():
	vertical_speed = 0
	horizontal_speed = 0
	particles.emitting = true
	set_collision_layer_value(6,false)
	set_collision_mask_value(1,false)
	set_collision_mask_value(4,false)
	set_collision_mask_value(5,false)

func _on_gpu_particles_2d_finished():
	queue_free()
