class_name Level extends Node2D

signal finish()

func on_finish():
	finish.emit()

#func load_player_weapon():
	#pass


func _on_finish_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if body.main_doc_collected:
			on_finish()
		else:
			print("Doc not collected yet")
		#if player retrieved doc return
		#else say doc not retrieved
