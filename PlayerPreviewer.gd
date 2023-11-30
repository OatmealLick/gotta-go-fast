extends Node
class_name PlayerPreviewer

@export var player: Player
@export var levels: Levels

var current_tile_index := -1
var current_level: Level
var previewing: bool = false
var timer := 0.0


func _ready():
	levels.level_reset_and_starting.connect(_on_level_reset_and_starting)
	levels.level_started.connect(_on_level_started)


func _on_level_reset_and_starting():
	timer = 0.0
	current_level = levels.levels[Global.current_level]
	current_tile_index = -1
	previewing = true

func _on_level_started():
	previewing = false

func _process(delta):
	if not previewing:
		return
	
	if current_tile_index + 1 >= current_level.ordered_tiles.size():
		previewing = false
		return
	
	timer += delta
	var next_tile = current_level.ordered_tiles[current_tile_index + 1]
	if timer >= next_tile.time:
		current_tile_index += 1
		player.position = current_level.ordered_tiles[current_tile_index].position
