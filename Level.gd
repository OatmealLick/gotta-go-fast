extends Node2D

class_name Level

@export var tiles: Dictionary = {}
@export var ordered_tiles: Array = []
@onready var preview_node: Node2D = $"../../Preview"

var previewing := false
@export var previewing_timer := 0.0
@export var current_preview_index := 0

func _ready():
	for c in get_children():
		var tile = c as Tile
		var pos = Global.grid_pos(tile.position)
		tiles[pos] = tile
		ordered_tiles.append(tile)
		
func _process(delta):
	if not is_active():
		return
		
	if previewing:
		if current_preview_index >= ordered_tiles.size():
			previewing = false
			return
		
		previewing_timer += delta
		var current_tile = ordered_tiles[current_preview_index]
		
		if previewing_timer >= current_tile.time:
			preview_node.position = current_tile.position
			current_preview_index += 1
	
func start_preview():
	previewing = true
	previewing_timer = 0.0
	current_preview_index = 0
	preview_node.visible = true
	
func stop_preview():
	previewing = false
	preview_node.visible = false
	
func reset():
	for c in get_children():
		(c as Tile).reset()

func start():
	for c in get_children():
		(c as Tile).start()
		
func stop():
	for c in get_children():
		(c as Tile).stop()
	
func is_active():
	return get_index() == Global.current_level
