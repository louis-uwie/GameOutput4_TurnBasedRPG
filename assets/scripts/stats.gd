class_name stats
extends Control

@onready var finish_button = $TextureRect/FinishButton as Button
@onready var start_level = preload("res://scenes/world.tscn")

func _ready():
	finish_button.button_down.connect(on_finish_pressed)
	
func on_finish_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
	

