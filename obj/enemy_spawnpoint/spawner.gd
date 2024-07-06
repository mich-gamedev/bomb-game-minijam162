extends Sprite2D

var enemy_data: EnemyData

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	EnemySpawner.spawners -= 1
	var inst = enemy_data.scene.instantiate()
	get_tree().current_scene.add_child(inst)
	inst.global_position = global_position
