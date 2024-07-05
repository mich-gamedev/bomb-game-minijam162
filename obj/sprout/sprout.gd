extends CharacterBody2D

@export var speed: float
@export var gravity: float
@export var terminal_velocity: float
@onready var area_coll: CollisionShape2D = $Area2D/CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var node_pooler: NodePooler = $NodePooler


var move_right: bool = randi_range(0,1) == 1

func _physics_process(delta: float) -> void:
	velocity.y = move_toward(velocity.y, terminal_velocity, gravity * delta)
	if is_on_floor():
		sprite.flip_h = !move_right
		velocity.x = speed * lerp(-1,1,int(move_right))


	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	move_right = !move_right
	area_coll.position.x = -area_coll.position.x


func _on_health_died() -> void:
	var inst = node_pooler.grab_available_object()
	inst.global_position = global_position.snapped(Vector2.ONE * 8) - (Vector2.ONE * 4)

