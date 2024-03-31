extends Sprite2D
@onready var warrior_enemy = $"../WarriorEnemy"

var health = 100
var turn_speed = 70
var damage = 20
var defense = 10
var crit_chance = 25
var dodge_chance = 25
var skip = false
var is_defending = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func execute_turn():
	print("mage enemy move")
	
func truth_chance(percent):
	var random_value = randf()
	return random_value <= percent/100
	
func team_heal():
	health += 10
	warrior_enemy.health += 10
	
func attack(enemy):
	if enemy.is_defending:
		enemy.health -= enemy.damage_taken(damage) * .75
		enemy.is_defending = false
	else:
		enemy.health -= enemy.damage_taken(damage)
	
	# TODO: if damage taken = 0, output "dodged!"
		
func damage_taken(damage):
	var mitigated_damage = damage * (1 - defense / 100)

	if truth_chance(dodge_chance):
		mitigated_damage = 0  # Dodge occurred, so damage is completely mitigated
	elif truth_chance(crit_chance):
		mitigated_damage *= 2  # Critical hit occurred, so double the damage

	return mitigated_damage

