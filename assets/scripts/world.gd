extends Node2D

@onready var mage_player = $MagePlayer
@onready var warrior_player = $WarriorPlayer
@onready var warrior_enemy = $WarriorEnemy
@onready var mage_enemy = $MageEnemy

var turn_queue = []
var players_array = []
var turn_index = 0
var counter = 0
var dialogues = []

func _ready():
	players_array.append(mage_player)
	players_array.append(warrior_player)
	turn_queue.append(mage_player)
	turn_queue.append(warrior_player)	
	turn_queue.append(warrior_enemy)
	turn_queue.append(mage_enemy)
	$PlayerNotification.text = "Danger Approaches..."
	
	
func _process(delta):
	# select move
	if !players_array[turn_index].is_turn_started:
		players_array[turn_index].execute_turn()
		players_array[turn_index].buttons.visible = true
		return
	
	if !players_array[turn_index].is_turn_done: return
	
	
	# if all turns done
	if turn_index:
		mage_enemy.execute_turn()
		warrior_enemy.execute_turn()
		
		turn_queue.sort_custom(_compare_speed)
		for turn in turn_queue:
			print("Turn: ", turn, " Speed: ", turn.turn_speed)
			
		# deal effects according to turn queue
		# mage_player.animate_turn()

		#if enemy.skip:
			#notification.text = "Enemy Frozen!"
		
		# If all moves have played / animated out
		
		if counter == 0:
			turn_index = 0
			for player in players_array:
				player.reset()
				
		return
	turn_index += 1

func _compare_speed(a, b):
	return a.turn_speed > b.turn_speed


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_left") and players_array[turn_index].is_selecting_target:
		players_array[turn_index].target = warrior_enemy
		players_array[turn_index].finish_turn()


func _on_mage_2d_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_left") and players_array[turn_index].is_selecting_target:
		players_array[turn_index].target = mage_enemy
		players_array[turn_index].finish_turn()

