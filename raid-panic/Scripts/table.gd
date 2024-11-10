extends GameObject


func _ready() -> void:
	parkourable.create_zone(Vector2(200,200))
	super._ready()
