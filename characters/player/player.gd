extends Node
class_name Player

# Get audio and sprite animation
#@onready var sfx_dmg: AudioStreamPlayer2D = $sfx_dmg
#@onready var animate, d_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
enum hand {SOLAR, TURRET, MORTAR, DELETE, NONE}

var money: int = 0
var maxHealth: int = 3
var energy: int = 25	#energy should be read from leveldata and changed by basiclevel.gd
var currentHealth: int = maxHealth
var holding: hand = hand.NONE


func spend_energy(amount: int) -> int:
	var new_amount = energy - amount
	#print_debug(amount)
	if new_amount < 0:
		return -1
	energy = new_amount
	return new_amount

func setMoney(amount):
	#Get starting money from scene
	money = amount

func increaseMoney(amount):
	money += amount

func decreaseMoney(amount):
	money -= amount

func takeDmg(amount):
	currentHealth -= amount
	print_debug("Player took %d dmg" % amount)
	# Send signal to remove enemy that hit player
	# Could also play sound and Hurt animation or something 
	#sfx_dmg.play()
	#animated_sprite_2d.play("Hurt")
	
	if currentHealth <= 0:
		print_debug("Player died (reached 0 hp)")
		# Send signal to scene player is dead

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass
	
func _set_hand(index: int):
	holding = index as hand 
