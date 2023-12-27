extends StaticBody2D


class_name MysteryBox
const COIN = preload("res://objects/BonusTypes/Coin/Coin.tscn")
const SHROOM = preload("res://objects/BonusTypes/Shroom/Shroom.tscn")
const FLOWER = preload("res://objects/BonusTypes/Flower/Flower.tscn")
@onready var is_empty = false
var bonus_type
enum BonusType {
	COIN,
	SHROOM,
	FLOWER
}

func bump():
	if !is_empty:
		var bump_tween = get_tree().create_tween()
		bump_tween.tween_property(self,"position",position + Vector2(0, -5), .12)
		bump_tween.chain().tween_property(self, "position", position, .12)
		is_empty = true
		$AnimatedSprite2D.play('empty_mystory_box')
		match bonus_type:
			BonusType.COIN:
				spawn_coin()
			BonusType.SHROOM:
				spawn_shroom()
			BonusType.FLOWER:
				spawn_flower()

		


func spawn_coin():
	Global.coins+=1
	Global.score+=200
	var coin = COIN.instantiate()
	coin.global_position = global_position + Vector2(0, -16)
	get_tree().root.add_child(coin)
	
func spawn_shroom():
	var shroom = SHROOM.instantiate()
	shroom.global_position = global_position + Vector2(0,0)
	get_tree().root.add_child(shroom)

func spawn_flower():
	print("asdasdasd")
	var flower = FLOWER.instantiate()
	flower.global_position = global_position + Vector2(0, -5)
	get_tree().root.add_child(flower)
