extends Node2D


@onready var LabelScore = $Camera2D/Score
@onready var LabelCoins = $Camera2D/Coins
@onready var LabelLives = $Camera2D/LivesCount

func _process(delta):
	LabelScore.text = str(Global.score)
	LabelCoins.text = str(Global.coins)
	LabelLives.text = str(Global.lives)
	
