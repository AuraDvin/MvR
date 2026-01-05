extends Area2D
class_name Grid

signal clicked_on_grid(tile_position, tile_size)

@export var x_len = 9
@export var y_len = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		var grid_scale = $BottomLeft.global_position - position
		var grid_x = floor((event.position.x - position.x) / grid_scale.x * x_len)
		var grid_y = floor((event.position.y - position.y) / grid_scale.y * y_len)
		emit_signal("clicked_on_grid", Vector2(grid_x, grid_y), Vector2(grid_scale.x/x_len, grid_scale.y/y_len))
	pass
