extends Node

var bought_upgrades = [0,0,0]
var type
var base_reload: float
signal special
# Called when the node enters the scene tree for the first time.
func _ready():
	type = get_parent().type
	base_reload = get_parent().ability_delay

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func upgrade(i: int):
	match i:
		0:
			$"..".special = true
			emit_signal("special")
		1:
			get_parent().ability_delay = base_reload * UpgradeManager.values[type][i][bought_upgrades[i]]
		2:
			get_parent().ability_value = UpgradeManager.values[type][i][bought_upgrades[i]]
