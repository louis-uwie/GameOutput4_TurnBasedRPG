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
var charName = "Ally Warrior"
var output = []
var is_animating = false

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
	var mitigated_damage = enemy.damage_taken(damage)
	output.append("Ally warrior attacked %s!" % str(enemy.charName))
	
	if enemy.is_defending:
		enemy.health -= mitigated_damage * .25
		enemy.is_defending = false
	else:
		enemy.health -= mitigated_damage
	
	setHealthBar()

	if mitigated_damage == 0:
		output.append("But %s dodged the attack!" % str(enemy.charName))
	else:
		enemy.animate_atk()

func defend():
	is_defending = true
	output.append("Ally warrior defended!")
	print("defending")
	setHealthBar()

func damage_taken(damage):
	var mitigated_damage = damage * (1 - defense / 100)

	if truth_chance(dodge_chance):
		mitigated_damage = 0  # Dodge occurred, so damage is completely mitigated
	elif truth_chance(crit_chance):
		mitigated_damage *= 2  # Critical hit occurred, so double the damage
	setHealthBar()
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
	notification.text = "Click on an enemy to slash!!"
	chosen_move = 0
	is_selecting_target = true
	

func _on_defend_pressed():
	chosen_move = 1
	finish_turn()
	
func reset():
	is_turn_started = false
	is_turn_done = false
	is_defending = false
	is_selecting_target = false
	target = null
	output = []
	is_animating = false
	
func animate():
	$AnimationPlayer.play("Attack")
	
func animate_atk():
	if health <= 0:
		$AnimationPlayer.play("Dies")
	else:
		$AnimationPlayer.play("Damaged")
