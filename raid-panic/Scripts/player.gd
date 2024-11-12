class_name Player extends CharacterBody2D

#var can_throw: bool = true
#var is_reloading: bool = false
#var can_secondary: bool = true
var can_dodge: bool = true
var can_direction: bool = true
var is_dodging = false
var direction: Vector2 = Vector2.ZERO
var last_direction: Vector2 = Vector2.RIGHT
var diagonal: Vector2 = Vector2.RIGHT
var direction_timer: float = .1

#var knockback: Vector2 = Vector2.ZERO


@export var speed: float = 400
var initial_speed: float

var dodge_speed = speed * 1.5

var on_fire: bool = false

var can_parkour = false
var parkour_body: GameObject = null
var distance_to_parkour = 0
var direction_to_parkour = 0

var is_hanging = false

var color_modifiers: Dictionary = {
	"Default":Color.WHITE,
	"Frozen":Color.LIGHT_SKY_BLUE
}

func _ready():
	initial_speed = speed

func _physics_process(delta):
	#rotate to the mouse position
	look_at(get_global_mouse_position())
	#movement
	if can_direction:
		var input = Input.get_vector("Left","Right","Up","Down")
		#play_directional_walk(input)
		#Input buffer diagonal
		if input == Vector2(-1,-1).normalized() or input == Vector2(1,-1).normalized() or input == Vector2(-1,1).normalized() or input == Vector2(1,1).normalized():
			direction_timer = .1
			diagonal = input
		if direction_timer > 0  and ((
			diagonal == Vector2(-1,-1).normalized() and (input == Vector2(-1,0) or input == Vector2(0,-1))) or (
				diagonal == Vector2(1,-1).normalized() and (input == Vector2(1,0) or input == Vector2(0,-1))) or (
					diagonal == Vector2(-1,1).normalized() and (input == Vector2(-1,0) or input == Vector2(0,1))) or (
						diagonal == Vector2(1,1).normalized() and (input == Vector2(1,0) or input == Vector2(0,1)))):
			direction = diagonal
#			print(direction_timer)
		else:
			direction = input
		direction_timer -= delta
		if direction != Vector2.ZERO:
			last_direction = direction
#	print(direction)
	velocity = (direction * speed) # + knockback
	if move_and_slide():
		#if dodging into a wall enter hanging
		if get_last_slide_collision().get_collider().is_in_group("Wall") and is_dodging:
			print("entering hanging")
			enter_hanging()
	#knockback = lerp(knockback,Vector2.ZERO,0.1)
	#Globals.player_pos = global_position
	
	##weapons
	#if Input.is_action_pressed("shoot") and can_throw and not is_reloading:
		#can_throw = false
		#$Timers/ThrowTimer.start()
		##throw_bounce_item()
		#
	#if Input.is_action_pressed("secondary") and can_secondary:
		#can_secondary = false
		#$Timers/SecondaryTimer.start()
		##side_weapon.slash()
	if is_hanging and Input.is_action_pressed("Hit"):
		exit_hanging((get_global_mouse_position() - global_position).normalized())
	if Input.is_action_pressed("Dodge") and can_dodge:
		dodge()
#
#func play_directional_walk(dir: Vector2):
	#if dir.x != 0:
		#$AnimationPlayer.play("side_walk")
		#if dir.x < 0:
			#$BounceNode/EntitySprite.flip_h = true
		#else:
			#$BounceNode/EntitySprite.flip_h = false
	#elif dir.y > 0:
		#$AnimationPlayer.play("forward_walk")
	#elif dir.y < 0:
		#$AnimationPlayer.play("back_walk")
	#elif dir.y == 0:
		#$AnimationPlayer.stop()

#func _on_slash_hit(body: CollisionObject2D):
	#if body.is_in_group("Enemy") and body.is_hitting_minmax($BounceNode.position.y + side_weapon.get_slash_min_height(), $BounceNode.position.y + side_weapon.get_slash_max_height()):
		#body.knockback = (body.global_position - global_position).normalized() * side_weapon.enemy_push_rate
		#body.hit(side_weapon.damage)
	#elif body.is_in_group("Bouncing Item") and body.is_hitting_minmax($BounceNode.position.y + side_weapon.get_slash_min_height(), $BounceNode.position.y + side_weapon.get_slash_max_height()):
		#body.knockback = (body.global_position - global_position).normalized() * side_weapon.item_push_rate


func enter_hanging():
	can_direction = false
	is_dodging = false
	set_collision_mask_value(3,true)
	$Timers/DodgeTimer.stop()
	$Timers/DodgeRecoverTimer.stop()
	$Timers/ParkourTimer.stop()
	is_hanging = true


func exit_hanging(dir):
	is_hanging = false
	is_dodging = true
	direction = dir
	speed = dodge_speed
	$Timers/DodgeTimer.start()


func dodge():
	can_dodge = false
	can_direction = false
	if can_parkour and parkour_body != null:
		direction_to_parkour = parkour_body.parkourable.get_parkour_direction(global_position) * -1
		distance_to_parkour = ((parkour_body.global_position - global_position) * 2 * direction_to_parkour).length()
		#print(distance_to_parkour)
		speed = distance_to_parkour / $Timers/ParkourTimer.wait_time
		#print(speed)
		direction = direction_to_parkour
		#print(direction)
		#make invulnerable to objects
		set_collision_mask_value(3,false)
		$Timers/ParkourTimer.start()
	else:
		is_dodging = true
		speed = dodge_speed
		#can_throw = false
		#can_secondary = false
		if direction == Vector2.ZERO:
			direction = (get_global_mouse_position() - global_position).normalized()
			#direction = last_direction
	#	add_to_group("Invulnerable")
		#$AnimationPlayer.play("forward_roll")
		$Timers/DodgeTimer.start()
#
#func _on_secondary_timer_timeout():
	#$Timers/SecondaryTimer.stop()
	#can_secondary = true

#
#func _on_reload_timer_timeout():
	#$Timers/ReloadTimer.stop()
	##Globals.current_belt_item = 0
	#is_reloading = false


func _on_dodge_timer_timeout():
	speed = initial_speed
	can_direction = true
	is_dodging = false
	#set_collision_layer_value(1,true)
	#set_collision_layer_value(10,false)
	#set_collision_mask_value(4,true)
	#set_collision_mask_value(8,true)
#	remove_from_group("Invulnerable")
	#$BounceNode/EntitySprite.flip_v = false
	#if $Timers/ReloadTimer.is_stopped():
		#can_throw = true
	#if $Timers/SecondaryTimer.is_stopped():
		#can_secondary = true
	$Timers/DodgeRecoverTimer.start()



func _on_dodge_recover_timer_timeout():
	can_dodge = true


func _on_parkour_timer_timeout() -> void:
	print("done parkouring")
	speed = initial_speed
	can_direction = true
	set_collision_mask_value(3,true)
	$Timers/DodgeRecoverTimer.start()
	
