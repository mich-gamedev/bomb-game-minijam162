class_name FloorWrap extends Area2D

@export var ceiling_y: float

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.set_deferred("global_position:y", ceiling_y)
		if body.is_in_group(&"player"):
			body.health.can_harm = false
			await get_tree().create_timer(0.25).timeout
			body.health.can_harm = true
