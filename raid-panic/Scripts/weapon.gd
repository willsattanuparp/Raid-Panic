class_name Weapon extends Node2D

@export var dmg = 75

var to_break = []

signal hit(dmg)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Hit"):
		for i in to_break:
			deal_dmg(i)

func deal_dmg(i: GameObject):
	i.breakable.deal_damage(dmg)


func _on_weapon_area_body_entered(body: Node2D) -> void:
	print(body)
	print(body.get_groups())
	if body.is_in_group("Breakable"):
		to_break.append(body)
		print(to_break)


func _on_weapon_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Breakable"):
		to_break.erase(body)
