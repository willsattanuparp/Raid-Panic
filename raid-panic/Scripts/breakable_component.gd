class_name BreakableComponent extends Node2D

@export var health = 100

func _ready() -> void:
	$HealthBar.max_value = health
	$HealthBar.value = health


func deal_damage(damage):
	health -= damage
	$HealthBar.value = health
	print(health)
	if health <= 0:
		destroy()

func set_bar_position(pos):
	$HealthBar.pos = pos

#TODO: make this more animated
func destroy():
	get_parent().queue_free()
