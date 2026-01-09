class_name SettingsScreen
extends Control

@onready var music_slider: Slider = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer/MusicSlider
@onready var music_volume: Label = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer/MusicVal

@onready var sfx_slider: Slider = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer2/EffectsSlider
@onready var sfx_volume: Label = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer2/EffectsVal


func _ready() -> void:
	var music: float = PlayerConfig.get_volume_music()
	var sfx: float = PlayerConfig.get_volume_sfx()

	music_slider.value = music
	sfx_slider.value = sfx

	music_volume.text = str(int(music))
	sfx_volume.text = str(int(sfx))

	set_bus_volume("Music", music)
	set_bus_volume("Sfx", sfx)


func _on_return_btn_pressed() -> void:
	SceneSwitcher.returnToPrevScene()


func _on_music_slider_value_changed(value: float) -> void:
	PlayerConfig.set_volume_music(value)
	music_volume.text = str(int(value))
	set_bus_volume("Music", value)


func _on_effects_slider_value_changed(value: float) -> void:
	PlayerConfig.set_volume_effects(value)
	sfx_volume.text = str(int(value))
	set_bus_volume("Sfx", value)


func set_bus_volume(bus_name: String, slider_value: float) -> void:
	var bus_index: int = AudioServer.get_bus_index(bus_name)
	if bus_index == -1:
		return

	# Convert slider (0–100) → linear (0.0–1.0)
	var linear: float = slider_value / 100.0

	# Prevent -inf dB
	linear = max(linear, 0.001)

	var db: float = linear_to_db(linear)
	AudioServer.set_bus_volume_db(bus_index, db)
