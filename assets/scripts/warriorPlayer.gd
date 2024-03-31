extends Sprite2D

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

func damage():
	health -= 25
	if health < 0:
		health = FullHP
	setHealthBar()

func process():
	pass
