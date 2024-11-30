class_name AlarmableComponent extends Node2D

var activated = true

var should_move = false
var is_moving = false
var loop = false
var move_rate = .005
var moving_forward = true

@export var curve: Curve2D
@export var shape: PackedVector2Array
@export var pos: Vector2

#signal detected()


#func _physics_process(delta: float) -> void:
	#queue_redraw()

func _ready() -> void:
	if curve != null:
		#if first point pos is last point pos the curve is closed
		if curve.get_point_position(0) == curve.get_point_position(curve.point_count - 1):
			loop = true
		$DetectionPath.curve = curve
		is_moving = true
	if shape != null:
		$DetectionPath/DetectionFollow/DetectionArea/DetectionAreaHitbox.set_polygon(shape)
		$DetectionPath/DetectionFollow/DetectionArea/DetectionAreaHitbox.rotation_degrees = 270
		$DetectionPath/DetectionFollow/DetectionArea/Polygon2D.polygon = shape
		$DetectionPath/DetectionFollow/DetectionArea/Polygon2D.rotation_degrees = 270
		if pos != Vector2.ZERO:
			$DetectionPath/DetectionFollow/DetectionArea.position = pos
		else:
			pos = $DetectionPath/DetectionFollow.position

func activate():
	$DetectionPath/DetectionFollow/DetectionArea.monitoring = true
	if should_move:
		is_moving = true
	activated = true

func deactivate():
	$DetectionPath/DetectionFollow/DetectionArea.monitoring = false
	is_moving = false
	activated = false

func create_detection_zone(size: Vector2):
	var rect = RectangleShape2D.new() as RectangleShape2D
	rect.size = size
	$Path2D/PathFollow2D/DetectionArea/DetectionAreaHitbox.shape = rect

func set_curve(cur: Curve2D,should_loop: bool):
	$DetectionPath.curve = cur
	loop = should_loop

func _physics_process(_delta: float) -> void:
	if is_moving:
		if moving_forward:
			$DetectionPath/DetectionFollow.progress_ratio += move_rate
		else:
			$DetectionPath/DetectionFollow.progress_ratio -= move_rate
		if !loop:
			if $DetectionPath/DetectionFollow.progress_ratio >= 1:
				moving_forward = false
			elif $DetectionPath/DetectionFollow.progress_ratio <= 0:
				moving_forward = true
		pos = $DetectionPath/DetectionFollow.global_position

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.times_detected += 1
		#print("detected")
		#detected.emit()
