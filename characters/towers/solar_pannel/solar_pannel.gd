extends Tower
class_name SolarPannel

const ENERGY_PICKUP = preload("uid://bxst250rs3x0w")
var rng: RandomNumberGenerator

func _init():
	self.price = 25
	needs_check = false
	ability_delay = 3.1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rng = RandomNumberGenerator.new()
	attack_timer.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# strelja
func ability() -> void:
	#print("attacking")
	var pickup_inst = ENERGY_PICKUP.instantiate()
	var rand_offset = Vector2(rng.randf_range(-1,1), rng.randf_range(-1,1)).normalized() 
	pickup_inst.position = global_position + (rand_offset * 50)
	$"../../Pickups".add_child(pickup_inst)
