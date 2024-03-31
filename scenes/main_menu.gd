class_name mainmenu
extends Control

@onready var start_button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var start_level = preload("res://scenes/world.tscn")

func _ready():
	start_button.button_down.connect(on_play_pressed)
	exit_button.button_down.connect(on_quit_pressed)
	
func on_play_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
	
func on_quit_pressed() -> void:
	get_tree().quit()
