extends GameObject

@export var shape: Shape2D

func _ready() -> void:
	parkourable.create_zone(Vector2(40,126),Vector2(-83,0),Vector2(83,0))
	parkourable.create_zone(Vector2(126,40),Vector2(0,-83),Vector2(0,83))
	super._ready()
