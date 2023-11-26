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
@export var time_tile_next := -1.0

signal made_deadly(grid_pos)

@export var deadly_duration := 0.0
@export var idle_duration := 0.0
@export var idle_anti_duration := 0.0

func reset():
	_set_idle()
	timer = Global.Period - float((int(1000*time) % int(1000*Global.Period)) / 1000.0) 
	is_playing = false

func start():
	is_playing = true

func stop():
	is_playing = false
	
func _ready():
	original_position = position
	is_playing = false
	
	idle_duration = time_tile_next
	idle_anti_duration = idle_duration + Global.AnticipationDuration
	deadly_duration = Global.Period - idle_anti_duration
	
	
func _process(delta):
	if not is_playing:
		return
		
	timer += delta
	if timer >= Global.Period:
		timer -= Global.Period

	_set_state_based_on_timer()


func _set_state_based_on_timer():
	if timer < idle_duration and state == DEADLY:
		_set_idle()
	elif idle_duration <= timer and timer < idle_anti_duration and state == IDLE:
		_set_anticipating()
	elif timer >= idle_anti_duration and state == ANTICIPATING:
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
