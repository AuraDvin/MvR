extends Node2D

var cooldown = 0.5
var local_cooldown = 0
var grid_spaces = {}
@export var lane_count = 5


# Todo 
var tower = preload("res://characters/towers/basic_tower/basic_tower.tscn")
var enemy = preload("res://characters/enemies/basic_enemy/basic_enemy.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemySpawnTimer.start(RandomNumberGenerator.new().randf()* 3)
	lane_count = $Lanes.get_child_count() 
	get_parent().get_child(1).connect("_mode_selectd", _mode_selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	local_cooldown -= delta


func _on_grid_clicked_on_grid(tile_position, tile_size):
	if local_cooldown > 0:
		return
	if grid_spaces.get(tile_position) != null:
		print("zasedeno")
		return 
	var new_tower = tower.instantiate()
	grid_spaces[tile_position] = new_tower
	$Towers.add_child(new_tower)
	new_tower.position += tile_position * tile_size
	new_tower.position += $Grid.position
	new_tower.position += tile_size / 2
	print(new_tower.position)
	local_cooldown = cooldown


func _on_enemy_spawn_timer_timeout():
	var rng = RandomNumberGenerator.new()
	var lane = rng.randi_range(0, self.lane_count - 1) # From to is inclusive
	var enemy_inst = enemy.instantiate()
	var bottom_left_pos = ($Grid.position + $Grid/BottomLeft.position * $Grid.scale)
	var box_width = $Grid/BottomLeft.position.y * $Grid.scale.y / lane_count
	enemy_inst.position = Vector2(bottom_left_pos.x, $Grid.position.y + ((0.5 + lane) * box_width))
	$Lanes.get_child(lane).add_child(enemy_inst)
	$EnemySpawnTimer.start(rng.randf()* 3 + 2)

func _mode_selected(node):
	print(node)
