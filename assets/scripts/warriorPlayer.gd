extends Sprite2D

var health = 150
var turn_speed = 20
var damage = 10
var defense = 10
var crit_chance = 10
var dodge_chance = 10
var is_turn_started = false
var is_turn_done = false
var is_defending = false


const FullHP = 100
var health = FullHP

func _ready():
	$AnimationPlayer.play("Idle")
	$HealthBar.max_value = FullHP
	setHealthBar()

func setHealthBar() -> void:
	$HealthBar.value = health
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		$AnimationPlayer.play("Damaged")
	
func execute_turn():
	is_turn_started = true
	print("warrior player move")
	
func truth_chance(percent):
	var random_value = randf()
	return random_value <= percent/100
	
func attack(enemy):
	if enemy.is_defending:
		enemy.health -= enemy.damage_taken(damage) * .25
		enemy.is_defending = false
	else:
		enemy.health -= enemy.damage_taken(damage)
	
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
