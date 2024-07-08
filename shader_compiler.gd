extends Node2D

@onready var pooled_item_2d: AnimateOnStash2D = $PooledItem2D
@onready var pooled_item_2d_2: AnimateOnStash2D = $PooledItem2D2

func _ready() -> void:
	pooled_item_2d.unstash_item(null, "")
	pooled_item_2d.get_node("Sprite2D").enemy_data = preload("res://resources/spawnrates/8ball.tres").data
	pooled_item_2d_2.unstash_item(null, "")
	await get_tree().create_timer(2.5).timeout
	get_tree().change_scene_to_file("res://main.tscn")
