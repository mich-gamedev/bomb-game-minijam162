extends Node
class_name MoveBodyTowards

@export_group("Properties")
@export var active: bool = true
@export var speed: float = 128
@export var accel: float = 64
@export_range(-180, 180, 0.1, "radians_as_degrees") var offset: float
@export_group("Actors")
@export var body: CharacterBody2D
@export var target_group: StringName = &"player"

var target: Node2D


func _physics_process(delta: float) -> void:
	if active:
		target = get_tree().get_first_node_in_group(target_group)
		var direction: Vector2 = body.global_position.direction_to(target.global_position)

		body.velocity = body.velocity.move_toward(direction.rotated(offset) * speed, accel * delta)
