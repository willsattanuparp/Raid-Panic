class_name Level extends Node2D

signal finish()

func on_finish():
	finish.emit()

func load_player_weapon():
	pass


func _on_finish_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		pass
		#if player retrieved doc return
		#else say doc not retrieved
