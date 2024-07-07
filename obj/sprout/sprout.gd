extends CharacterBody2D

@export var speed: float
@export var gravity: float
@export var terminal_velocity: float
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var node_pooler: NodePooler = $NodePooler
@onready var left_raycast: RayCast2D = $LeftRaycast
@onready var right_raycast: RayCast2D = $RightRaycast

var dead_body = preload("res://obj/sprout/dead_sprout.tscn")

func _ready() -> void:
	node_pooler.default_parent = get_tree().current_scene.inst
	sprite.flip_h = velocity.x < 0

func _physics_process(delta: float) -> void:
	sprite.flip_h = velocity.x < 0
	if is_on_floor(): sprite.play(&"walk")
	else: sprite.play(&"fall")

func _on_health_died() -> void:
	var inst = node_pooler.grab_available_object()
	inst.global_position = ((global_position/8.0).round() * 8.0) - Vector2(4,4)

