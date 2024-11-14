class_name ParkourableComponent extends Node2D

@export var width = 100
@export var height = 100
@export var id = -1

#0 = static
#1 = dynamic
@export var mode = 0

var area1
var area2

var entered_area1 = false
var entered_area2 = false

signal entered_zone(id)
signal exited_zone(id)

var transfer_vector

func _ready() -> void:
	area1 = $Area1
	area2 = $Area2
	#transfer_vector = $Area1.global_position - $Area2.global_position

func create_zones(size: Vector2,pos1: Vector2,pos2: Vector2):
	var rect = RectangleShape2D.new() as RectangleShape2D
	rect.size = size
	var rect2 = rect.duplicate()
	$Area1.position = pos1
	$Area2.position = pos2
	$Area1/Hitbox1.shape = rect
	$Area2/Hitbox2.shape = rect2

#
#func initialize():
	#pass

func connect_signals_all():
	connect_signals_area1()
	connect_signals_area2()

func connect_signals_area1():
	$Area1.body_entered.connect(_on_parkourable_body_entered_area1)
	$Area1.body_exited.connect(_on_parkourable_body_exited_area1)

func connect_signals_area2():
	$Area2.body_entered.connect(_on_parkourable_body_entered_area2)
	$Area2.body_exited.connect(_on_parkourable_body_exited_area2)

func _on_parkourable_body_entered_area1(body):
	print("changed transfer vec")
	transfer_vector = $Area2.global_position - $Area1.global_position
	print(transfer_vector)
	entered_zone.emit(id,body)
	entered_area1 = true
	#if body.is_in_group("Player") and !entered_area2:
		#body.can_dodge = true
		##body.can_parkour = true
		#body.parkour_body = get_parent().get_parent()
		#print("can_parkour")
		#print(get_parkour_direction(body.global_position))

func _on_parkourable_body_exited_area1(body):
	entered_area1 = false
	if body.is_in_group("Player"):
		exited_zone.emit(id,body)
		#body.can_parkour = false
		#if body.parkour_body == get_parent().get_parent():
			#body.parkour_body = null
		#print("cannot parkour")

func _on_parkourable_body_entered_area2(body):
	print("changed transfer vec")
	transfer_vector = $Area1.global_position - $Area2.global_position
	print(transfer_vector)
	entered_zone.emit(id,body)
	entered_area2 = true
	#if body.is_in_group("Player") and !entered_area1:
		#body.can_dodge = true
		##body.can_parkour = true
		#body.parkour_body = get_parent().get_parent()
		#print("can_parkour")
		#print(get_parkour_direction(body.global_position))

func _on_parkourable_body_exited_area2(body):
	entered_area2 = false
	if body.is_in_group("Player") and !entered_area1:
		exited_zone.emit(id,body)
		#body.can_parkour = false
		#if body.parkour_body == get_parent().get_parent():
			#body.parkour_body = null
		#print("cannot parkour")
		

##This will only work for static hitboxes that are square
#func get_parkour_direction(vec:Vector2) -> Vector2:
	#var hb = get_parent().hitbox.shape.size
	##print(hb)
	#var left = global_position.x - hb.x/2
	#var right = global_position.x + hb.x/2
	#var top = global_position.y - hb.y/2
	#var bottom = global_position.y + hb.y/2
	#if vec.y < bottom and vec.y > top:
		#if vec.x < left:
			#print("left")
			#return Vector2(-1,0)
		#if vec.x > right:
			#print("right")
			#return Vector2(1,0)
	#if vec.x > left and vec.x < right:
		#if vec.y < top:
			#print("top")
			#return Vector2(0,-1)
		#if vec.y > bottom:
			#print("bot")
			#return Vector2(0,1)
	#return Vector2(0,0)
