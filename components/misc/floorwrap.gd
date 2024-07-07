class_name FloorWrap extends Area2D

@export var ceiling_y: float

func _ready() -> void:
	set_collision_layer_value(8, true)
	set_collision_mask_value(8,true)
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		print("body entered zone")
		body.global_position.y = ceiling_y
		if body.is_in_group(&"player"):
			print("player entered zone")
			body.health.can_harm = false
			await get_tree().create_timer(0.25).timeout
			body.health.can_harm = true
