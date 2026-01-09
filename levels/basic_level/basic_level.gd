extends Node2D
class_name BasicLevel

@onready var lanes = $Lanes
@onready var grid_towers = $Towers
@onready var grid_pickups = $Pickups
@onready var grid_projectiles = $Projectiles
@onready var pause_popout = $PausePopout

var cooldown = 0.5
var local_cooldown = 0
var grid_spaces = {}
var current_wave_max_score: int
var current_wave_score: int

@export var lane_count = 5

signal energy_changed(newAmount: int) 

# Todo 
var towers = [
	preload("res://characters/towers/solar_pannel/solar_pannel.tscn"),
	preload("res://characters/towers/basic_tower/basic_tower.tscn"),
	preload("res://characters/towers/mortar/mortar.tscn"),
]
var enemies = [
	preload("res://characters/enemies/basic_enemy/basic_enemy.tscn"),
	preload("res://characters/enemies/shielded_enemy/shielded_enemy.tscn"),
	preload("res://characters/enemies/fast_enemy/fast_enemy.tscn")
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$EnemySpawnTimer.start(RandomNumberGenerator.new().randf_range(7, 11))
	lane_count = $Lanes.get_child_count() 
	$"../Hud".connect("_mode_selectd", _mode_selected)
	print_debug("Hello")
	if not LevelDataManager.load_state(self):
		# Set by Level Selector item button
		var data = LevelDataManager.get_data(LevelDataManager.current_level_name)
		for es in data.enemy_queue:
			for e in es: 
				# Get the amount of score for each enemy
				print(e.type, " this many times ->", e.count)
				var tmp_enemy = enemies[(int)(e.type)].instantiate()
				data.max_score += tmp_enemy.score
				tmp_enemy.queue_free()
		print("Max level score is: ", data.max_score)
		LevelDataManager.current_level_data = data
	# todo: connect all the signals again(?)
	else: 
		for tower: Tower in grid_towers.get_children():
			var tower_pos = Vector2(tower.x, tower.y)
			grid_spaces[tower_pos] = tower
		for lane in lanes.get_children():
			for enemy: Enemy in lane.get_children(): 
				enemy.defeated.connect(update_score)

func free() -> void:
	# todo: if going to pause/settings
	#LevelDataManager.save_state(self)
	# todo: if exiting to level select 
	#LevelDataManager.remove_existant_data()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	local_cooldown -= delta
	#if current_wave_score >= current_wave_max_score/2:
		#$EnemySpawnTimer.stop()
		#_on_enemy_spawn_timer_timeout()

func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		pause_popout.visible = not pause_popout.visible


func _on_grid_clicked_on_grid(tile_position, tile_size):
	var player = $"../Player"
	if player.holding == player.hand.NONE:
		var selected = grid_spaces.get(tile_position) 
		if selected == null:
			return
		$"../Hud/Selector".visible = true
		$"../Hud/Selector".position = tile_position * tile_size + $Grid.position
		$"../Hud"._show_upgrades(selected.get_child(3))
	if player.holding == player.hand.DELETE:
		var deleting_tower = grid_spaces.get(tile_position) 
		if deleting_tower == null:
			return
		var energy = player.spend_energy(-deleting_tower.return_price)
		emit_signal("energy_changed", energy)
		deleting_tower.queue_free()
		empty_selection()
	# we are placing towers
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
	new_tower.x = tile_position.x
	new_tower.y = tile_position.y
	new_tower.health_gone.connect(_on_tower_health_gone)
	#print(new_tower.position)
	local_cooldown = cooldown
	empty_selection()

func _on_enemy_spawn_timer_timeout():
	var rng = RandomNumberGenerator.new()
	var lane = rng.randi_range(0, self.lane_count - 1) # From to is inclusive
	var next_wave = LevelDataManager.current_level_data.enemy_queue.pop_front()
	
	# No remaining waves
	if next_wave == null: 
		#print_debug("last wave has spawned already")
		# todo: if no more enemies, finish level
		return
	
	current_wave_max_score = 0
	current_wave_score = 0
	
	for e_data in next_wave: 
		for i in e_data.count:
			var enemy_inst = enemies[e_data.type].instantiate()
			enemy_inst.defeated.connect(update_score)
			current_wave_max_score += enemy_inst.score
			enemy_inst.line = lane
			enemy_inst.position = _get_enemy_spawn_position(lane)
			$Lanes.get_child(lane).add_child(enemy_inst)
	$EnemySpawnTimer.start(rng.randf_range(7, 11))

func update_score(score: int):
	print("updating score")
	current_wave_score += score
	LevelDataManager.current_level_data.current_score += score

func _get_enemy_spawn_position(lane) -> Vector2:
	var bottom_left_pos = ($Grid.position + $Grid/BottomLeft.position * $Grid.scale)
	var box_width = $Grid/BottomLeft.position.y * $Grid.scale.y / lane_count
	return Vector2(bottom_left_pos.x, $Grid.position.y + ((0.5 + lane) * box_width))

func _mode_selected(node):
	$"../Player"._set_hand(node)
	if node == $"../Player".hand.NONE:
		empty_selection()

func empty_selection():
	var player = $"../Player"
	player.holding = player.hand.NONE
	$"../Hud"._hide_upgrades()


func _on_tower_health_gone(deleting_tower):
	if deleting_tower == null:
		print_debug("deleting null tower after destruction")
		return
	if deleting_tower.get_child(3) == $"../Hud".selected_upgrades:
		$"../Hud"._hide_upgrades()
	deleting_tower.queue_free()


func _on_pause_popout_index_pressed(index: int) -> void:
	if index == 0: 
		LevelDataManager.save_state(self)
		SceneSwitcher.switchScene("res://levels/menus/settings/settings.tscn")
	elif index == 1: 
		LevelDataManager.remove_existant_data()
		SceneSwitcher.switchScene("res://levels/menus/level_select/level_select.tscn")
