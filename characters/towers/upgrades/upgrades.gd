extends Node

var bought_upgrades = [0,0,0]
var type
# Called when the node enters the scene tree for the first time.
func _ready():
	type = get_parent().type


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
