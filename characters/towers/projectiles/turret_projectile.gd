extends Node2D

@export var speed: float = 10
var damage: int
var slow = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	position.x += speed

func special():
	$Sprite2D.frame = 1
	slow = true
