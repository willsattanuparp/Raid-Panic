extends Level


func _ready() -> void:
	$GameObjects/KitchenBar.disableComponentPairing(1)
	$GameObjects/Stovetop.disableComponentPairing(1)
	$GameObjects/Sink1.disableComponentPairing(1)
	$GameObjects/SafeWithDoor.disableComponentPairing(0)
	queue_redraw()
	super._ready()
