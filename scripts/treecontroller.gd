extends Area2D

var tree_sprite : AnimatedSprite2D

var tree_knocked : bool = false
var tree_hits : int = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tree_sprite = get_node("TreeSprite")
	
	area_entered.connect(_collide)
	body_entered.connect(_collide)
	
	tree_sprite.play()

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
			
func hit_tree():
	_knock()
	tree_hits -= 1
	
	if tree_hits == 0:
		tree_sprite.animation = "timber"
		tree_sprite.frame = 0
		tree_sprite.play()
		tree_sprite.animation_finished.connect(queue_free)
	else:
		tree_sprite.animation = "chop"
		tree_sprite.frame = 0
		tree_sprite.play()
		
	
	
