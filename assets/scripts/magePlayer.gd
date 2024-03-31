extends Sprite2D
@onready var warrior_player = $"../WarriorPlayer"
@onready var buttons = $Buttons
@onready var notification = $"../PlayerNotification"
@onready var world = $".."

const FullHP = 100
var health = FullHP
var isAnimating = false
var turn_speed = 15
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
	notification.text = "Mage player's turn!"
	is_turn_started = true
	print("mage player move")

func heal_ally():
	warrior_player.health += 15
	setHealthBar()
	
func life_steal(enemy):
	$AnimationPlayer.play("Attack")
	
	health += 10
	if enemy.is_defending:
		enemy.health -= enemy.damage_taken(damage) * .25
		enemy.is_defending = false
	else:
		enemy.health -= enemy.damage_taken(damage)
	setHealthBar()
	
	# TODO: if damage taken = 0, output "dodged!"
	
func freeze(enemy):
	
	$AnimationPlayer.play("Attack")
	
	enemy.speed -= 10
	notification.text = "Enemy Slowed! %s" % str(enemy.speed)
	
	if truth_chance(15):
		enemy.skip = true
	setHealthBar()


func truth_chance(percent):
	var random_value = randf()
	return random_value <= percent/100
	
func damage_taken(damage):
	var mitigated_damage = damage * (1 - defense / 100)
	$AnimationPlayer.play("Damaged")

	if truth_chance(dodge_chance):
		world.text = "Enemy dodged!"
		mitigated_damage = 0  # Dodge occurred, so damage is completely mitigated
	elif truth_chance(crit_chance):
		notification.text = "Enemy took a crit!"
		mitigated_damage *= 2  # Critical hit occurred, so double the damage
	elif health >= 0:
		$AnimationPlayer.play("Dies")

	return mitigated_damage

func _on_heal_pressed():
	world.counter += 1
	notification.text = "Healed Ally! Warrior player's turn!"
	$AnimationPlayer.play("Attack")
	
	chosen_move = 0
	finish_turn()


func finish_turn():
	is_turn_done = true
	buttons.visible = false
	is_selecting_target = false
	$AnimationPlayer.play("Idle")


func animate_turn():
	if chosen_move == 0:
		heal_ally()
	if chosen_move == 1:
		life_steal(target)
	if chosen_move == 2:
		freeze(target)

func _on_ls_pressed():
	world.counter += 2
	notification.text = "Click on an Enemy to life steal!!"
	chosen_move = 1
	# select an enemy target
	is_selecting_target = true
	
func _on_freeze_pressed():
	world.counter += 2
	notification.text = "Click on an Enemy to freeze!!"
	chosen_move = 2
	# select an enemy target
	is_selecting_target = true
	
func reset():
	is_turn_started = false
	is_turn_done = false
	is_defending = false
	is_selecting_target = false
	target = null
	
