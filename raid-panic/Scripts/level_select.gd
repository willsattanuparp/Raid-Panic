extends Control

@export var levels: Array[LevelHolder] = []
var selected_level
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selected_level = 0
	$BoxContainer/Level.text = "Level " + str(selected_level + 1)

func _on_forward_pressed() -> void:
	#tween.parallel().tween_property(levels[selected_level],"rotation",0,.3).set_trans(Tween.TRANS_EXPO)
	if selected_level < levels.size()-1:
		var tween = get_tree().create_tween()
		tween.tween_property(levels[selected_level],"position",$FolderEndLocation.position,.5).set_trans(Tween.TRANS_EXPO)
	selected_level += 1
	if selected_level > levels.size() - 1:
		selected_level = levels.size() - 1
	$BoxContainer/Level.text = "Level " + str(selected_level + 1)


func _on_back_pressed() -> void:
	#tween.parallel().tween_property(levels[selected_level],"rotation",levels[selected_level].init_rot,.3).set_trans(Tween.TRANS_EXPO)
	if selected_level > 0:
		var tween = get_tree().create_tween()
		tween.tween_property(levels[selected_level - 1],"position",levels[selected_level].init_pos,.5).set_trans(Tween.TRANS_EXPO)
	selected_level -= 1
	if selected_level < 0:
		selected_level = 0
	$BoxContainer/Level.text = "Level " + str(selected_level + 1)

func load_level():
	get_tree().change_scene_to_packed(levels[selected_level].level_scene)
