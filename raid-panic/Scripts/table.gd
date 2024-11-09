extends GameObject


func _ready() -> void:
	parkourable.create_zone(Vector2(200,200))
	super._ready()

func _on_parkourable_body_entered(body):
	print("test")
func _on_parkourable_body_exited(body):
	print(body)
