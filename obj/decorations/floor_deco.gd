@tool
extends AnimatedSprite2D

@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	frame = randi_range(0,7)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !Engine.is_editor_hint():
		if body is CharacterBody2D:
			var vel = sign(body.velocity.x)
			if vel > 0:
				anim.play(&"right")
			if vel < 0:
				anim.play(&"left")
