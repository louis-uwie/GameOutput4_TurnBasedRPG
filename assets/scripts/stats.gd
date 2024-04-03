extends Control

@onready var finish_button = $TextureRect/CanvasLayer/FinishButton as Button
@onready var start = preload("res://scenes/world.tscn")
@onready var stats = $"."

@onready var skill_points = $MarginContainer/VBoxContainer/Label/SkillPoints
@onready var texture_rect = $TextureRect
@onready var margin_container = $MarginContainer
@onready var canvas_layer = $TextureRect/CanvasLayer

@onready var spdlabel = $TextureRect/CanvasLayer/spdlabel
@onready var attlabel = $TextureRect/CanvasLayer/attlabel
@onready var deflabel = $TextureRect/CanvasLayer/deflabel
@onready var critlabel = $TextureRect/CanvasLayer/critlabel
@onready var dodgelabel = $TextureRect/CanvasLayer/dodgelabel

@onready var warrior_player = $"../WarriorPlayer"
@onready var mage_player = $"../MagePlayer"


var skillPoints = 100

var speedMulti = 0
var attackMulti = 0
var defenseMulti = 0
var critMulti = 0
var dodgeMulti = 0 

func _ready():
	finish_button.button_down.connect(on_finish_pressed)
	
	spdlabel.text = "Speed:   %s" % str(speedMulti)
	attlabel.text = "Attack:   %s" % str(attackMulti)
	deflabel.text = "Defense:   %s" % str(attackMulti)
	critlabel.text = "Crit:    %s" % str(critMulti)
	dodgelabel.text = "Dodge:   %s" % str(dodgeMulti)
	
	skill_points.text = str(skillPoints)

func _process(delta):
	skill_points.text = str(skillPoints)

func on_finish_pressed() -> void:
	
	mage_player.turn_speed = int(speedMulti)
	mage_player.damage = int(attackMulti)
	mage_player.defense = int(defenseMulti)
	mage_player.crit_chance = int(critMulti)
	mage_player.dodge_chance = int(dodgeMulti)
	print(mage_player.defense)
	
	warrior_player.turn_speed = int(speedMulti)
	warrior_player.damage = int(attackMulti)
	warrior_player.defense = int(defenseMulti)
	warrior_player.crit_chance = int(critMulti)
	warrior_player.dodge_chance = int(dodgeMulti)
	print(mage_player.turn_speed)

	for i in range(stats.get_child_count()):
		stats.get_child(i).visible = false
		margin_container.visible = false
		canvas_layer .visible = false
	
	
func _on_spdup_button_pressed():
	if skillPoints >= 1 and speedMulti < 100:
		skillPoints -= 1
		speedMulti += 1
		spdlabel.text = "Speed:   %s" % str(speedMulti)
	else:
		return

func _on_spddown_button_pressed():
	if skillPoints <= 99 and speedMulti > 0:
		skillPoints += 1
		speedMulti -= 1
		spdlabel.text = "Speed:   %s" % str(speedMulti)
	else:
		return

func _on_attup_button_pressed():
	if skillPoints >= 1 and attackMulti < 100:
		skillPoints -= 1
		attackMulti += 1
		attlabel.text = "Attack:   %s" % str(attackMulti)
	else:
		return

func _on_attdown_button_pressed():
	if skillPoints <= 99 and attackMulti > 0:
		skillPoints += 1
		attackMulti -= 1
		attlabel.text = "Attack:   %s" % str(attackMulti)
	else:
		return

func _on_defup_button_pressed():
	if skillPoints >= 1 and defenseMulti < 100:
		skillPoints -= 1
		defenseMulti += 1
		deflabel.text = "Defense:   %s" % str(defenseMulti)
	else:
		return

func _on_defdown_button_pressed():
	if skillPoints <= 99 and defenseMulti > 0:
		skillPoints += 1
		defenseMulti -= 1
		deflabel.text = "Defense:   %s" % str(defenseMulti)
	else:
		return

func _on_critup_button_pressed():
	if skillPoints >= 1 and critMulti < 100:
		skillPoints -= 1
		critMulti += 1
		critlabel.text = "Crit:    %s" % str(critMulti)
	else:
		return

func _on_critdown_button_pressed():
	if skillPoints <= 99 and critMulti > 0:
		skillPoints += 1
		critMulti -= 1
		critlabel.text = "Crit:    %s" % str(critMulti)
	else:
		return

func _on_dodgeup_button_pressed():
	if skillPoints >= 1 and dodgeMulti < 100:
		skillPoints -= 1
		dodgeMulti += 1
		dodgelabel.text = "Dodge:   %s" % str(dodgeMulti)
	else:
		return

func _on_dodgedown_button_pressed():
	if skillPoints <= 99 and dodgeMulti > 0:
		skillPoints += 1
		dodgeMulti -= 1
		dodgelabel.text = "Dodge:   %s" % str(dodgeMulti)
	else:
		return
