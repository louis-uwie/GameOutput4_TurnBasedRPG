extends Sprite2D
@onready var buttons = $Buttons
@onready var notification = $"../PlayerNotification"
@onready var world = $".."

const FullHP = 150
var health = FullHP
var turn_speed = 20
var damage = 10
var defense = 10
var crit_chance = 10
var dodge_chance = 10
var is_turn_started = false
var is_turn_done = false
var is_defending = false
var chosen_move = 0
var is_selecting_target = false
var target = null

func _ready():
	$AnimationPlayer.play("Idle")
	$HealthBar.max_value = FullHP
	setHealthBar()

func setHealthBar() -> void:
	$HealthBar.value = health
	
func execute_turn():
	notification.text = "Warrior player's turn!"
	is_turn_started = true
	print("warrior player move")
	
func truth_chance(percent):
	var random_value = randf()
	return random_value <= percent/100
	
func attack(enemy):
	$AnimationPlayer.play("Attack")
	if enemy.is_defending:
		enemy.health -= enemy.damage_taken(damage) * .25
		enemy.is_defending = false
	else:
		enemy.health -= enemy.damage_taken(damage)
	
	notification.text = "Slashed enemy! %s, %s HP Left" % [str(enemy.charName),str(enemy.health)]
	setHealthBar()
	# TODO: if damage taken = 0, output "dodged!"

func defend():
	is_defending = true

func damage_taken(damage):
	var mitigated_damage = damage * (1 - defense / 100)

	if truth_chance(dodge_chance):
		mitigated_damage = 0  # Dodge occurred, so damage is completely mitigated
	elif truth_chance(crit_chance):
		mitigated_damage *= 2  # Critical hit occurred, so double the damage

	return mitigated_damage
	
func finish_turn():
	is_turn_done = true
	buttons.visible = false
	is_selecting_target = false

func animate_turn():
	if chosen_move == 0:
		attack(target)
	if chosen_move == 1:
		defend()
		
func _on_attack_pressed():
	world.counter += 1
	notification.text = "Click on an enemy to slash!!"
	chosen_move = 0
	is_selecting_target = true
	

func _on_defend_pressed():
	world.counter += 1
	chosen_move = 1
	finish_turn()
	
func reset():
	is_turn_started = false
	is_turn_done = false
	is_defending = false
	is_selecting_target = false
	target = null
