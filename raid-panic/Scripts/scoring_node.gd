extends Node2D

#Scoring based on time spent, fluidity, documents gathered (theres a main doc to get but the more you get the better) penalty for alarms tripped
var score = 0
var documents_gathered = 0

var time_elapsed = 0
var run_timer = false

var all_combos = []
var combo = []
var parkour_ids = []

func _process(delta: float) -> void:
	if run_timer:
		time_elapsed += delta

func calculate_score():
	var score = 0
	for _combo in all_combos:
		var combo_score = 1
		for _move in _combo[0]:
			match _move:
				Global.MOVEMENT.ROLL:
					combo_score *= 1
				Global.MOVEMENT.HANG:
					combo_score *= 2
				Global.MOVEMENT.HANGEXIT:
					combo_score *= 2
				Global.MOVEMENT.PARKOUR:
					combo_score *= 3
					var move_id = _combo[1].pop_front()
		score += combo_score
	return score


func _on_player_combo_broken() -> void:
	print("combo broken")
	all_combos.append([combo,parkour_ids])
	combo = []
	parkour_ids = []


func _on_player_move_score(amount: Variant) -> void:
	print("move: " + str(amount))
	combo.append(amount)


func _on_player_body_parkoured(id: Variant) -> void:
	parkour_ids.append(id)
