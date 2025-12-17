extends Node2D

@export var health = 5
@export var speed = 20.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x -= speed  * delta


func _on_area_2d_area_entered(area):
	if area.is_in_group("bullet"):
		health -= 1
	if health == 0:
		queue_free()
	
