extends Node

var bought_upgrades = [0,0,0]
var type
<<<<<<< HEAD
# Called when the node enters the scene tree for the first time.
func _ready():
	type = get_parent().name.to_lower()
=======
signal special
# Called when the node enters the scene tree for the first time.
func _ready():
	type = get_parent().type
>>>>>>> b3b8a5e9df769e72bd9413039bbea0e23bdb30c4


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
<<<<<<< HEAD
=======

func upgrade(i: int):
	match i:
		0:
			$"..".special = true
			emit_signal("special")
>>>>>>> b3b8a5e9df769e72bd9413039bbea0e23bdb30c4
