extends Sprite2D
class_name Player

var levels: Levels
var level: Level
var current_grid_pos := Vector2i(999999, 999999)

@export var okStepsLabel: Label
@export var errorStepsLabel: Label
@export var active: bool = true

var initial_position := Vector2i(-320, 160)

func _ready():
	levels = get_node("/root/Game/Levels") as Levels
	levels.level_selected.connect(_on_level_selected)
	levels.level_started.connect(_on_level_started)
	level = levels.get_child(Global.current_level)
	for t in level.ordered_tiles:
		t.made_deadly.connect(_on_made_deadly)

	
func _input(event):
	if not active:
		return
		
	var grid_pos_delta = Vector2i(0, 0)
	if event.is_action_pressed("move_down"):
		grid_pos_delta.y += 1
	if event.is_action_pressed("move_up"):
		grid_pos_delta.y -= 1
	if event.is_action_pressed("move_left"):
		grid_pos_delta.x -= 1
	if event.is_action_pressed("move_right"):
		grid_pos_delta.x += 1
	
	if grid_pos_delta == Vector2i(0, 0):
		return
		
	var grid_pos = Global.grid_pos(position)
	var new_grid_pos = grid_pos + grid_pos_delta
	if level.tiles.has(new_grid_pos):
		# can only move on path
		current_grid_pos = new_grid_pos
		var new_world_pos = Global.world_pos(new_grid_pos)
		position = new_world_pos
		var tile = level.tiles.get(new_grid_pos) as Tile
		print(tile.state)
		if tile.state == Tile.DEADLY:
			_increment_step(errorStepsLabel)
		else:
			_increment_step(okStepsLabel)
		
	
func _on_made_deadly(grid_pos):
	if grid_pos == current_grid_pos:
		_increment_step(errorStepsLabel)
		
func _on_level_selected():
	for t in level.ordered_tiles:
		t.made_deadly.disconnect(_on_made_deadly)
	level = levels.get_child(Global.current_level)
	for t in level.ordered_tiles:
		t.made_deadly.connect(_on_made_deadly)
	_set_step(okStepsLabel, 0)
	_set_step(errorStepsLabel, 0)
	position = initial_position

func _on_level_started():
	position = initial_position

func _increment_step(label: Label):
	var current = int(label.text)
	label.text = str(current + 1)

func _set_step(label: Label, value: int):
	label.text = str(value)
