class_name Weapon extends Node2D

@export var dmg = 75

var to_break = []
var to_open = []

#signal hit(dmg)
var punch_noise

func _ready() -> void:
	for i in $PunchSounds.get_children():
		i.volume_db = Global.fx_sound_level - 80

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("Hit") and !get_parent().get_parent().get_node("PlayerSkeleton").is_punching():
		get_parent().get_parent().get_node("PlayerSkeleton").punch()
		if $HitTimer.is_stopped():
			$HitTimer.start()

func deal_dmg(i: GameObject):
	i.breakable.deal_damage(dmg)

func open(i: GameObject):
	i.open(get_parent().get_parent().global_position.direction_to(i.global_position))

func _on_weapon_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Breakable"):
		to_break.append(body)
		#print(to_break)
	if body.is_in_group("Door"):
		to_open.append(body)


func _on_weapon_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Breakable"):
		to_break.erase(body)
	if body.is_in_group("Door"):
		to_open.erase(body)


func _on_hit_timer_timeout() -> void:
	punch_noise = $PunchSounds.get_child(randi_range(0,1))
	punch_noise.play()
	$SoundTimer.start()
	for i in to_break:
		if i.is_in_group("Breakable"):
			deal_dmg(i)
	for i in to_open:
		if i.is_in_group("Door"):
			open(i)


func _on_sound_timer_timeout() -> void:
	punch_noise.stop()
