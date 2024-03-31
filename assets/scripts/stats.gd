class_name stats
extends Control

@onready var finish_button = $TextureRect/CanvasLayer/FinishButton as Button
@onready var start = preload("res://scenes/world.tscn")

func _ready():
	finish_button.button_down.connect(on_finish_pressed)
	
func on_finish_pressed() -> void:
	get_tree().change_scene_to_packed(start)
	

