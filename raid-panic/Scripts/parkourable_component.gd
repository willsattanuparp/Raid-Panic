class_name ParkourableComponent extends Area2D

@export var width = 100
@export var height = 100
func _ready() -> void:
	create_zone(Vector2(width,height))

func create_zone(size: Vector2):
	var rect = RectangleShape2D.new() as RectangleShape2D
	rect.size = size
	$CollisionShape2D.shape = rect
#
#func initialize():
	#pass

func connect_signals():
	body_entered.connect(_on_parkourable_body_entered)
	body_exited.connect(_on_parkourable_body_exited)

func _on_parkourable_body_entered(body):
	if body.is_in_group("Player"):
		body.can_dodge = true
		body.can_parkour = true
		body.parkour_body = get_parent()
		#print("can_parkour")
		#print(get_parkour_direction(body.global_position))

func _on_parkourable_body_exited(body):
	if body.is_in_group("Player"):
		body.can_parkour = false
		if body.parkour_body == self:
			body.parkour_body = null
		#print("cannot parkour")

func get_parkour_direction(vec:Vector2) -> Vector2:
	var hb = get_parent().hitbox.shape.size
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
