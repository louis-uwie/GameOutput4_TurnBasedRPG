extends Node2D

@onready var mage_player = $MagePlayer
@onready var warrior_player = $WarriorPlayer
@onready var warrior_enemy = $WarriorEnemy
@onready var mage_enemy = $MageEnemy
@onready var player_notification = $PlayerNotification

var turn_queue = []
var players_array = []
var turn_index = 0
var counter = 0
var queue_index = 0

func _ready():
	players_array.append(mage_player)
	players_array.append(warrior_player)
	turn_queue.append(mage_player)
	turn_queue.append(warrior_player)	
	turn_queue.append(warrior_enemy)
	turn_queue.append(mage_enemy)
	
	
func _process(delta):
	if players_array[turn_index].is_dead: turn_index+=1
	
	# select move
	if !players_array[turn_index].is_turn_started and !players_array[turn_index].is_dead:
		players_array[turn_index].execute_turn()
		players_array[turn_index].buttons.visible = true
		return
	
	
	if !players_array[turn_index].is_turn_done: return
	
	
	# if all turns done
	if turn_index:
		mage_enemy.execute_turn()
		warrior_enemy.execute_turn()
		
		turn_queue.sort_custom(_compare_speed)
		#for turn in turn_queue:
			#print("Turn: ", turn, " Speed: ", turn.turn_speed)
		
		if !turn_queue[queue_index].is_animating:
			turn_queue[queue_index].animate_turn()
			turn_queue[queue_index].is_animating = true
			print("Animating")
		

		
		player_notification.text = turn_queue[queue_index].output[counter]
		if Input.is_action_just_pressed("mouse_left"):
			print("Queue Index: ", queue_index)
			print("Counter: ", counter)
			turn_queue[queue_index].animate()
			counter +=1
			
			
		if counter >= turn_queue[queue_index].output.size():
			queue_index += 1
			counter = 0
		
		
		# If all moves have played / animated out
		if queue_index > 3:
			print("reset")
			turn_index = 0
			counter = 0
			queue_index = 0
			for character in turn_queue:
				character.reset()
				
		return
	turn_index += 1

func _compare_speed(a, b):
	return a.turn_speed > b.turn_speed


func _on_area_2d_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_left") and players_array[turn_index].is_selecting_target:
		if warrior_enemy.is_dead: return
		players_array[turn_index].target = warrior_enemy
		players_array[turn_index].finish_turn()


func _on_mage_2d_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("mouse_left") and players_array[turn_index].is_selecting_target:
		if mage_enemy.is_dead: return
		players_array[turn_index].target = mage_enemy
		players_array[turn_index].finish_turn()

