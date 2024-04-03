extends Sprite2D

@onready var warrior_player = $"../WarriorPlayer"
@onready var buttons = $Buttons
@onready var notification = $"../PlayerNotification"

const FullHP = 100
var health = FullHP

var turn_speed = 15
var damage = 10
var defense = 10
var crit_chance = 10
var dodge_chance = 10

var chosen_move = 0
var target = null

var charName = "Ally Mage"
var output = []

var is_selecting_target = false
var is_dead = false
var is_animating = false
var is_turn_started = false
var is_turn_done = false
var is_defending = false


func _ready():
	$AnimationPlayer.play("Idle")
	notification.text = ""
	$HealthBar.max_value = FullHP
	setHealthBar()


func setHealthBar() -> void:
	$HealthBar.value = health


func execute_turn():
	notification.text = "Mage player's turn!"
	is_turn_started = true


func heal_ally():
	warrior_player.health += 15
	setHealthBar()
	output.append("Ally mage healed Ally Warrior!")


func life_steal(enemy):
	var mitigated_damage = enemy.damage_taken(damage)
	output.append("Ally mage attacked %s with life steal!" % str(enemy.charName))

	if enemy.is_defending:
		enemy.health -= mitigated_damage * .25
		enemy.is_defending = false
	else:
		enemy.health -= mitigated_damage

	setHealthBar()

	if mitigated_damage == 0:
		output.append("But %s dodged the attack!" % str(enemy.charName))
	else:
		health += 10
		enemy.animate_atk()


func freeze(enemy):
	enemy.turn_speed -= 10
	output.append("Enemy %s is freezing! Speed went down to %s." % [str(enemy.charName), str(enemy.turn_speed)])
	
	if truth_chance(100):
		enemy.skip = true
		output.append("%s is frozen and can't move!" % str(enemy.charName))
	setHealthBar()


func truth_chance(percent):
	var random_value = randf()
	return random_value <= percent/100


func damage_taken(damage):
	var mitigated_damage = damage * (1 - defense / 100)

	if truth_chance(dodge_chance):
		mitigated_damage = 0  # Dodge occurred, so damage is completely mitigated
	elif truth_chance(crit_chance):
		mitigated_damage *= 2  # Critical hit occurred, so double the damage

	return mitigated_damage


func _on_heal_pressed():
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
	notification.text = "Click on an Enemy to life steal!!"
	chosen_move = 1
	# select an enemy target
	is_selecting_target = true


func _on_freeze_pressed():
	notification.text = "Click on an Enemy to freeze!!"
	chosen_move = 2
	# select an enemy target
	is_selecting_target = true


func animate():
	$AnimationPlayer.play("Attack")


func animate_atk():
	if health <= 0:
		$AnimationPlayer.play("Dies")
		is_dead = true
	else:
		$AnimationPlayer.play("Damaged")

func idle():
		$AnimationPlayer.play("Idle")
		
func dead():
		$AnimationPlayer.play("Dead")
		health = 0
		setHealthBar()

func reset():
	is_turn_started = false
	is_turn_done = false
	is_defending = false
	is_selecting_target = false
	target = null
	output = []
	is_animating = false
