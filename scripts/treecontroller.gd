class_name TreeController

extends Area2D

var tree_sprite : AnimatedSprite2D
var timer : Timer

var tree_knocked : bool = false
var tree_hits : int = 3
var wood_value : int = 15 

var player : PlayerController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tree_sprite = get_node("TreeSprite")
	
	player = get_node("/root/Game Scene/Camp/Player")
	
	area_entered.connect(_collide)
	body_entered.connect(_collide)
	
	tree_sprite.play()

	timer = Timer.new()
	add_child(timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _collide(body: Node2D):
	if body is PlayerController:
		_knock()

func _knock():
	if !tree_knocked:
		print("player knocked the tree")
		tree_sprite.animation = "knock"
		tree_sprite.frame = 0
		tree_sprite.play()
		tree_knocked = true
			
func interact():
	_knock()
	if tree_sprite.animation_finished and tree_hits > 0:
		tree_hits -= 1
		
		if tree_hits == 0:
			player.inventory.add_resource(player.inventory.Resources.WOOD, wood_value)
			tree_sprite.animation = "timber"
			tree_sprite.frame = 0
			tree_sprite.play()
			
			timer.start(60)
			timer.timeout.connect(respawn)
		else:
			tree_sprite.animation = "chop"
			tree_sprite.frame = 0
			tree_sprite.play()
		
func respawn():
	tree_sprite.animation = "default"
	tree_sprite.frame = 0
	tree_sprite.play()
	
	tree_hits = 3
	tree_knocked = false
	
