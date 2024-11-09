class_name ParkourableComponent extends Area2D

@export var width = 100
@export var height = 100
func _ready() -> void:
	create_zone(Vector2(width,height))

func create_zone(size: Vector2):
	var rect = RectangleShape2D.new() as RectangleShape2D
	rect.size = size
	$CollisionShape2D.shape = rect

func initialize():
	pass
