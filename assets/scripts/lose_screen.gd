class_name losescreen
extends Control

@onready var play_again_button = $MarginContainer/HBoxContainer/VBoxContainer/Play_Again as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button

@onready var start_level = preload("res://scenes/user_interfaces/main_menu.tscn")

func _ready():
	play_again_button.button_down.connect(on_play_again_pressed)
	exit_button.button_down.connect(on_quit_pressed)
	
func on_play_again_pressed() -> void:
	get_tree().change_scene_to_packed(start_level)
	
func on_quit_pressed() -> void:
	get_tree().quit()

