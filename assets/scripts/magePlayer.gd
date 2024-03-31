extends Sprite2D

const FullHP = 100
var health = FullHP
var isAnimating = false

func _ready():
	$AnimationPlayer.play("Idle")
	$HealthBar.max_value = FullHP
	setHealthBar()

func setHealthBar() -> void:
	$HealthBar.value = health
	
func _input(event: InputEvent) -> void:
	
	isAnimating = true
	if event.is_action_pressed("ui_accept") && isAnimating:
		$AnimationPlayer.play("Damaged")
		print("animating")
		isAnimating = false

func damage():
	health -= 25
	if health < 0:
		health = FullHP
	setHealthBar()

func process():
	pass
