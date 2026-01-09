extends Node

#this should be a json but i dont feel like it
var upgrade_names = {
	"basictower": ["tower slows enemies", "increase attack speed", "increase damage"],
	"mortar": ["tower stuns enemies", "increase attack speed", "increase damage"],
	"solarpannel": ["auto collect energy", "increase production speed", "incrrease energy value"]
}

var upgrade_costs = {
	"basictower": [[50], [20, 30, 50], [40, 60, 90]],
	"mortar": [[45], [25, 35, 45], [30, 40, 50]],
	"solarpannel": [[50], [20, 25, 30], [30, 40, 55]]
}

var values = {
	"basictower": [[1], [0.9, 0.8, 0.75], [2,3,400]],
	"mortar": [[1], [0.95, 0.9, 0.8], [5,6,7]],
	"solarpannel": [[1], [0.9, 0.8, 0.7], [15, 20, 25]]
}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
