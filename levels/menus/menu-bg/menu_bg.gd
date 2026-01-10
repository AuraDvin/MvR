extends Control

@onready var background_texture = get_child(0)
@export var speed: float = 16.0
var init_y
# Called when the node enters the scene tree for the first time.
func _ready():
	init_y = background_texture.position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	background_texture.position.y += speed * delta
	var diff = background_texture.position.y - init_y
	if diff > background_texture.size.y / 5:
		background_texture.position.y -= background_texture.size.y / 5
