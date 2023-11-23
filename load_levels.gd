@tool
extends EditorScript

const TileScene = preload("res://tile.tscn")
const LevelScene = preload("res://level.tscn")
var rng = RandomNumberGenerator.new()


# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	if get_scene().name != "Game":
		print("Can only be run in 'Game'. Quitting..")
		return
	
	var levels: Node2D = get_scene().get_node("Levels")
	var player: Player = get_scene().get_node("Player")
#	player.level = null
	var level = _add_to_levels("camptown_races", levels)
	print(level.name)
	player.level = level
	
func _add_to_levels(level: String, levels: Node2D):
	var start_pos := Vector2i(-10, 5)
	
	# remove current level if exists
	for old_level_node in levels.get_children():
		if old_level_node.name.begins_with(level):
			old_level_node.queue_free()
		
	# add new level node
	var new_level_node: Level = LevelScene.instantiate()
	var new_level_node_name := "%s_%s" % [level, str(rng.randi_range(100_000, 999_999))]
	new_level_node.name = new_level_node_name
	levels.add_child(new_level_node)
	new_level_node.set_owner(get_scene())
	
	# parse the file with keystrokes and build steps
	var path = "res://%s.json" % level
	var level_json := FileAccess.open(path, FileAccess.READ)
	var content = level_json.get_as_text()
	var steps = []
	for l in content.split("\n"):
		if l == "":
			continue
		var parsed = JSON.parse_string(l)
		if parsed.event_type == "down":
			var direction = parsed.name
			var time := float(parsed.time)
			steps.append({"direction": direction, "time": time})
			
	var current = start_pos
	var start_time = -1.0
	var current_time = -1.0
	for i in range(0, steps.size()):
		var s = steps[i]
		if i == 0:
			start_time = s.time
			current_time = 0.0
		else:
			current_time = s.time - start_time
		var delta = direction_to_delta(s.direction as String)
		current += delta
		var tile: Tile = TileScene.instantiate()
		tile.name = "tile_%s" % i
		tile.position = world_pos(current)
		new_level_node.add_child(tile)
		tile.set_owner(get_scene())
		tile.time = current_time
	
	# setup level node after tiles are constructed
	var tiles: Dictionary = {}
	var ordered_tiles: Array = []
	for i in range(new_level_node.get_child_count()):
		var c = new_level_node.get_child(i)
		var tile = c as Tile
		if i < new_level_node.get_child_count() - 1:
			var c_next = new_level_node.get_child(i + 1)
			tile.time_tile_next = c_next.time - c.time
		var pos = grid_pos(tile.position)
		
		tiles[pos] = tile
		ordered_tiles.append(tile)
	new_level_node.tiles = tiles
	new_level_node.ordered_tiles = ordered_tiles
	
	return new_level_node
	


# COPY PASTE GLOBAL BECAUSE NOT GONNA SPEND LIFE FIGURING OUT THIS STUFF
const Scale = 32
const Eps = 0.001

func grid_pos(pos: Vector2) -> Vector2i:
	return Vector2i(round(pos.x / Scale), round(pos.y / Scale))

func world_pos(pos: Vector2i) -> Vector2:
	return Vector2(pos.x * Scale, pos.y * Scale)

func float_equals(x, y, eps = Eps) -> bool:
	return abs(x - y) < Eps


func direction_to_delta(direction: String) -> Vector2i:
	assert(direction in ["up", "down", "left", "right", "w", "s", "a", "d"], "Direction must be left right up or down.")
	if direction in ["down", "s"]:
		return Vector2i(0, 1)
	if direction in ["up", "w"]:
		return Vector2i(0, -1)
	if direction in ["left", "a"]:
		return Vector2i(-1, 0)
	
	return Vector2i(1, 0)
