class_name Level extends Node2D

signal finish()

#@onready var fade_in_tween = get_tree().create_tween()

@export var level = -1

var main_doc_collected = false
var documents_collected = 0


@export var time_gold: float
@export var time_silver: float
@export var time_bronze: float
@export var time_author: float

var score_gold: int = 8000
var score_silver: int = 4000
var score_bronze: int = 1000
var score_author: int = 16000

var time_rank_time = ""
var time_score = 0
var time_bonus_multiplier = 50
var document_bonus_multiplier = 400
var combo_bonus_multiplier = 2
var combo_bonus_max = 1999
var times_detected = 0
var detected_multiplier = -100

var final_score = 0

@onready var current_high_score = Global.high_scores[level - 1]

func _ready() -> void:
	$Camera2D/GameMusic.volume_db = Global.music_level - 80
	$PaperSound/PaperSound.volume_db = Global.fx_sound_level - 80
	fade_in()
	Global.fade_menu_music()

func on_finish():
	$ScoringNode.run_timer = false
	$ScoringNode._on_player_combo_broken()
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


func calculate_time_rank():
	if $ScoringNode.time_elapsed < time_author:
		time_rank_time = str(time_author)
		return "Author"
	if $ScoringNode.time_elapsed < time_gold:
		time_rank_time = str(time_gold)
		return "Gold"
	if $ScoringNode.time_elapsed < time_silver:
		time_rank_time = str(time_silver)
		return "Silver"
	if $ScoringNode.time_elapsed < time_bronze:
		time_rank_time = str(time_bronze)
		return "Bronze"
	time_rank_time = "N/A"
	return "Plastic"

func calculate_time_bonus():
	var time_bonus = 0
	if $ScoringNode.time_elapsed < time_author:
		time_score = score_author
		time_bonus = time_author - $ScoringNode.time_elapsed
	if $ScoringNode.time_elapsed < time_gold:
		time_score = score_gold
		time_bonus = time_gold - $ScoringNode.time_elapsed
	if $ScoringNode.time_elapsed < time_silver:
		time_score = score_silver
		time_bonus = time_silver - $ScoringNode.time_elapsed
	if $ScoringNode.time_elapsed < time_bronze:
		time_score = score_bronze
		time_bonus = time_bronze - $ScoringNode.time_elapsed
	return time_bonus


func _on_fade_out():
	print("Finished")
	var time_rank = calculate_time_rank()
	var final_time_bonus = snapped(calculate_time_bonus(),.01)
	var combo_score = $ScoringNode.calculate_score()
	$UI/FinalScoreHud/TimeRank.text = "Time Rank: " + time_rank + " = " + str(time_score)
	$UI/FinalScoreHud/TimeBonus.text = "Time below " + time_rank + "(" + time_rank_time + ")" + ":" + str(final_time_bonus) + " x " + str(time_bonus_multiplier) + " = " + str(final_time_bonus * time_bonus_multiplier)
	var combo_bonus_squeezed = combo_score * combo_bonus_multiplier
	if combo_bonus_squeezed > combo_bonus_max:
		combo_bonus_squeezed = combo_bonus_max
	$UI/FinalScoreHud/ComboScoreLabel.text = "Combo Score (max 1999): " + str(combo_score) + " x " + str(combo_bonus_multiplier) + " = " + str(combo_bonus_squeezed)
	$UI/FinalScoreHud/DocumentsCollected.text = "Documents Collected: " + str(documents_collected) + " x " + str(document_bonus_multiplier) + " = " + str(documents_collected * document_bonus_multiplier)
	$UI/TopRightHUD/TimesDetected.text = "Times Detected: " + str(times_detected) + " x " + str(detected_multiplier) + " = " + str(times_detected * detected_multiplier)
	final_score = time_score + (final_time_bonus * time_bonus_multiplier) + (combo_bonus_squeezed) + (documents_collected * document_bonus_multiplier) - (times_detected * detected_multiplier)
	$UI/FinalScoreHud/FinalScore.text = "Final Score: " + str(final_score)
	$Timers/FinalScoreTimer.start()
	await $Timers/FinalScoreTimer.timeout
	$UI/FinalScoreHud/TimeRank.show()
	$Timers/FinalScoreTimer.start()
	await $Timers/FinalScoreTimer.timeout
	$UI/FinalScoreHud/TimeBonus.show()
	$Timers/FinalScoreTimer.start()
	await $Timers/FinalScoreTimer.timeout
	$UI/FinalScoreHud/ComboScoreLabel.show()
	$Timers/FinalScoreTimer.start()
	await $Timers/FinalScoreTimer.timeout
	$UI/FinalScoreHud/DocumentsCollected.show()
	$Timers/FinalScoreTimer.start()
	await $Timers/FinalScoreTimer.timeout
	$UI/TopRightHUD/TimesDetected.show()
	$Timers/FinalScoreTimer.start()
	await $Timers/FinalScoreTimer.timeout
	$UI/FinalScoreHud/FinalScore.show()
	$Timers/FinalScoreTimer.start()
	await $Timers/FinalScoreTimer.timeout
	if final_score > current_high_score:
		Global.high_scores[level-1] = final_score
		Global.save_score()
		$UI/FinalScoreHud/NewHighScore.show()
		$Timers/FinalScoreTimer.start()
		await $Timers/FinalScoreTimer.timeout
	$UI/FinalScoreHud/ContinueButton.show()

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
	if body.is_in_group("Player") and $ScoringNode.run_timer == false and !main_doc_collected:
		$ScoringNode.run_timer = true


func _on_player_main_doc(value) -> void:
	if value == true:
		main_doc_collected = true
		$UI/TopRightHUD/MainDoc.show()


func _on_player_total_documents(value) -> void:
	$PaperSound/PaperSound.play()
	$UI/TopRightHUD/Documents.text = "Documents Collected: " + str(value)
	documents_collected = value


func _on_scoring_node_score_str(move_name: Variant) -> void:
	var m_str = ""
	if $UI/TopRightHUD/Combo.text != "":
		m_str += " + "
	m_str += move_name
	$UI/TopRightHUD/Combo.text += m_str


func _on_scoring_node_clear_combo() -> void:
	$UI/TopRightHUD/Combo.text = "Combo Broken!"


func _on_continue_button_pressed() -> void:
	finish.emit(final_score)
	get_tree().change_scene_to_file("res://Scenes/MenuScenes/level_select.tscn")


func _on_player_detected_number(value) -> void:
	$UI/TopRightHUD/TimesDetected.text = "Times Detected: " + str(value)
	times_detected = value
