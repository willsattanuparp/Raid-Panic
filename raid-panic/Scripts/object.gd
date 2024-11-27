class_name GameObject extends AnimatableBody2D


@export var parkourable: ParkourableParent
@export var breakable: BreakableComponent
@export var alarmable: AlarmableComponent

@onready var hitbox = $ObjectHitbox

@export var scoring_id = -1

func _ready() -> void:
	initialize_object()

func disableComponentPairing(index):
	get_child(index).disable()

func enableComponentPairing(index):
	get_child(index).enable()

func initialize_object():
	if is_alarmable():
		add_to_group("Alarmable")
	if is_breakable():
		add_to_group("Breakable")
	if is_parkourable():
		add_to_group("Parkourable")
		parkourable.connect_all_zones()

func is_parkourable():
	return parkourable != null

func is_breakable():
	return breakable != null

func is_alarmable():
	return alarmable != null
