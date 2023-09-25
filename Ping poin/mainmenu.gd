extends Node2D


func _on_button_start_game_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_button_exit_pressed():
	get_tree().quit()
