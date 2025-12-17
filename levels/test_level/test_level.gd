extends Node2D

var cooldown = 0.5
var local_cooldown = 0
var tower = preload("res://characters/towers/test_tower/test_tower.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	local_cooldown -= delta


func _on_grid_clicked_on_grid(tile_position, tile_size):
	if local_cooldown > 0:
		return
	var new_tower = tower.instantiate()
	$towers.add_child(new_tower)
	new_tower.position += tile_position * tile_size
	new_tower.position += tile_size / 5
	local_cooldown = cooldown
