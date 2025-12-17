extends CharacterBody2D
class_name Player

# Get audio and sprite animation
#@onready var sfx_dmg: AudioStreamPlayer2D = $sfx_dmg
#@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var money: int = 0

var maxHealth: int = 3
var currentHealth: int = maxHealth

func setMoney(amount):
	#Get starting money from scene
	money = amount

func increaseMoney(amount):
	money += amount

func decreaseMoney(amount):
	money -= amount

func takeDmg(amount):
	currentHealth -= amount
	print("Player took %d dmg" % amount)
	# Send signal to remove enemy that hit player
	# Could also play sound and Hurt animation or something 
	#sfx_dmg.play()
	#animated_sprite_2d.play("Hurt")
	
	if currentHealth <= 0:
		print("You died")
		# Send signal to scene player is dead

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
