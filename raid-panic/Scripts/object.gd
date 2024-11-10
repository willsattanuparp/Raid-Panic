class_name GameObject extends StaticBody2D


@export var parkourable: ParkourableComponent
@export var breakable: BreakableComponent
@export var alarmable: AlarmableComponent

@onready var hitbox = $ObjectHitbox

func _ready() -> void:
	initialize_object()

func initialize_object():
	if is_alarmable():
		add_to_group("Alarmable")
	if is_breakable():
		add_to_group("Breakable")
	if is_parkourable():
		add_to_group("Parkourable")
		parkourable.connect_signals()

func is_parkourable():
	return parkourable != null

func is_breakable():
	return breakable != null

func is_alarmable():
	return alarmable != null
