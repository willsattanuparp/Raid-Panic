class_name Level extends Node2D

signal finish()

#@onready var fade_in_tween = get_tree().create_tween()

func _ready() -> void:
	fade_in()
	Global.fade_menu_music()

func on_finish():
	$ScoringNode.run_timer = false
	fade_out()

func fade_in():
	#var tween = get_tree().create_tween()
	var fade_in_tween = get_tree().create_tween()
	#$Camera2D/Black.modulate.a = 0
	fade_in_tween.tween_property($Camera2D/Black,"modulate:a",0,2)
	fade_in_tween.parallel().tween_property($Camera2D/GameMusic,"volume_db",0,2)
	#await tween.finished
	#$MenuMusic.playing = false

func fade_out():
	var fade_out_tween = get_tree().create_tween()
	fade_out_tween.tween_property($Camera2D/GameMusic,"volume_db",-80,2)
	fade_out_tween.parallel().tween_property($Camera2D/Black,"modulate:a",1,2)
	fade_out_tween.finished.connect(_on_fade_out)
	#fade_out_tween.parallel().tween_property()
	await fade_out_tween.finished
	$Camera2D/GameMusic.playing = false

func _on_fade_out():
	print("Finished")
	$ScoringNode.calculate_score()
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


func _on_finish_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") and $ScoringNode.run_timer == false:
		$ScoringNode.run_timer = true


func _on_player_main_doc(value) -> void:
	if value == true:
		$UI/Container/MainDoc.show()


func _on_player_total_documents(value) -> void:
	$UI/Container/Documents.text = "Documents Collected: " + str(value)
