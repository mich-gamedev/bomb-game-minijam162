extends Node

var active: bool = false
var enemy_count: int = 5
var world: int = 0
var wave: int = 0
var spawners = 0


@onready var node_pooler: NodePooler = $NodePooler

var wave_started: bool = false
var spawnable_enemies: Array[EnemyData] ## contains data about each possible enemy, and has repeats based on the sample data

const spawn_rates: Array[EnemySpawnRate] = [
	preload("res://resources/spawnrates/sprout.tres"),
	preload("res://resources/spawnrates/longlegs.tres"),
	preload("res://resources/spawnrates/firefly.tres"),
	preload("res://resources/spawnrates/cannon_fly.tres"),
	preload("res://resources/spawnrates/cacturtle.tres"),
] ## will affect spawnable_enemies's list based on the samples from the spawn curves

signal wave_just_started
signal enemy_just_spawned(enemy: Node)
signal world_ended

func reset() -> void:
	world = 0
	wave = 0
	enemy_count = 5
func _process(delta: float) -> void:
	if !active: return
	var enemies = get_tree().get_nodes_in_group("enemy")
	if enemies.is_empty() and wave_started == false and spawners == 0:
		wave_started = true
		wave += 1
		wave_just_started.emit()
		if wave >= 4:
			enemy_count += 1
			world_ended.emit()
			world += 1
			return
		await get_tree().create_timer(1.0).timeout
		print("spawning %d enemies!" % enemy_count)
		cycle_spawn_rates()
		for i in enemy_count:
			var info: EnemyData = spawnable_enemies.pick_random() as EnemyData
			if info.floating:
				var inst = info.scene.instantiate()
				get_tree().current_scene.add_child(inst)
				enemy_just_spawned.emit(inst)
				inst.global_position = get_tree().get_nodes_in_group(&"flying_enemy_spawn").pick_random().global_position + (Vector2.RIGHT * randf_range(-4,4))
			else:
				var spawn = get_tree().get_nodes_in_group(&"ground_enemy_spawn").pick_random()
				var inst = node_pooler.grab_available_object()
				spawners += 1
				inst.get_node("Sprite2D").enemy_data = info
				inst.global_position = spawn.global_position + (Vector2(randf_range(-4,4), 0)) + (Vector2.DOWN * spawn.ideal_y)
			await get_tree().create_timer(0.2).timeout
			wave_started = false

func cycle_spawn_rates() -> void:
	spawnable_enemies.clear()
	for spawn: EnemySpawnRate in spawn_rates:
		var sample = int(spawn.spawn_rate.sample_baked(float(world) / float(spawn.world_max)))
		print("%s, at %d worlds, at %f x, exists %f times" % [spawn.data.resource_path, world, float(world) / float(spawn.world_max), sample])
		if sample: for i in sample:
			spawnable_enemies.append(spawn.data)


