class_name NpcController

extends Area2D

#NPC Properties
var awake : bool = false
var on_gather : bool = false
var on_crafting : bool = false
var return_to_base : bool = false
var has_reward : bool = false
var can_craft : bool = false
var craft_time: int = 5
var reward_type : REWARD_TYPE
var speed : float = 100
var gather_time : int = 5

#NPC Goals
var start_position : Vector2
var next_target : Vector2
enum REWARD_TYPE { GATHER, CRAFT, PASSIVE }

#NPC Child Nodes
var timer : Timer
var npc_sprite : AnimatedSprite2D
var npc_menu : PanelContainer

var npc_dialogue : RichTextLabel
var gather_group : HBoxContainer
var gather_button : Button

var craft_group : HBoxContainer
var craft_button: Button

var collect_button: Button

#Sibling Nodes
var player : PlayerController
var map : MapController

#Signals
signal start_craft
signal collect_gather
signal collect_craft

# Called when the node enters the scene tree for the first time.
func _base_ready() -> void:
	next_target = Vector2.ZERO

	player = get_node("/root/Game Scene/Camp/Player")
	map = get_node("/root/Game Scene/TileMap")
	
	timer = Timer.new()
	add_child(timer)
		
	npc_sprite = get_node("NpcSprite")
	npc_menu = get_node("NpcMenu")
	
	npc_dialogue = npc_menu.get_node("Margins/VContainer/Dialogue")
	if npc_menu.has_node("Margins/VContainer/GatherGroup"):
		gather_group = npc_menu.get_node("Margins/VContainer/GatherGroup")
		gather_button = gather_group.get_node("GatherButton")
		gather_button.pressed.connect(_start_gather)
	
	if npc_menu.has_node("Margins/VContainer/CraftGroup"):
		craft_group = npc_menu.get_node("Margins/VContainer/CraftGroup")
		craft_button = craft_group.get_node("CraftButton")
		craft_button.pressed.connect(_start_craft)
	
	collect_button = npc_menu.get_node("Margins/VContainer/CollectButton")
	collect_button.pressed.connect(_collect_reward)
	
	area_entered.connect(_on_enter)
	area_exited.connect(_on_exit)
	
	body_entered.connect(_on_enter)
	body_exited.connect(_on_exit)
	
	npc_sprite.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _base_process(delta: float) -> void:
	var direction = Vector2.ZERO
	if return_to_base:
		#move towards start position
		if global_position.distance_to(start_position) < 2:
			global_position = start_position
			return_to_base = false
		else:
			direction = global_position.direction_to(start_position)
	elif on_gather:
		if next_target == Vector2.ZERO or global_position.distance_to(next_target) < 2:
			next_target = map.get_random_ground_tile()
		direction = global_position.direction_to(next_target)
	elif !awake:
		if craft_group:
			craft_group.hide()
		if gather_group:
			gather_group.hide()		
		collect_button.hide()
		return
	
	#Reward Button
	if has_reward:
		collect_button.show()
	else:
		collect_button.hide()
	
	if on_crafting or has_reward or on_gather or return_to_base:
		_display_menus(false)
	else:
		_display_menus(true)
	
	var animation = "idle"
	if direction.y < 0:
		animation = "walk_away"
	if direction.y > 0:
		animation = "walk_towards"
	if direction.x > 0:
		animation = "walk_left_right"
		npc_sprite.flip_h = true
	if direction.x < 0:
		animation = "walk_left_right"
		npc_sprite.flip_h = false
	
	npc_sprite.animation = animation
	position += direction.normalized() * speed * delta
		
func _on_enter(body: Node2D):
	if body is PlayerController and !on_gather:
		print("Talk to Me")
		_show_menu()
		
func _on_exit(body: Node2D):
	if body is PlayerController:
		print("Bye bye")
		_hide_menu()

func _show_menu():
		npc_menu.show()
		var tween = create_tween()
		tween.tween_property(npc_menu, "scale", Vector2(1,1), 0.2)
		
func _hide_menu():
		var tween = create_tween()
		tween.tween_property(npc_menu, "scale", Vector2(0.2,0.2), 0.2)
		await tween.finished
		npc_menu.hide()
	
func _start_gather():
	on_gather = true
	start_position = global_position
	timer.start(gather_time)
	timer.timeout.connect(_gather_complete)

func _gather_complete():	
	on_gather = false
	return_to_base = true
	next_target = Vector2.ZERO
	has_reward = true
	reward_type = REWARD_TYPE.GATHER
	timer.timeout.disconnect(_gather_complete)
	timer.stop()

func _start_craft():
	if can_craft:
		emit_signal("start_craft")
		timer.start(craft_time)			
		timer.timeout.connect(_craft_complete)
		on_crafting = true
	
func _craft_complete():
	on_crafting = false
	has_reward = true
	reward_type = REWARD_TYPE.CRAFT
	timer.timeout.disconnect(_craft_complete)
	timer.stop()
		
func _collect_reward():
	if reward_type == REWARD_TYPE.GATHER:
		emit_signal("collect_gather")
	elif reward_type == REWARD_TYPE.CRAFT:
		emit_signal("collect_craft")
	has_reward = false

func _display_menus(show:bool):
	_display_gather_options(show)
	_display_craft_options(show)

func _display_gather_options(show: bool):
	if gather_group:
		if show:
			gather_group.show()
		else:
			gather_group.hide()
	
func _display_craft_options(show: bool):
	if craft_group:
		if show:
			craft_group.show()
		else:
			craft_group.hide()
