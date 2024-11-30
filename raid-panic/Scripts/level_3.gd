extends Level

func _ready() -> void:
	$GameObjects/SafeWithDoor.disableComponentPairing(0)
	$GameObjects/Table2.disableComponentPairing(0)
	$GameObjects/TV.disableComponentPairing(0)
	$GameObjects/TV2.disableComponentPairing(0)
	$GameObjects/Bed1.disableComponentPairing(1)
	$GameObjects/SafeWithDoor.disableComponentPairing(0)
	$GameObjects/Shelf1.disableComponentPairing(1)
	queue_redraw()
	super._ready()
