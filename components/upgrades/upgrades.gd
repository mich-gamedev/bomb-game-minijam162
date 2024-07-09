extends Node

var current: UpgradeStorage = preload("res://resources/upgradestorage/default.tres")
var bought_upgrades: Array[UpgradeStorage]

const possible_upgrades: Array[UpgradeStorage] = [
	preload("res://resources/upgradestorage/upgrades/balloon.tres"),
	preload("res://resources/upgradestorage/upgrades/bomb_rain.tres"),
	preload("res://resources/upgradestorage/upgrades/athlete.tres"),
	preload("res://resources/upgradestorage/upgrades/runner.tres"),
	preload("res://resources/upgradestorage/upgrades/tactical.tres"),
	preload("res://resources/upgradestorage/upgrades/jumper.tres"),
	preload("res://resources/upgradestorage/upgrades/demolition.tres"),
	preload("res://resources/upgradestorage/upgrades/pellets.tres"),
	preload("res://resources/upgradestorage/upgrades/look_ma_no_hands.tres"),
	preload("res://resources/upgradestorage/upgrades/pyrotechnic.tres"),
	preload("res://resources/upgradestorage/upgrades/rocket.tres"),
	preload("res://resources/upgradestorage/upgrades/rogue.tres"),
	preload("res://resources/upgradestorage/upgrades/boxer.tres"),
	preload("res://resources/upgradestorage/upgrades/sniper.tres"),
	preload("res://resources/upgradestorage/upgrades/medic.tres"),
	preload("res://resources/upgradestorage/upgrades/brute.tres"),
	preload("res://resources/upgradestorage/upgrades/lead.tres"),
	preload("res://resources/upgradestorage/upgrades/detonation.tres"),
]

func reset() -> void:
	print("resetting upgrades")
	bought_upgrades.clear()
	current = UpgradeStorage.new()

func add_upgrade(upgrade: UpgradeStorage) -> void:
	bought_upgrades.append(upgrade)
	for i in upgrade.get_property_list():
		if i["type"] == TYPE_INT:
			current.set(i["name"], current.get(i["name"]) + upgrade.get(i["name"]))
		if i["type"] == TYPE_FLOAT:
			current.set(i["name"], current.get(i["name"]) + upgrade.get(i["name"]) - 1.0)
			if current.get(i["name"]) < 0.1:
				current.set(i["name"], 0.1)
