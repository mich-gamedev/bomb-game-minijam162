extends Area2D
class_name Hitbox

@export var health: Health
@export var team: Health.Team
@export var is_boss: bool = false

signal hurtbox_entered(hurtbox: Hurtbox)
signal player_stomped(player: CharacterBody2D)
