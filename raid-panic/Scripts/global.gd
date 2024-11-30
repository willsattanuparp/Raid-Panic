extends Node2D

enum MOVEMENT {ROLL,HANG,HANGEXIT,PARKOUR}


func fade_menu_music():
	var tween = get_tree().create_tween()
	tween.tween_property($MenuMusic,"volume_db",-80,1)
	await tween.finished
	$MenuMusic.playing = false
	print("Done")
