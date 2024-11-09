class_name Weapon extends Node2D

@export var damage = 100


signal hit(dmg)

func deal_dmg():
	hit.emit(damage)
