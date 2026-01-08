extends Node2D

var cooldown = 0.5
var local_cooldown = 0
var grid_spaces = {}
@export var lane_count = 5

signal energy_changed(newAmount: int) 

# Todo 
var towers = [
	preload("res://characters/towers/solar_pannel/solar_pannel.tscn"),
	preload("res://characters/towers/basic_tower/basic_tower.tscn")
]
var enemy = preload("res://characters/enemies/basic_enemy/basic_enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemySpawnTimer.start(RandomNumberGenerator.new().randf()* 3)
	lane_count = $Lanes.get_child_count() 
	$"../Hud".connect("_mode_selectd", _mode_selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	local_cooldown -= delta


func _on_grid_clicked_on_grid(tile_position, tile_size):
	var player = $"../Player"
	if player.holding == player.hand.NONE:
		return
	if player.holding == player.hand.DELETE:
		var deleting_tower = grid_spaces.get(tile_position) 
		if deleting_tower == null:
			return
		var energy = player.spend_energy(-deleting_tower.return_price)
		emit_signal("energy_changed", energy)
		deleting_tower.queue_free()
		player.holding = player.hand.NONE
		$"../Hud/Selector".visible = false

	if local_cooldown > 0:
		return
	if grid_spaces.get(tile_position) != null:
		print_debug("zasedeno")
		return 
	var new_tower = towers[player.holding].instantiate()
	await get_tree().process_frame
	var energy = player.spend_energy(new_tower.price)
	if energy < 0:
		print_debug("premalo energije")
		return
	emit_signal("energy_changed", energy)
	grid_spaces[tile_position] = new_tower
	$Towers.add_child(new_tower)
	new_tower.position += tile_position * tile_size
	new_tower.position += $Grid.position
	new_tower.position += tile_size / 2
	#print(new_tower.position)
	local_cooldown = cooldown
	player.holding = player.hand.NONE
	$"../Hud/Selector".visible = false

func _on_enemy_spawn_timer_timeout():
	var rng = RandomNumberGenerator.new()
	var lane = rng.randi_range(0, self.lane_count - 1) # From to is inclusive
	var enemy_inst = enemy.instantiate()
	enemy_inst.position = _get_enemy_spawn_position(lane)
	$Lanes.get_child(lane).add_child(enemy_inst)
	$EnemySpawnTimer.start(rng.randf()* 3 + 2)

func _get_enemy_spawn_position(lane) -> Vector2:
	var bottom_left_pos = ($Grid.position + $Grid/BottomLeft.position * $Grid.scale)
	var box_width = $Grid/BottomLeft.position.y * $Grid.scale.y / lane_count
	return Vector2(bottom_left_pos.x, $Grid.position.y + ((0.5 + lane) * box_width))

func _mode_selected(node):
	$"../Player"._set_hand(node)
