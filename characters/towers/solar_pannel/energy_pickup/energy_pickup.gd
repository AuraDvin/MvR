extends Node2D

@export var energy_amount: int
# Called when the node enters the scene tree for the first time.
func _init():
	energy_amount = 25
	
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event is not InputEventMouseButton :
		return
	var energy = $"../../../Player".spend_energy(energy_amount * (-1))
	$"../../../Hud"._on_basic_level_energy_changed(energy)
	queue_free()


func _on_lifetime_timeout():
	queue_free()
