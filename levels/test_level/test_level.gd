extends Node2D

var cooldown = 0.5
var local_cooldown = 0
var tower = preload("res://characters/towers/test_tower/test_tower.tscn")
var enemy = preload("res://characters/enemies/test_enemy/test_enemy.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemySpawnTimer.start(RandomNumberGenerator.new().randf()* 3)


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


func _on_enemy_spawn_timer_timeout():
	var rng = RandomNumberGenerator.new()
	var lane = rng.randi_range(0, 4)
	var enemy_inst = enemy.instantiate()
	$enemies.get_child(lane).add_child(enemy_inst)
	$EnemySpawnTimer.start(rng.randf()* 3 + 2)
