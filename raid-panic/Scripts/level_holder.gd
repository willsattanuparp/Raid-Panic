class_name LevelHolder extends Node2D

@export var level_scene: PackedScene
@export var level: int
@export var photo: Sprite2D
@export var level_name: String
@export var author_time: String
@export var gold_time: String
@export var silver_time: String
@export var bronze_time: String

@onready var init_pos = position
@onready var init_rot = rotation

@onready var high_score = Global.high_scores[level - 1]

signal play_level(lvl)

func _ready() -> void:
	$HighScore.text = "High Score: " + str(high_score)
	$LevelName.text = level_name
	$Photo.texture = photo.texture
	$AuthorTime.text += author_time
	$GoldTime.text += gold_time
	$SilverTime.text += silver_time
	$BronzeTime.text += bronze_time

func _on_raid_pressed() -> void:
	play_level.emit(level)
