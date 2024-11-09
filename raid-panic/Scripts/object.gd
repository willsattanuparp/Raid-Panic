class_name GameObject extends StaticBody2D


@export var parkourable: ParkourableComponent
@export var breakable: BreakableComponent
@export var alarmable: AlarmableComponent

func _ready() -> void:
	initialize_object()

func initialize_object():
	if is_alarmable():
		add_to_group("Alarmable")
	if is_breakable():
		add_to_group("Breakable")
	if is_parkourable():
		add_to_group("Parkourable")
		connect_parkourable_signals()
		
func is_parkourable():
	return parkourable != null

func connect_parkourable_signals():
	parkourable.body_entered.connect(_on_parkourable_body_entered)
	parkourable.body_exited.connect(_on_parkourable_body_exited)

func _on_parkourable_body_entered(body):
	print(body)
func _on_parkourable_body_exited(body):
	print(body)

func is_breakable():
	return breakable != null

func is_alarmable():
	return alarmable != null
