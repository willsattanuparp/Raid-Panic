extends MarginContainer


func _ready() -> void:
	queue_redraw()


func _on_exit_button_pressed() -> void:
	hide()
