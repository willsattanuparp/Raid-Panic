extends Level

func _ready() -> void:
	$GameObjects/SafeWithDoor.disableComponentPairing(0)
	queue_redraw()
	super._ready()
