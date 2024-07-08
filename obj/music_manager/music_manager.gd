extends Node

@onready var upgrade: AudioStreamPlayer = $Upgrade
@onready var battle: AudioStreamPlayer = $Battle

var tween: Tween

func _ready() -> void:
	for i: AudioStreamPlayer in [upgrade, battle]:
		i.play()


func transition(from: StringName, to: StringName, time_sec: float = 0.25) -> void:
	tween = create_tween()
	tween.parallel().tween_method(
		func(a): AudioServer.set_bus_volume_db(AudioServer.get_bus_index(to), a),
		-80,
		0,
		time_sec
	)
	tween.parallel().tween_interval(time_sec / 4)
	tween.tween_method(
	func(a): AudioServer.set_bus_volume_db(AudioServer.get_bus_index(from), a),
	0,
	-80,
	time_sec
	)
	await tween.finished
	print("music channel == %f" % AudioServer.get_bus_volume_db(AudioServer.get_bus_index(&"Music")))
	print("tween finished %s to %f" % [to, AudioServer.get_bus_volume_db(AudioServer.get_bus_index(to))])

