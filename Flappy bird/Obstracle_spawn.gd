extends Node2D

@onready var timer = $Timer 
var Obstacle = preload("res://Obstracle.tscn")


func _ready():
	randomize()

func start():
	timer.start()

func stop():
	timer.stop()

func spawn():
	var obstacle = Obstacle.instantiate()
	add_child(obstacle)
	obstacle.position.y = randi() % 250 + 100  # Задайте нужную позици

func _on_timer_timeout():
	spawn()
