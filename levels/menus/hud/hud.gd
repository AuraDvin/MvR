extends Control

enum tower_type {SOLAR, TURRET, MORTAR}
signal _mode_selectd(tower: tower_type)
var selected_upgrades
	 
# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().process_frame
	for child in $MarginContainer/HBoxContainer2/VBoxContainer/shopContainer.get_children():
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
	var box_container = $MarginContainer/HBoxContainer2/VBoxContainer/shopContainer
	$Selector.position = box_container.get_child(node).global_position
	$Selector.size = box_container.get_child(node).size * box_container.get_child(node).scale


func _on_basic_level_energy_changed(newAmount):
	$MarginContainer/HBoxContainer2/VBoxContainer2/resources/energy_amount.text = " " + str(newAmount)

func _show_upgrades(node):
	var upgrades = $MarginContainer/HBoxContainer2/VBoxContainer2/upgrades
	upgrades.visible = true
	selected_upgrades = node
	for i in range(3):
		var line2 = "\nenergy required: " + str(UpgradeManager.upgrade_costs[node.type][i][node.bought_upgrades[i]]) 
		upgrades.get_child(i + 1).text = UpgradeManager.upgrade_names[node.type][i] + line2 

func _hide_upgrades():
	$MarginContainer/HBoxContainer2/VBoxContainer2/upgrades.visible = false
	selected_upgrades = null
	$Selector.visible = false
