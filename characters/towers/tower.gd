extends Node
class_name Tower

@export var attack_delay = 0.5
@export var max_health = 10

var local_timer = 0

@onready var body_area : Area2D = $BodyShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_area.area_entered.connect(self.on_body_area_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_body_area_entered(area:Area2D) -> void:
	pass
