class_name SettingsScreen

extends Control

@onready var music_slider: Slider = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer/MusicSlider
@onready var music_volume = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer/MusicVal
@onready var sfx_slider: Slider = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer2/EffectsSlider
@onready var sfx_volume = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer2/EffectsVal

func _ready() -> void:
	music_slider.value = PlayerConfig.get_volume_music()
	sfx_slider.value = PlayerConfig.get_volume_sfx()

func _on_return_btn_pressed() -> void:
	SceneSwitcher.returnToPrevScene()

func _on_music_slider_value_changed(value: float) -> void:
	PlayerConfig.set_volume_music(value)
	music_slider.value = PlayerConfig.get_volume_music()
	music_volume.text = str(int(music_slider.value))


func _on_effects_slider_value_changed(value: float) -> void:
	PlayerConfig.set_volume_effects(value)
	sfx_slider.value = PlayerConfig.get_volume_sfx()
	sfx_volume.text = str(int(sfx_slider.value))
	
