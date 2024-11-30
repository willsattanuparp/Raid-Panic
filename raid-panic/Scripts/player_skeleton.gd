extends Node2D

func punch():
	$AnimationPlayer.play("Punch")
func walk():
	$AnimationPlayer.play("Walk")

func is_walking():
	return ($AnimationPlayer.is_playing() and $AnimationPlayer.current_animation == "Walk")
func is_punching():
	return ($AnimationPlayer.is_playing() and $AnimationPlayer.current_animation == "Punch")

func stop_anim():
	$AnimationPlayer.stop()

func is_playing():
	return $AnimationPlayer.is_playing()
#
#func tweak_arm():
	#$"Skeleton2D/Torso/R Arm TOP/R Arm BOT".position = Vector2(252,-16)

func reset():
	$AnimationPlayer.play("RESET")

func _ready() -> void:
	reset()
