extends Node2D

class_name Level

@export var active := false

@export var tiles: Dictionary = {}
@export var ordered_tiles: Array = []
@onready var preview_node: Node2D = $"../../Preview"

var previewing := false
@export var previewing_timer := 0.0
@export var current_preview_index := 0

#func _ready():
#	for i in range(get_child_count()):
#		var c = get_child(i)
#		var tile = c as Tile
#		if i < get_child_count() - 1:
#			var c_next = get_child(i + 1)
#			tile.time_tile_next = c_next.time - c.time
#		var pos = Global.grid_pos(tile.position)
#		tiles[pos] = tile
#		ordered_tiles.append({
#			"tile": tile,
#			"time": tile.time #useless, use tile.time
#		})
#
#	# todo remove
#	var max_diff = 0.0
#	for i in range(get_child_count() - 1):
#		var t0 = get_child(i).time
#		var t1 = get_child(i + 1).time
#		max_diff = max(max_diff, t1 - t0)
#		i+=1
#	print("Max diff %s" % max_diff)
		
func _process(delta):
	if not active:
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
	
func start():
	for c in get_children():
		(c as Tile).start()
		
func stop():
	for c in get_children():
		(c as Tile).stop()
	
