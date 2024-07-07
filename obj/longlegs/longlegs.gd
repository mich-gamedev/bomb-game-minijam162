extends CharacterBody2D
@onready var sprite_1: NinePatchSprite2D = $NinePatchSprite2D
@onready var pivot: Node2D = $Node2D
@onready var sprite_2: NinePatchSprite2D = $NinePatchSprite2D2

@export var noise: FastNoiseLite
@onready var head_place = $Node2D/Hitbox/CollisionShape2D/HeadPlace
var dead_body = preload("res://obj/longlegs/dead_long_legs.tscn")

func _ready() -> void:
	noise.seed = randi()


func _physics_process(delta: float) -> void:
	velocity.y += 480 * delta
	noise.offset.x += delta * 16
	sprite_1.size.y = ((noise.get_noise_1d(0) + 1) * 32)
	sprite_1.position = -sprite_1.size
	pivot.position.y = -sprite_1.size.y + 16
	sprite_2.size = sprite_1.size
	sprite_2.position = sprite_1.position
	move_and_slide()


func _on_health_died():
	var body_inst = dead_body.instantiate()
	body_inst.global_position = head_place.global_position
	get_parent().add_child(body_inst)
