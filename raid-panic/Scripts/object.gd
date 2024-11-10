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
	if body.is_in_group("Player"):
		body.can_parkour = true
		body.parkour_body = self
		print("can_parkour")
		print(get_parkour_direction(body.global_position))

func _on_parkourable_body_exited(body):
	if body.is_in_group("Player"):
		body.can_parkour = false
		if body.parkour_body == self:
			body.parkour_body = null
		print("cannot parkour")

func get_parkour_direction(vec:Vector2) -> Vector2:
	var hb = $ObjectHitbox.shape.size
	#print(hb)
	var left = global_position.x - hb.x/2
	var right = global_position.x + hb.x/2
	var top = global_position.y - hb.y/2
	var bottom = global_position.y + hb.y/2
	if vec.y < bottom and vec.y > top:
		if vec.x < left:
			print("left")
			return Vector2(-1,0)
		if vec.x > right:
			print("right")
			return Vector2(1,0)
	if vec.x > left and vec.x < right:
		if vec.y < top:
			print("top")
			return Vector2(0,-1)
		if vec.y > bottom:
			print("bot")
			return Vector2(0,1)
	return Vector2(0,0)


func is_breakable():
	return breakable != null

func is_alarmable():
	return alarmable != null
