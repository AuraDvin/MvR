class_name SettingsScreen

extends Control

@onready var music_slider = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer/MusicSlider
@onready var music_volume = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer/MusicVal
@onready var sfx_slider = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer2/EffectsSlider
@onready var sfx_volume = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/HBoxContainer2/EffectsVal

func _on_return_btn_pressed() -> void:
	SceneSwitcher.returnToPrevScene()

func _on_music_slider_value_changed(value: float) -> void:
	music_volume.text = str(int(value))


func _on_effects_slider_value_changed(value: float) -> void:
	sfx_volume.text = str(int(value))
