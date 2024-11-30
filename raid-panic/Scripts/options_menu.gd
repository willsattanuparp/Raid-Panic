extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_fx_volume_drag_ended(value_changed: bool) -> void:
	Global.fx_sound_level = $VBoxContainer/FX/FXVolume.value


func _on_music_volume_drag_ended(value_changed: bool) -> void:
	Global.music_level = $VBoxContainer/Music/MusicVolume.value


func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MenuScenes/start_screen.tscn")
