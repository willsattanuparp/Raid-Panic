extends Level


func _ready() -> void:
	$GameObjects/KitchenBar.disableComponentPairing(1)
	queue_redraw()
	super._ready()
