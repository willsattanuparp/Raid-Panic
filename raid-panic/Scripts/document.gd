extends Area2D

var collection_speed = 1
var collection_acc = 1

var player_body
var magnet = false

@export var document_value = 1
@export var singular = false

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
		queue_free()

func _physics_process(delta: float) -> void:
	if magnet and player_body != null:
		global_position += global_position.direction_to(player_body.global_position) * collection_speed
		collection_speed += collection_acc
