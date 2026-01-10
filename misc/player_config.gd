extends Node

var conf_path = "user://mvr.conf"
var config = ConfigFile.new()
var err = config.load(conf_path)
var vol_music : float
var vol_sfx : float
var last_beat_level : int

func get_volume_music() -> float:
	return vol_music

func get_volume_sfx() -> float:
	return vol_sfx

func get_level_beat() -> int: 
	return last_beat_level


func _ready() -> void:
	_loadConf()

func _makeConf() -> void: 
	config.set_value("audio", "music", vol_music)
	config.set_value("audio", "sfx", vol_sfx)
	config.set_value("game", "last_beat_level", last_beat_level)

func _loadConf() -> void:
	# if err == OK:
	#	print_debug("config exists")
	vol_music = config.get_value("audio", "music", 100.0)
	vol_sfx = config.get_value("audio", "sfx", 100.0)
	last_beat_level = config.get_value("game", "last_beat_level", 0)
	
func save() -> void:
	# print_debug("saving")
	_makeConf()
	if config.save(conf_path) != OK: 
		print_debug("error saving config")

func set_volume_music(value: float) -> void:
	if value > 100: 
		value = 100 
	if value < 0: 
		value = 0 
	vol_music = value

func set_volume_effects(value: float) -> void:
	if value > 100: 
		value = 100 
	if value < 0: 
		value = 0 
	vol_sfx = value

func set_level_beat(value: int) -> void: 
	if value < 0: 
		value = 0 
	if value > 5: 
		value = 5
	last_beat_level = value

# Save on exit via x button
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save()


func apply_volumes():
	set_bus_volume("Music", get_volume_music())
	set_bus_volume("Sfx", get_volume_sfx())

func set_bus_volume(bus_name: String, slider_value: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		return

	# Slider 0–100 → linear 0.0–1.0
	var linear: float = slider_value / 100.0

	# Avoid -inf dB
	linear = max(linear, 0.001)

	var db: float = linear_to_db(linear)
	AudioServer.set_bus_volume_db(bus_index, db)
