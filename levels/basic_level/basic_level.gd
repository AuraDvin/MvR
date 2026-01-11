extends Node2D
class_name BasicLevel

signal energy_changed(newAmount: int) 

@onready var lanes = $Lanes
@onready var grid_towers = $Towers
@onready var grid_pickups = $Pickups
@onready var grid_projectiles = $Projectiles
@onready var pause_popout = $PausePopout
@onready var soundtrack: AudioStreamPlayer2D = $"../Soundtrack"
@onready var wave_spawn_timer = $EnemySpawnTimer
@onready var player = $"../Player"

var lane_count = 5
var cooldown = 0.5
var grid_spaces = {}
var current_wave_max_score: int = int(INF)

var stop_spawning = false
var local_cooldown = 0
var current_wave_score: int = int(-INF)
var timer_text: String = "Game start!"


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

func _ready():
	$AcceptDialog.visible = false
	lane_count = $Lanes.get_child_count() 
	$"../Hud".connect("_mode_selectd", _mode_selected)
#	print_debug("Hello")
	if not LevelDataManager.load_state(self):
		# Set by Level Selector item button
		var data = LevelDataManager.get_data(LevelDataManager.current_level_name)
		# Set the max score of the level
		for es in data.enemy_queue:
			for e in es: 
				var tmp_enemy = enemies[(int)(e.type)].instantiate()
				data.max_score += tmp_enemy.score
				tmp_enemy.queue_free()
#		print("Max level score is: ", data.max_score)
		LevelDataManager.current_level_data = data
		player.energy=data.energy
		# Spawn first wave (also updates the timer string)
		$EnemySpawnTimer.start(5)
		$ChangeTimerLabel.emit_signal("timeout")
	else: 
		for tower: Tower in grid_towers.get_children():
			var tower_pos = Vector2(tower.x, tower.y)
			grid_spaces[tower_pos] = tower
		for lane in lanes.get_children():
			for enemy: Enemy in lane.get_children(): 
				enemy.defeated.connect(update_score)
		# use the wait time that was loaded from level data
		$EnemySpawnTimer.start(LevelDataManager.current_level_data.wave_time_remaining) 
		$ChangeTimerLabel.emit_signal("timeout") # immediatelly update timer string

func _process(delta):
	local_cooldown -= delta
	$"../Hud/MarginContainer/HBoxContainer2/VBoxContainer2/resources/TimerLabel".text = timer_text
	# This is the strin that should be applied to a label's text
#	 print_debug(timer_text)
	if stop_spawning: 
		var iii = 0
		for lane1 in lanes.get_children():
#			print("count", lane1.get_child_count())
			if lane1.get_child_count() == 0: 
				iii += 1
#		print("final count", iii)
		if iii >= lane_count: 
			$AcceptDialog.visible = true
			timer_text = "Game Over!"
		return
	
	if current_wave_score >= (current_wave_max_score / 2.0):
		$EnemySpawnTimer.emit_signal("timeout")

func _input(event: InputEvent) -> void:
	if not $AcceptDialog.visible && event.is_action_pressed("ui_cancel"):
		pause_popout.visible = not pause_popout.visible

func _on_grid_clicked_on_grid(tile_position, tile_size):
	var energy
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
		energy = player.spend_energy(-deleting_tower.return_price)
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
	energy = player.spend_energy(new_tower.price)
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
	# Already spawned last wave
	if stop_spawning:
		return
	
	# Assume this is player quitting the level
	if LevelDataManager.current_level_data == null: 
		return
	
	var next_wave = LevelDataManager.current_level_data.enemy_queue.pop_front()
	
	if next_wave == null: 
		stop_spawning = true
		print_debug("last wave has spawned already")
		$ChangeTimerLabel.stop()
		timer_text = "Last Wave"
		return 
	
	spawn_wave(next_wave)
	
	$ChangeTimerLabel.stop()
	timer_text = "New Wave incoming!"
	$ChangeTimerLabel.start(3)
	
	var rng = RandomNumberGenerator.new()
	$EnemySpawnTimer.start(rng.randf_range(7, 11))

func spawn_wave(next_wave):
	var rng = RandomNumberGenerator.new()
	current_wave_max_score = 0
	current_wave_score = 0
	for e_data in next_wave: 
		for i in e_data.count:
			var lane = rng.randi_range(0, self.lane_count - 1)
			var enemy_inst:Enemy = enemies[e_data.type].instantiate()
			enemy_inst.defeated.connect(update_score)
			current_wave_max_score += enemy_inst.score
			enemy_inst.line = lane
			enemy_inst.position = _get_enemy_spawn_position(lane)
			enemy_inst.speed *= rng.randf_range(0.8, 1.2)
			$Lanes.get_child(lane).add_child(enemy_inst)
	print_debug("current wave has a max score of ", current_wave_max_score)

func update_score(score: int):
	current_wave_score += score
	if LevelDataManager.current_level_data != null:
		LevelDataManager.current_level_data.current_score += score

func _get_enemy_spawn_position(lane) -> Vector2:
	var bottom_left_pos = ($Grid.position + $Grid/BottomLeft.position * $Grid.scale)
	var box_width = $Grid/BottomLeft.position.y * $Grid.scale.y / lane_count
	var random_x_shift = RandomNumberGenerator.new().randi_range(-5, 5)
	var x_position = bottom_left_pos.x + random_x_shift
	var y_position = $Grid.position.y + ((0.5 + lane) * box_width)
	return Vector2(x_position, y_position)

func _mode_selected(node):
	player._set_hand(node)
	if node == player.hand.NONE:
		empty_selection()

func empty_selection():
	player.holding = player.hand.NONE
	$"../Hud"._hide_upgrades()

func _on_tower_health_gone(deleting_tower):
	if deleting_tower == null:
		print_debug("deleting null tower after destruction")
		return
	if deleting_tower.get_child(3) == $"../Hud".selected_upgrades:
		$"../Hud"._hide_upgrades()
	deleting_tower.queue_free()

func win():
	var basename: String = LevelDataManager.current_level_name.get_basename()
	LevelDataManager.remove_existant_data()
	var level_num: int = int(basename[-1])
	if PlayerConfig.last_beat_level < level_num:
		PlayerConfig.last_beat_level = level_num
	print_debug("Level Beaten", PlayerConfig.last_beat_level)
	$AcceptDialog.visible = false
	SceneSwitcher.returnToPrevScene()

func _on_pause_popout_index_pressed(index: int) -> void:
	if index == 0: 
		LevelDataManager.save_state(self)
		SceneSwitcher.switchScene("res://levels/menus/settings/settings.tscn")
	elif index == 1: 
		LevelDataManager.remove_existant_data.call_deferred()
		SceneSwitcher.returnToPrevScene()

func _on_accept_dialog_confirmed() -> void:
	win()

func _on_accept_dialog_canceled() -> void:
	win()

func _on_accept_dialog_close_requested() -> void:
	win()


func _on_change_timer_label_timeout() -> void:
	var seconds_left: int = int($EnemySpawnTimer.time_left)
	var minutes : int = int((seconds_left % 3600) / 60.0)	# Doing this to avoid warnings
	var seconds : int =  seconds_left % 60
	timer_text = "%02d:%02d" % [minutes, seconds]
	$ChangeTimerLabel.start(1)
