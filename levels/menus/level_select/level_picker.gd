extends Control

@onready var selected_level_ref = $HBoxContainer/LevelSelectionItem
@onready var left_btn = $HBoxContainer/LeftLevelPickBTN
@onready var right_btn = $HBoxContainer/RightLevelPickBTN

var selected_level = 0
var old_selected = 0
# Index of the last level that the player unlocked 
var last_level_unlocked
var last_level = 5

func _ready() -> void:
	last_level_unlocked = PlayerConfig.get_level_beat()
	selected_level_ref.text = "1"
	selected_level_ref.grab_focus.call_deferred()
	selected_level_ref.grab_click_focus.call_deferred()
	left_btn.disabled = true


func _process(_delta: float) -> void:
	if old_selected == selected_level: 
		return 
	old_selected = selected_level
	print(selected_level)
	if selected_level >= last_level && last_level_unlocked == last_level: 
		# The last level in game 
		selected_level_ref.disabled = false
		selected_level_ref.text = "The end"
		print("the end")
	elif selected_level <= last_level_unlocked:
		selected_level_ref.disabled = false
		selected_level_ref.text = str(selected_level + 1)
	else:
		selected_level_ref.disabled = true
		selected_level_ref.text = ""

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_right"): 
		level_right()
	if event.is_action_pressed("ui_left"):
		level_left()
	if event.is_action_pressed("ui_accept"): 
		level_click()


func _on_left_level_pick_btn_pressed() -> void:
	level_left()


func _on_right_level_pick_btn_pressed() -> void:
	level_right()


func level_left() -> void: 
	if selected_level <= 0: 
		selected_level = 0 
		left_btn.disabled = true
		return
	selected_level -= 1
	if selected_level <= 0: 
		left_btn.disabled = true
	right_btn.disabled = false

func level_right() -> void:
	if selected_level > last_level_unlocked: 
		right_btn.disabled = true
		return
	selected_level += 1 
	if selected_level > last_level_unlocked: 
		right_btn.disabled = true
	left_btn.disabled = false

func level_click() -> void: 
	pass 
	
