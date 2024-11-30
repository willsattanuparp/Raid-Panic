extends Area2D

var collection_speed = 1
var collection_acc = 1

var player_body
var magnet = false

@export var document_value = 1
@export var singular = false
@export var ejection_direction: Vector2
@export var ejection_speed: int = 20

@onready var magnet_area = $MagnetArea
var eject: bool = false

func _ready() -> void:
	if singular:
		$Documents.hide()
		$DocTypes.get_child(randi_range(0,$DocTypes.get_child_count()-1)).show()

func _on_magnet_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#print("magnet")
		magnet = true
		player_body = body


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.documents += document_value
		if !singular:
			body.main_doc_collected = true
		queue_free()

func _physics_process(_delta: float) -> void:
	if magnet and player_body != null:
		global_position += global_position.direction_to(player_body.global_position) * collection_speed
		collection_speed += collection_acc
	if eject:
		global_position += ejection_direction * ejection_speed

func eject_document():
	if ejection_direction == Vector2.ZERO:
		ejection_direction = Vector2(randf_range(-1,1),randf_range(-1,1)).normalized()
	$EjectionTimer.start()
	eject = true

func _on_ejection_timer_timeout() -> void:
	monitoring = true
	$MagnetArea.monitoring = true
	eject = false
