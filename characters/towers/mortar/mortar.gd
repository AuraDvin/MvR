extends Tower
class_name Mortar

const MORTAR_PROJECTILE = preload("uid://ejoce625gd0q")
<<<<<<< HEAD
@onready var mortar: AudioStreamPlayer2D = $Mortar
=======
>>>>>>> b3b8a5e9df769e72bd9413039bbea0e23bdb30c4

func _init():
	price = 30
	return_price = 10
	needs_check = false
	ability_delay = 4.0
	ability_value = 3
<<<<<<< HEAD
=======
	type = "mortar"
>>>>>>> b3b8a5e9df769e72bd9413039bbea0e23bdb30c4
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#print($AttackTimer.time_left)

# strelja
func ability() -> void:
<<<<<<< HEAD
	var projectile_inst = MORTAR_PROJECTILE.instantiate()
	mortar.play()
=======
	if $"../../Lanes".get_child(y).get_child_count()<1:
		return
	var projectile_inst = MORTAR_PROJECTILE.instantiate()
>>>>>>> b3b8a5e9df769e72bd9413039bbea0e23bdb30c4
	var target_enemy = $"../../Lanes".get_child(y).get_child(0)
	projectile_inst.targetEnemy = target_enemy
	projectile_inst.position = global_position
	projectile_inst.damage = ability_value
	$"../../Projectiles".add_child(projectile_inst)
