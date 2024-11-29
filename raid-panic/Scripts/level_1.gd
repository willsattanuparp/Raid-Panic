extends Level

func _ready() -> void:
	$GameObjects/Bed1.disableComponentPairing(0)
	$GameObjects/Bed1.disableComponentPairing(1)
	$GameObjects/SafeWithDoor.disableComponentPairing(0)
	#$GameObjects/SafeWithDoor.disableComponentPairing(1)
	$GameObjects/Shelf1.disableComponentPairing(1)
	$GameObjects/OfficeChair.disableComponentPairing(1)
	$GameObjects/Table1.disableComponentPairing(1)
