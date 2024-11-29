extends GameObject

@onready var counterclockwise_open = global_position.direction_to($OpenCounterClockwise.global_position)
@onready var clockwise_open = global_position.direction_to($OpenClockwise.global_position)

var closed : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()


func open(direction_vec):
	if closed == true:
		var tween = get_tree().create_tween()
		if direction_vec.dot(clockwise_open) > 0:
			tween.tween_property(self,"rotation_degrees",rotation_degrees + 160,.3).set_trans(Tween.TRANS_SINE)
		elif direction_vec.dot(counterclockwise_open) > 0:
			tween.tween_property(self,"rotation_degrees",rotation_degrees - 160,.3).set_trans(Tween.TRANS_SINE)
		closed = false
