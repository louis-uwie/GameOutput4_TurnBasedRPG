extends Sprite2D
@onready var warrior_enemy = $"../WarriorEnemy"
@onready var notification = $"../PlayerNotif"

var health = 100
var turn_speed = 70
var damage = 20
var defense = 10
var crit_chance = 25
var dodge_chance = 25
var skip = false
var is_defending = false

func _ready():
	$AnimationPlayer.play("Idle")

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
	
	if enemy.damage_taken(damage) == 0:
		notification.text = "Enemy Dodged!"
	# TODO: if damage taken = 0, output "dodged!"

func damage_taken(damage):
	var mitigated_damage = damage * (1 - defense / 100)

	if truth_chance(dodge_chance):
		mitigated_damage = 0  # Dodge occurred, so damage is completely mitigated
		notification.text = "Player Dodged!"
	elif truth_chance(crit_chance):
		mitigated_damage *= 2  # Critical hit occurred, so double the damage
		notification.text = "Critical!"

	return mitigated_damage
