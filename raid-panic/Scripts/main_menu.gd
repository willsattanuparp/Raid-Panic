extends Control

@export var level_select_scene: PackedScene
@export var options_scene: PackedScene
@export var tutorial_scene: PackedScene

func _ready() -> void:
	Global.read_score()

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(level_select_scene)


func _on_options_pressed() -> void:
	get_tree().change_scene_to_packed(options_scene)

"res://Scenes/MenuScenes/main_menu.tscn"
func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_how_to_play_pressed() -> void:
	$HowToPlay.show()
