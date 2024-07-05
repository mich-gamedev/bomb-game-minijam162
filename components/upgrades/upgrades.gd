extends Node

var current: UpgradeStorage = UpgradeStorage.new()
var bought_upgrades: Array[UpgradeStorage]

func reset() -> void:
	current = UpgradeStorage.new()

func add_upgrade(upgrade: UpgradeStorage) -> void:
	bought_upgrades.append(upgrade)
	for i in upgrade.get_property_list():
		if i["type"] == TYPE_INT:
			current.set(i["name"], current.get(i["name"]) + upgrade.get(i["name"]))
		if i["type"] == TYPE_FLOAT:
			current.set(i["name"], current.get(i["name"]) + upgrade.get(i["name"]) - 1.0)
