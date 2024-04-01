extends Sprite2D
@onready var warrior_enemy = $"../WarriorEnemy"
@onready var warrior_player = $"../WarriorPlayer"
@onready var mage_player = $"../MagePlayer"
var is_animating = false
var health = 100
var turn_speed = 70
var damage = 20
var defense = 10
var crit_chance = 25
var dodge_chance = 25
var skip = false
var is_defending = false
var chosen_move = 0
var target = null
var charName = "Orc Mage"
var output = []

func _ready():
	$AnimationPlayer.play("Idle")

func execute_turn():
	target = warrior_player if truth_chance(50) else mage_player
	chosen_move = 0 if truth_chance(50) else 1
		
	
func truth_chance(percent):
	var random_value = randf()
	return random_value <= percent/100
	
func team_heal():
	health += 10
	warrior_enemy.health += 10
	output.append("Orc mage healed their team!")
	
func attack(enemy):
	var mitigated_damage = enemy.damage_taken(damage)
	output.append("Orc mage attacked %s!" % str(enemy.charName))
	
	if enemy.is_defending:
		enemy.health -= mitigated_damage * .75
		enemy.is_defending = false
	else:
		enemy.health -= mitigated_damage
	
	if mitigated_damage == 0:
		output.append("But %s dodged the attack!" % str(enemy.charName))
	else:
		enemy.animate_atk()


func damage_taken(damage):
	var mitigated_damage = damage * (1 - defense / 100)

	if truth_chance(dodge_chance):
		mitigated_damage = 0  # Dodge occurred, so damage is completely mitigated
	elif truth_chance(crit_chance):
		mitigated_damage *= 2  # Critical hit occurred, so double the damage

	return mitigated_damage
	
func animate_turn():
	if chosen_move == 0:
		team_heal()
	if chosen_move == 1:
		attack(target)
		
func reset():
	skip = false
	is_defending = false
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
