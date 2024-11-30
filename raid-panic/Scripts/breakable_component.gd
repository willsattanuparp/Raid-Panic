class_name BreakableComponent extends Node2D

@export var health = 1

var documents_contained = 0
var required_document = false
@export var documents : Node2D


func _ready() -> void:
	$HealthBar.max_value = health
	$HealthBar.value = health
	if documents != null:
		for i in documents.get_children():
			i.monitoring = false
			i.magnet_area.monitoring = false
			i.hide()


func deal_damage(damage):
	health -= damage
	$HealthBar.value = health
	#print(health)
	if health <= 0:
		destroy()

func set_bar_position(pos):
	$HealthBar.pos = pos

#TODO: make this more animated
func destroy():
	var break_sound = $BreakSounds.get_child(randi_range(0,3))
	break_sound.play()
	if documents != null:
		for i in documents.get_children():
			i.show()
			i.eject_document()
	get_parent().delete()
