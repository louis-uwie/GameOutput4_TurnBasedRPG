extends Sprite2D
@onready var warrior_player = $"../WarriorPlayer"

var health = 100
var turn_speed = 15
var damage = 10
var defense = 10
var crit_chance = 10
var dodge_chance = 10
var is_turn_started = false
var is_turn_done = false
var is_defending = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func execute_turn():
	is_turn_started = true
	print("mage player move")

func heal_ally():
	warrior_player.health += 15
	
func life_steal(enemy):
	health += 10
	if enemy.is_defending:
		enemy.health -= enemy.damage_taken(damage) * .25
		enemy.is_defending = false
	else:
		enemy.health -= enemy.damage_taken(damage)
	
	# TODO: if damage taken = 0, output "dodged!"
	
func freeze(enemy):
	if truth_chance(15):
		enemy.skip = true
	else:
		enemy.speed -= 10
	
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
