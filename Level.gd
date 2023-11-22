extends Node2D

class_name Level

@export var active := false

var tiles: Dictionary = {}
var ordered_tiles: Array = []

var is_previewing := false
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
		
	if is_previewing:
		if current_preview_index >= ordered_tiles.size():
			is_previewing = false
			return
		
		previewing_timer += delta
		var current_tile = ordered_tiles[current_preview_index]
		var previous_tile = null if current_preview_index == 0 else ordered_tiles[current_preview_index - 1]
		
		if previewing_timer >= current_tile.time:
			if previous_tile:
				previous_tile.tile.modulate = Global.DEFAULT_TILE_COLOR
				
			current_tile.tile.modulate = Color(1, 1, 1)
			current_preview_index += 1
	
func toggle_preview():
	is_previewing = true
	previewing_timer = 0.0
	current_preview_index = 0
