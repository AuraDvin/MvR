@abstract
class_name Tower
extends Node

var x: int
var y: int
var price: int
var return_price: int # on destroy currency return

@onready var body_area : Area2D = $BodyShape2D
@onready var attack_timer : Timer = $AttackTimer

@export var ability_delay: float
@export var ability_value: int # Damage, currency amount, other shit

@export var max_health: int
@export var current_health: int

signal health_gone

# Not sure if bullets should be preloaded in the abstract, some towers might not shoot (if we have wall)

var local_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print_debug("Placed tower with id %s ready on (x, y): (%d, %d)" % [name, x, y])
	body_area.area_entered.connect(self.on_body_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if attack_check():
		ability()

func _exit_tree() -> void:
	print_debug("Tower at (x,y): (%d, %d) with name %s removed from tree" % [x, y, name])
	# Potentially trigger death ability, like exploding?

func on_body_area_entered(area:Area2D) -> void:
	pass # I think this is in the enemy class, could call receive_damage there?

# not perfect, generators should generate all the time
# could change in the specific tower implementation i guess
func attack_check() -> bool:
	var enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in enemies:
		if enemy.line == x:
			return true
	return false

func ability() -> void: # tower specific
	pass

func receive_damage(damage: int) -> void:
	current_health -= damage
	if current_health <= 0:
		health_gone.emit()  # death signal
