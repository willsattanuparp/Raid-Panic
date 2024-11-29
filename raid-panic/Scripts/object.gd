class_name GameObject extends AnimatableBody2D


@export var parkourable: ParkourableParent
@export var breakable: BreakableComponent
@export var alarmable: AlarmableComponent

@export var sprite : Sprite2D

@onready var hitbox = $ObjectHitbox

@export var scoring_id = -1

func _ready() -> void:
	initialize_object()

func disableComponentPairing(index):
	$ParkourableParent.get_child(index).disable()

func enableComponentPairing(index):
	$ParkourableParent.get_child(index).enable()

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

func delete():
	if sprite != null:
		sprite.hide()
	$ObjectSprite.hide()
	set_collision_layer_value(3,false)
	set_collision_mask_value(1,false)
	if is_alarmable():
		queue_free()
