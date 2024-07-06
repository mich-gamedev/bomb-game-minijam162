extends Node

var active: bool = false
var enemy_count: int = 5
var world: int = 0
var wave: int = 0

var spawnable_enemies: Array[EnemyData] ## contains data about each possible enemy, and has repeats based on the sample data

const spawn_rates: Array[EnemySpawnRate] = [
	preload("res://resources/spawnrates/sprout.tres"),
	preload("res://resources/spawnrates/longlegs.tres"),
] ## will affect spawnable_enemies's list based on the samples from the spawn curves

func reset() -> void:
	world = 0
	wave = 0
	enemy_count = 5

func _process(delta: float) -> void:
	if !active: return
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.is_empty():
		print("spawning %d enemies!" % enemy_count)
		cycle_spawn_rates()
		for i in enemy_count:
			var info: EnemyData = spawnable_enemies.pick_random() as EnemyData
			var inst = info.scene.instantiate()
			get_tree().current_scene.add_child(inst)
			if info.floating:
				inst.global_position = get_tree().get_nodes_in_group(&"flying_enemy_spawn").pick_random().global_position + (Vector2.RIGHT * randf_range(-4,4))
			else:
				inst.global_position = get_tree().get_nodes_in_group(&"ground_enemy_spawn").pick_random().global_position + (Vector2(randf_range(-4,4), 4))

func cycle_spawn_rates() -> void:
	spawnable_enemies.clear()
	for spawn: EnemySpawnRate in spawn_rates:
		for i in spawn.spawn_rate.sample(world / spawn.world_max):
			spawnable_enemies.append(spawn.data)


