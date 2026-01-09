extends Tower
class_name Mortar

const MORTAR_PROJECTILE = preload("uid://ejoce625gd0q")

func _init():
	price = 30
	return_price = 10
	needs_check = false
	ability_delay = 4.0
	ability_value = 3
	type = "mortar"
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#print($AttackTimer.time_left)

# strelja
func ability() -> void:
	var projectile_inst = MORTAR_PROJECTILE.instantiate()
	var target_enemy = $"../../Lanes".get_child(y).get_child(0)
	projectile_inst.targetEnemy = target_enemy
	projectile_inst.position = global_position
	projectile_inst.damage = ability_value
	$"../../Projectiles".add_child(projectile_inst)
