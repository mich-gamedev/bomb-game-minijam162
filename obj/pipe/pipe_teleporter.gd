@tool
extends Path2D

@export_group("Point 0", "point_0")
@export_range(0, 270, 90, "radians_as_degrees") var point_0_angle: float
@export_group("Point 1", "point_1")
@export_range(0, 270, 90, "radians_as_degrees") var point_1_angle: float

@onready var area_1: Area2D = $Area2D
@onready var area_2: Area2D = $Area2D2
@onready var line_1: Line2D = $Area2D/Line2D
@onready var line_2: Line2D = $Area2D2/Line2D2

var ignore: Array[Node2D]

func _ready() -> void:
	if !Engine.is_editor_hint():
		line_1.hide()
		line_2.hide()
		area_1.body_entered.connect(_area_1_body_entered)
		area_2.body_entered.connect(_area_2_body_entered)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		curve.point_count = 2
		line_1.position = curve.get_point_position(0)
		line_1.rotation = point_0_angle
		line_2.position = curve.get_point_position(1)
		line_2.rotation = point_1_angle
	else:
		ignore = ignore.filter(func(a): return is_instance_valid(a))
		area_1.position = curve.get_point_position(0)
		area_1.rotation = point_0_angle
		area_2.position = curve.get_point_position(1)
		area_2.rotation = point_1_angle


func _area_1_body_entered(body: Node2D) -> void:
	if (body.is_in_group(&"player") or body.is_in_group(&"enemy") or body is Bullet) and !(body in ignore):
		body.set_deferred("global_position", area_2.global_position)
		ignore.append(body)
		if body.is_in_group(&"player"):
			body.health.can_harm = false
		if (body is CharacterBody2D) and (point_0_angle == point_1_angle) and !(point_0_angle in [90,270]):
			body.velocity.x = -body.velocity.x
		await get_tree().create_timer(0.25).timeout
		if !is_instance_valid(body): return
		if body.is_in_group(&"player"):
			body.health.can_harm = true
		ignore.erase(body)

func _area_2_body_entered(body: Node2D) -> void:
	if (body.is_in_group(&"player") or body.is_in_group(&"enemy")) and !(body in ignore):
		body.set_deferred("global_position", area_1.global_position)
		ignore.append(body)
		if body.is_in_group(&"player"):
			body.health.can_harm = false
		if (body is CharacterBody2D) and (point_0_angle == point_1_angle) and !(point_1_angle in [90,270]):
			body.velocity.x = -body.velocity.x
		await get_tree().create_timer(0.25).timeout
		if !is_instance_valid(body): return
		if body.is_in_group(&"player"):
			body.health.can_harm = true
		ignore.erase(body)
