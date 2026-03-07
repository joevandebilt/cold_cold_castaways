class_name MapGenerator

extends TileMapLayer



func _add_tree(location: Vector2) -> void:
	var tree = Area2D.new()
	var tree_sprite = AnimatedSprite2D.new()
	tree_sprite.sprite_frames = load("res://artwork/sprites/tree_sprite.tres")	
	tree.add_child(tree_sprite)
	
	var tree_collision = CollisionShape2D.new()
	var collision_shape = RectangleShape2D.new()
	collision_shape.size = Vector2(31, 38)
	tree_collision.shape = collision_shape
	tree.add_child(tree_collision)
	
	tree.set_script(load("res://scripts/treecontroller.gd"))
	tree.position = location
	tree.apply_scale(Vector2(1,1))
	
	add_child(tree)
