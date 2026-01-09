extends Tower
class_name BasicTower

const TURRET_PROJECTILE = preload("uid://ookojfhe8b4l")

<<<<<<< HEAD
@onready var tower_attack: AudioStreamPlayer2D = $Attack

=======
>>>>>>> b3b8a5e9df769e72bd9413039bbea0e23bdb30c4
func _init():
	self.price = 10
	needs_check = true
	ability_value = 1
<<<<<<< HEAD
=======
	type = "basictower"
>>>>>>> b3b8a5e9df769e72bd9413039bbea0e23bdb30c4
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# strelja
func ability() -> void:
<<<<<<< HEAD
	tower_attack.play()
=======
>>>>>>> b3b8a5e9df769e72bd9413039bbea0e23bdb30c4
	var projectile_inst = TURRET_PROJECTILE.instantiate()
	projectile_inst.position = global_position + Vector2(45,-20)
	projectile_inst.damage = ability_value
	$"../../Projectiles".add_child(projectile_inst)
	
