extends Node2D

class_name Level

@export var active := false

var tiles: Dictionary = {}
var ordered_tiles: Array = []
@onready var preview_node: Node2D = $"../../Preview"

var previewing := false
var previewing_timer := 0.0
var current_preview_index := 0

func _ready():
	for c in get_children():
		var tile = c as Tile
		var pos = Global.grid_pos(tile.position)
		tiles[pos] = tile
		ordered_tiles.append({
			"tile": tile,
			"time": tile.time
		})
		
func _process(delta):
	if not active:
		return
		
	if Input.is_key_pressed(KEY_O):
		for c in get_children():
			(c as Tile).start()
	if Input.is_key_pressed(KEY_P):
		for c in get_children():
			(c as Tile).stop()
		
	if previewing:
		if current_preview_index >= ordered_tiles.size():
			previewing = false
			return
		
		previewing_timer += delta
		var current_tile = ordered_tiles[current_preview_index]
		
		if previewing_timer >= current_tile.time:
			preview_node.position = current_tile.tile.position
			current_preview_index += 1
	
func start_preview():
	previewing = true
	previewing_timer = 0.0
	current_preview_index = 0
	preview_node.visible = true
	
func stop_preview():
	previewing = false
	preview_node.visible = false
