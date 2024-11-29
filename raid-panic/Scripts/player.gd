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
#threshold of looking at a parkourable component before parkouring
var look_at_parkour_threshold = .3

@export var speed: float = 600
var initial_speed: float
var acceleration = 4000
var deceleration = 4000

var dodge_speed = speed * 2

var on_fire: bool = false


#TODO: The parkour does not currently allow for the player to be in multiple areas - change this to an array - done
#var can_parkour = false
var parkour_bodies: Array[GameObject] = []
var distance_to_parkour = 0
var direction_to_parkour = Vector2.ZERO
var parkour_speed_per_unit = .0008

var in_combo = false
var is_hanging = false
#var was_hanging = false
#var off_wall = true
var is_colliding = false
var last_collision_location = null
var is_parkouring = false

signal move_score(amount)
signal body_parkoured(id)
signal combo_broken()

var skeleton
var current_skeleton

var documents = 0
var main_doc_collected = false

var color_modifiers: Dictionary = {
	"Default":Color.WHITE,
	"Frozen":Color.LIGHT_SKY_BLUE
}

func _ready():
	initial_speed = speed
	skeleton = $PlayerSkeleton.duplicate()
	current_skeleton = $PlayerSkeleton

func _physics_process(delta):
	#rotate to the mouse position
	look_at(get_global_mouse_position())
	#movement
	if can_direction:
		is_dodging = false
		var input = Input.get_vector("Left","Right","Up","Down")
		#play_directional_walk(input)
		#for scoring, start scoring timer
		if $Timers/NotParkouringTimer.is_stopped():
			$Timers/NotParkouringTimer.start()
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
			# Accelerate in the direction of input
			velocity = velocity.move_toward(direction * speed, acceleration * delta)
			#print(velocity)
		else:
			# Decelerate smoothly when no input is detected
			velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	else:
		velocity = (direction * speed) # + knockback
	
	#sticking to wall logic - if no longer moving its not going to be triggered
	if velocity == Vector2.ZERO:
		if current_skeleton != null and current_skeleton.is_walking():
			current_skeleton.stop_anim()
		is_dodging = false
		
		if !is_parkouring:
			can_dodge = true
		if !is_hanging:
			can_direction = true
	else:
		if current_skeleton != null and !current_skeleton.is_walking() and !current_skeleton.is_punching():
			current_skeleton.walk()
	if move_and_slide():
		#print("collision")
		#if hitting an object stop movement
		direction = Vector2.ZERO
		velocity = Vector2.ZERO
		#detect collision location so movement is away from collision
		last_collision_location = get_last_slide_collision().get_position()
		#if dodging into a wall enter hanging
		if get_last_slide_collision().get_collider().is_in_group("Wall") and is_dodging:# and off_wall:
			#off_wall = false
			#last_collision_location = get_last_slide_collision().get_position()
			print(last_collision_location)
			enter_hanging()
	#was running into issues with the collision bouncing off and entering a locked condition of can dodge and is hanging but null collision
	elif can_direction:
		last_collision_location = null
	#else:
		#last_collision_location = null
	#elif was_hanging:
		#off_wall = true
		#was_hanging = false
	#knockback = lerp(knockback,Vector2.ZERO,0.1)
	#Globals.player_pos = global_position
	#dampening
	velocity *= 0.95
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
	if Input.is_action_just_pressed("Dodge"):
		in_combo = true
		#if dodging stop the scoring timer
		if !$Timers/NotParkouringTimer.is_stopped():
			$Timers/NotParkouringTimer.stop()
		if can_dodge and !is_hanging:
			#print("can dodge")
			#conditional is either no collision or facing away
			dodge((last_collision_location == null) or (last_collision_location - global_position).dot(get_global_mouse_position() - global_position) < 0)
		elif is_hanging and last_collision_location != null and (last_collision_location - global_position).dot(get_global_mouse_position() - global_position) < 0:
			#print((last_collision_location - global_position).normalized().dot((get_global_mouse_position() - global_position).normalized()))
			exit_hanging((get_global_mouse_position() - global_position).normalized())
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
	#scoring timer if stopped
	if $AnimationPlayer.is_playing():
		$AnimationPlayer.stop()
	move_score.emit(Global.MOVEMENT.HANG)
	if $Timers/NotParkouringTimer.is_stopped():
		$Timers/NotParkouringTimer.start()
	#print("entering hanging")
	can_direction = false
	direction = Vector2.ZERO
	is_dodging = false
	#can_dodge = false
	$PlayerSkeleton.hide()
	$MrHoldYaWalls.show()
	$"Yves-roll".hide()
	set_collision_mask_value(3,true)
	$Timers/DodgeTimer.stop()
	$Timers/DodgeRecoverTimer.stop()
	$Timers/ParkourTimer.stop()
	$Timers/HangJumpTimer.stop()
	is_hanging = true


func exit_hanging(dir):
	move_score.emit(Global.MOVEMENT.HANGEXIT)
	last_collision_location = null
	#print("exiting hanging")
	#was_hanging = true
	is_hanging = false
	is_dodging = true
	direction = dir
	speed = dodge_speed
	$AnimationPlayer.play("Roll_out_of_wall")
	$Timers/HangJumpTimer.start()

#TODO: Choose which object based on direction and dot matrix - done - this method retrieved the closest parkour body that the player is looking at
func get_attached_parkour_body():
	if !parkour_bodies.is_empty():
		var mouse_direction = (get_global_mouse_position() - global_position).normalized()
		var target = parkour_bodies[0]
		for i in parkour_bodies:
			if (i.global_position - global_position).dot(mouse_direction) > (target.global_position - global_position).dot(mouse_direction):
				target = i
		return target
	return null

func dodge(not_facing_object):
	last_collision_location = null
	#parkour logic
	if get_attached_parkour_body() != null:
		can_dodge = false
		can_direction = false
		var player_facing = (get_global_mouse_position() - global_position).normalized()
		#direction_to_parkour = parkour_body.parkourable.get_parkour_direction(global_position) * -1
		direction_to_parkour = get_attached_parkour_body().parkourable.get_teleport_location(player_facing)
		#print(direction_to_parkour.dot((get_global_mouse_position() - global_position).normalized()))
		if direction_to_parkour.dot(player_facing) > look_at_parkour_threshold:
			#if direction_to_parkour != Vector2.ZERO and parkour_body.parkourable.mode == 0:
			if direction_to_parkour != null:# and parkour_body.parkourable.mode == 0:
				#distance_to_parkour = ((parkour_body.global_position - global_position) * 2 * direction_to_parkour).length()
				#print(distance_to_parkour)
				move_score.emit(Global.MOVEMENT.PARKOUR)
				#$PlayerSkeleton.hide()
				body_parkoured.emit(get_attached_parkour_body().scoring_id)
				var tween = get_tree().create_tween()
				#TODO: since tween time is constant, the parkour speed isnt constant
				print(direction_to_parkour.angle())
				if current_skeleton != null:
					current_skeleton.queue_free()
				$PlayerSlide.show()
				is_parkouring = true
				tween.tween_property(self,"position",global_position + direction_to_parkour,direction_to_parkour.length() * parkour_speed_per_unit)
				tween.finished.connect(_on_parkour_finish)
				##TODO: connect finished signal to tween - done
				#speed = distance_to_parkour / $Timers/ParkourTimer.wait_time
				#print(speed)
				#direction = direction_to_parkour
				#print(direction)
				#make invulnerable to objects
				set_collision_mask_value(3,false)
				#$Timers/ParkourTimer.start()
				return
	if not_facing_object:
		move_score.emit(Global.MOVEMENT.ROLL)
		can_dodge = false
		can_direction = false
		is_dodging = true
		speed = dodge_speed
		#can_throw = false
		#can_secondary = false
		if direction == Vector2.ZERO:
			direction = (get_global_mouse_position() - global_position).normalized()
			#direction = last_direction
	#	add_to_group("Invulnerable")
		#$AnimationPlayer.play("forward_roll")
		$AnimationPlayer.play("Roll")
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

func _on_parkour_finish():
	is_parkouring = false
	var skel = skeleton.duplicate()
	#skel.name = "PlayerSkeleton"
	current_skeleton = skel
	add_child(skel)
	$PlayerSlide.hide()
	speed = initial_speed
	can_direction = true
	can_dodge = true
	set_collision_mask_value(3,true)
	$Timers/DodgeRecoverTimer.start()
	print("parkour_finish")

func _on_dodge_timer_timeout():
	speed = initial_speed
	can_direction = true
	direction = Vector2.ZERO
	#is_dodging = false
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
	#print("dodge recover")
	if !is_parkouring:
		can_dodge = true


func _on_parkour_timer_timeout() -> void:
	#print("done parkouring")
	speed = initial_speed
	can_direction = true
	if !is_parkouring:
		can_dodge = true
	set_collision_mask_value(3,true)
	$Timers/DodgeRecoverTimer.start()
	


func _on_hang_jump_timer_timeout() -> void:
	speed = initial_speed
	can_direction = true
	#is_dodging = false
	$Timers/DodgeRecoverTimer.start()

#fires if not moving for x seconds
func _on_not_parkouring_timer_timeout() -> void:
	if in_combo:
		combo_broken.emit()
	in_combo = false
