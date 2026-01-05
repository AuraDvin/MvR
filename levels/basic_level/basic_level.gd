extends Node2D

var cooldown = 0.5
var local_cooldown = 0
@export var lane_count = 5

# Todo 
var tower = preload("res://characters/towers/basic_tower/basic_tower.tscn")
var enemy = preload("res://characters/enemies/basic_enemy/basic_enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemySpawnTimer.start(RandomNumberGenerator.new().randf()* 3)
	lane_count = $Lanes.get_child_count() 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	local_cooldown -= delta


func _on_grid_clicked_on_grid(tile_position, tile_size):
	print(tile_position, tile_size)
	if local_cooldown > 0:
		return
	var new_tower = tower.instantiate()
	$Towers.add_child(new_tower)
	new_tower.position += tile_position * tile_size
	new_tower.position += $Grid.position
	new_tower.position += tile_size / 2
	print(new_tower.position)
	local_cooldown = cooldown


func _on_enemy_spawn_timer_timeout():
	var rng = RandomNumberGenerator.new()
	var lane = rng.randi_range(0, self.lane_count)
	var enemy_inst = enemy.instantiate()
	$Lanes.get_child(lane).add_child(enemy_inst)
	$EnemySpawnTimer.start(rng.randf()* 3 + 2)
