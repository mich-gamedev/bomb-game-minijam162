extends Node2D

@onready var char: CharacterBody2D = $".."
@export var grad: Gradient

func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	var points: Array[Vector2]
	var point_velocity: Vector2 = Vector2(char.old_dir * 128, -200).normalized() * 160.0
	var point_pos = Vector2.ZERO
	var delta = 1.0/48.0
	for i in 48:
		point_velocity.y += 240.0 * delta
		point_pos += point_velocity * delta
		points.append(point_pos)
	draw_multiline(points, Color("#c0006b"), 2.0)
