class_name ParkourableParent extends Node2D

var statuses: Array = []
var parkour_component_scene:PackedScene = load("res://Scenes/Objects/Components/parkourable_component.tscn")

func _ready() -> void:
	statuses.resize(get_child_count())
	for i in statuses:
		i = false
	assign_zone_ids()

#func draw_zones():
	#for i in get_children():
		#i.draw_zones()

func create_zone(size: Vector2,pos1: Vector2,pos2: Vector2):
	var parkour_component = parkour_component_scene.instantiate() as ParkourableComponent
	parkour_component.create_zones(size,pos1,pos2)
	add_child(parkour_component)
	statuses.append(false)
	assign_zone_ids()

func create_zone_with_shape(shape: Shape2D,pos1: Vector2,pos2: Vector2):
	var parkour_component = parkour_component_scene.instantiate() as ParkourableComponent
	parkour_component.create_zones_with_shape(shape,pos1,pos2)
	add_child(parkour_component)
	statuses.append(false)
	assign_zone_ids()

#TODO: get input direction vector as a parameter, choose the closest transfer vector
func get_teleport_location(player_facing):
	var indices = []
	for i in range(statuses.size()):
		if statuses[i] == true:
			indices.append(i)
	#var index = statuses.find(true)
	#if no parkouring is detected, return null
	#if index == -1:
		#return null
	if indices.is_empty():
		return null
	#TODO
	var component
	for i in get_children():
		if indices.has(i.id) and (component == null or i.transfer_vector.dot(player_facing) > component.transfer_vector.dot(player_facing)):
				component = i
	if component == null:
		printerr("No component found")
	#component is the correct component - use this to get the tele location
	return component.transfer_vector

func assign_zone_ids():
	var count = 0
	for i in get_all_zones():
		i.id = count
		count += 1
		

func get_all_zones():
	return get_children()

func connect_all_zones():
	for i in get_all_zones():
		i.connect_signals_all()
		i.entered_zone.connect(_on_zone_entered)
		i.exited_zone.connect(_on_zone_exited)

#func populate_connections():
	#pass

#TODO: Parkour towards zone most looked at
func _on_zone_entered(id,body):
	statuses[id] = true
	if statuses.find(true) != -1:
		if body.parkour_bodies.find(get_parent()) == -1:
			body.parkour_bodies.append(get_parent())
		if !body.is_parkouring:
			body.can_dodge = true
		#body.can_parkour = true

func _on_zone_exited(id,body):
	statuses[id] = false
	if statuses.find(true) == -1:
		#body.can_parkour = false
		if body.parkour_bodies.find(get_parent()) != -1:
			body.parkour_bodies.erase(get_parent())
