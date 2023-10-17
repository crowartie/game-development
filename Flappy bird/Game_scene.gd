extends Node2D

@onready var bird_node = $Bird
@onready var score_label_in_game = $LabelScore
@onready var start_game_label = $LabelStartGame
@onready var score_label_for_game_over_menu = $MenuGameOver/LabelScoreGameOver
@onready var pause_button = $PauseButton
@onready var game_over_menu = $MenuGameOver
@onready var pause_menu = $MenuPause
@onready var spawn_node = $Spawn
@onready var land_node = $Land

@onready var continue_button = $MenuPause/ButtonContinue
@onready var restart_button_for_pause_menu = $MenuPause/ButtonRestart
@onready var exit_button_for_pause_menu = $MenuPause/ButtonExit
@onready var restart_button_for_game_over_menu = $MenuGameOver/ButtonRestart

func _ready():
	get_tree().paused = false
	Globals.is_game_over = false
	Globals.is_touch_ground = false
	Globals.SCORE = 0
	Globals.SPEED = 200

	restart_button_for_game_over_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	continue_button.process_mode = Node.PROCESS_MODE_ALWAYS
	restart_button_for_pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	exit_button_for_pause_menu.process_mode = Node.PROCESS_MODE_ALWAYS

	score_label_in_game.hide()
	pause_button.hide()
	game_over_menu.hide()
	start_game_label.show()

func _process(delta):
	check_start_game()
	check_end_game()
	score_label_in_game.text= "SCORE: " + str(Globals.SCORE)

func check_start_game():
	if !bird_node.is_game_start:
		bird_node.animation.play("idle")
		if !spawn_node.timer.is_stopped():
			spawn_node.stop()
		if land_node.animation.is_playing():
			land_node.animation.stop()
	else:
		pause_button.show()
		score_label_in_game.show()
		start_game_label.hide()
		bird_node.animation.play("flap")
		if spawn_node.timer.is_stopped():
			spawn_node.start()
		if !land_node.animation.is_playing():
			land_node.animation.play("move_land")

func check_end_game():
	if Globals.is_game_over == true:
		spawn_node.stop()
		Globals.SPEED = 0
		if land_node.animation.is_playing():
			land_node.animation.stop()
		bird_node.rotation_degrees = 90 
		if Globals.is_touch_ground:
			show_game_over_menu()

func show_game_over_menu():
	score_label_in_game.hide()
	pause_button.hide()
	game_over_menu.show()
	score_label_for_game_over_menu.text= "SCORE: " + str(Globals.SCORE)

func _on_button_exit_pressed():
	get_tree().quit()

func _on_pause_button_pressed():
	get_tree().paused = true
	score_label_in_game.hide()
	pause_button.hide()
	pause_menu.show()


func _on_button_restart_pressed():
	get_tree().reload_current_scene()


func _on_button_continue_pressed():
	pass # Replace with function body.
	get_tree().paused = false
	pause_menu.hide()
		
