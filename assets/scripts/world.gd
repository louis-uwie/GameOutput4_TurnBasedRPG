extends Node2D

@onready var mage_player = $MagePlayer
@onready var warrior_player = $WarriorPlayer
@onready var warrior_enemy = $WarriorEnemy
@onready var mage_enemy = $MageEnemy

var turn_queue = []
var players_array = []
var turn_index = 0

func _ready():
	players_array.append(mage_player)
	players_array.append(warrior_player)
	turn_queue.append(mage_player)
	turn_queue.append(warrior_player)
	turn_queue.append(warrior_enemy)
	turn_queue.append(mage_enemy)

func _input(event):
	if !event.is_action_pressed("mouse_left"): return
	
	print(players_array[turn_index])
	print(event)
	
	# select move
	if !players_array[turn_index].is_turn_started:
		players_array[turn_index].execute_turn()
		return
	
	if !players_array[turn_index].is_turn_done: return
	
	print("turn is done")
	
	# if all turns done
	if turn_index:
		mage_enemy.execute_turn()
		warrior_enemy.execute_turn()
		
		turn_queue.sort_custom(_compare_speed)
		for turn in turn_queue:
			print("Turn: ", turn, " Speed: ", turn.turn_speed)
			
		# deal effects according to turn queue
		turn_index = 0
		return
	
	turn_index += 1
	
func _compare_speed(a, b):
	return a.turn_speed > b.turn_speed

	
	 
