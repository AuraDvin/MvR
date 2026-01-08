extends Control

enum tower_type {SOLAR, TURRET, MORTAR}
signal _mode_selectd(tower: tower_type)
	 
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	for child in $"MarginContainer/VBoxContainer/HBoxContainer".get_children():
		child.pressed.connect(_on_button_pressed.bind(child.get_index() as tower_type))
		var tb = child as TextureButton
		tb.scale = tb.get_transform().get_scale() * 2



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed(node: tower_type):
	_mode_selectd.emit(node)
	if node != 4:
		$Selector.visible = true
	else:
		$Selector.visible = false
	var box_container = $"MarginContainer/VBoxContainer/HBoxContainer"
	$Selector.position = box_container.get_child(node).global_position
	$Selector.size = box_container.get_child(node).size * box_container.get_child(node).scale


func _on_basic_level_energy_changed(newAmount):
	$MarginContainer/VBoxContainer/HBoxContainer2/resources/energy_amount.text = " " + str(newAmount)
