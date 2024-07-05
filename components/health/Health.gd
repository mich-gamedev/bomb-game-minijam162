extends Node
class_name Health

@export_group("Health")
@export var max_health: float
@export var starting_health: float
@export var invincibility_time: float = 0.05

@onready var health := clampf(starting_health, 0.0, max_health)
var can_harm := true



signal healed(amount: float)
signal harmed(amount: float)
signal died

enum Team {PLAYER, ENEMY}
func harm(amount: float) -> float:
	if can_harm:
		harmed.emit(amount)
		health -= amount
		if health <= 0:
			died.emit()
		can_harm = false
		await get_tree().create_timer(invincibility_time).timeout
		can_harm = true
	return health

func heal(amount: float) -> float:
	health += amount
	health = minf(health, max_health)
	healed.emit(amount)
	return health
