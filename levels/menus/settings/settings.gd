class_name SettingsScreen

extends Control

@onready var music_slider = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/MusicVolSlider
@onready var sfx_slider = $VBoxContainer/ScrollContainer/VBoxContainer/VBoxContainer/SfxVolSlider

func _on_return_btn_pressed() -> void:
	SceneSwitcher.returnToPrevScene()
