class_name FreeOnDeath extends Node

@export var health: Health
@export var actor: Node
@export var delay: float
@export var particle_pooler: NodePooler

func _ready() -> void:
	health.died.connect(kill)

func kill():
	await get_tree().create_timer(delay).timeout
	await get_tree().process_frame
	var inst = particle_pooler.grab_available_object()
	inst.global_position = actor.global_position
	actor.queue_free()
