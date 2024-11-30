extends Node2D

enum MOVEMENT {ROLL,HANG,HANGEXIT,PARKOUR}

var high_scores: Array = [0,0,0,0,0]

var fx_sound_level = 80
var music_level = 80 :
	set(value):
		$MenuMusic.volume_db = value - 80

func read_score():
	var file = FileAccess.open("user://SaveFile.json", FileAccess.READ)
	if file == null:
		save_score()
		file = FileAccess.open("user://SaveFile.json", FileAccess.READ)
	var content = file.get_as_text()
	var data = JSON.parse_string(content)
	var json = JSON.new()
	var finish = json.parse_string(content)
	high_scores = finish["high_scores"]

func save_score():
	var file = FileAccess.open("user://SaveFile.json", FileAccess.WRITE)
	var json = JSON.stringify({"high_scores":high_scores})
	file.store_string(json)

func fade_menu_music():
	var tween = get_tree().create_tween()
	tween.tween_property($MenuMusic,"volume_db",-80,1)
	await tween.finished
	$MenuMusic.playing = false
	print("Done")
