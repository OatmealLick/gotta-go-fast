extends Sprite2D
class_name Tile

@export var time: float

const IDLE := 0
const ANTICIPATING := 1
const DEADLY := 2

@export var state = IDLE
@export var timer := 0.0
@export var is_playing := false
var original_position: Vector2
@export var timeAdjusted: float

signal made_deadly(grid_pos)


func start():
	is_playing = true

func stop():
	is_playing = false
	
func _ready():
	original_position = position
	is_playing = false
	
	timeAdjusted = float((int(1000*time) % int(1000*Global.Period)) / 1000.0) 
	timer = Global.Period - timeAdjusted
#	_set_state_based_on_timer()
	
	
func _process(delta):
	if not is_playing:
		return
		
	timer += delta
	if timer >= Global.Period:
		timer -= Global.Period

	_set_state_based_on_timer()


func _set_state_based_on_timer():
	if timer < Global.FreezoneDurationHalf and state == DEADLY:
		_set_idle()
	elif Global.FreezoneDurationHalf <= timer and timer < 2 * Global.FreezoneDurationHalf and state == IDLE:
		_set_anticipating()
	elif timer >= 2 * Global.FreezoneDurationHalf and state == ANTICIPATING:
		_set_deadly()
	
	
func _set_idle():
	state = IDLE
	modulate = Global.DEFAULT_TILE_COLOR

func _set_anticipating():
	state = ANTICIPATING
	modulate = Global.ANTICIPATING_TILE_COLOR

func _set_deadly():
	state = DEADLY
	modulate = Global.DEADLY_TILE_COLOR
	made_deadly.emit(Global.grid_pos(position))
