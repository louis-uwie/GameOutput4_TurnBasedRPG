extends Sprite2D
@onready var warrior_player = $"../WarriorPlayer"
@onready var mage_player = $"../MagePlayer"

var health = 200
var turn_speed = 30
var damage = 30
var defense = 20
var crit_chance = 10
var dodge_chance = 10
var skip = false
var is_defending = false
var target = null
var chosen_move = 0
var charName = "Orc Warrior"
var output = []
var is_animating = false

func _ready():
	$AnimationPlayer.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func execute_turn():
	target = warrior_player if truth_chance(50) else mage_player
	chosen_move = 0 if truth_chance(50) else 1

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

func attack(enemy):
	var mitigated_damage = enemy.damage_taken(damage)
	output.append("Orc warrior attacked %s!" % str(enemy.charName))
	
	if enemy.is_defending:
		enemy.health -= mitigated_damage * .75
		enemy.is_defending = false
	else:
		enemy.health -= mitigated_damage
	
	if mitigated_damage == 0:
		output.append("But %s dodged the attack!" % str(enemy.charName))

func defend():
	is_defending = true
	output.append("Orc Warrior is defending itself!")
	
func animate_turn():
	if chosen_move == 0:
		defend()
	if chosen_move == 1:
		attack(target)
		
func reset():
	skip = false
	is_defending = false
	target = null
	output = []
	is_animating = false
