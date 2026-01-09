extends Control

enum tower_type {SOLAR, TURRET, MORTAR}
signal _mode_selectd(tower: tower_type)
var selected_upgrades
	 
# Called when the node enters the scene tree for the first time.
func _ready():
	
	await get_tree().process_frame
	for child in $MarginContainer/HBoxContainer2/VBoxContainer2/upgrades.get_children():
		if child.name == "Label":
			continue
		child.pressed.connect(_on_upgrade_pressed.bind(child.get_index() - 1))
	for child in $MarginContainer/HBoxContainer2/VBoxContainer/shopContainer.get_children():
		child.pressed.connect(_on_button_pressed.bind(child.get_index() as tower_type))
		var tb = child as TextureButton
		tb.scale = tb.get_transform().get_scale() * 2
	update_energy_value($"../Player".energy)



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
	var box_container = $MarginContainer/HBoxContainer2/VBoxContainer/shopContainer
	$Selector.size = box_container.get_child(0).size * box_container.get_child(0).scale
	upgrades.visible = true
	selected_upgrades = node
	update_costs(node)

func update_costs(node):
	var upgrades = $MarginContainer/HBoxContainer2/VBoxContainer2/upgrades
	for i in range(3):
		if node.bought_upgrades[i] >= UpgradeManager.upgrade_costs[node.type][i].size():
			upgrades.get_child(i + 1).text = "sold out"
			upgrades.get_child(i + 1).disabled = true
			continue
		upgrades.get_child(i + 1).disabled = false
		var line2 = "\nenergy required: " + str(UpgradeManager.upgrade_costs[node.type][i][node.bought_upgrades[i]]) 
		upgrades.get_child(i + 1).text = UpgradeManager.upgrade_names[node.type][i] + line2 

func _hide_upgrades():
	$MarginContainer/HBoxContainer2/VBoxContainer2/upgrades.visible = false
	selected_upgrades = null
	$Selector.visible = false

func _on_upgrade_pressed(i: int):
	var player = $"../Player"
	if selected_upgrades == null:
		return
	var current_upgrade = selected_upgrades.bought_upgrades[i]
	var energy = player.spend_energy(UpgradeManager.upgrade_costs[selected_upgrades.type][i][selected_upgrades.bought_upgrades[i]])
	if energy == -1:
		print_debug("premalo energije")
		return
	selected_upgrades.upgrade(i)
	selected_upgrades.bought_upgrades[i] += 1
	update_costs(selected_upgrades)
	update_energy_value(energy)

func update_energy_value(new_value):
	$MarginContainer/HBoxContainer2/VBoxContainer2/resources/energy_amount.text = str(new_value)
