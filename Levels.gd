extends Node2D
class_name Levels

var levels: Array = []
@export var audio_player: AudioStreamPlayer
@export var song_delay_label: LineEdit
@export var ui: UserInterface

var music0 : AudioStream = preload("res://camptown_races_cut1.ogg")
var music1 : AudioStream = preload("res://comfort-fit-sorry.ogg")
var music = [
	music0,
	music1
]
var starting_panel_delay = 1.0
var music_offsets = {
	0: 8.2,
	1: 1.4
}


signal level_selected
signal level_started

func _ready():
	audio_player.stream = music[Global.current_level]
	for c in get_children():
		levels.append(c)
	song_delay_label.text = str(music_offsets[Global.current_level])


func _process(delta):
	
	if Input.is_action_just_pressed("select_level_0"):
		_select_level(0)
	if Input.is_action_just_pressed("select_level_1"):
		_select_level(1)
	
	if Input.is_action_just_pressed("start_level"):
		_delay_level()
		await get_tree().create_timer(starting_panel_delay).timeout
		_level().start()
	
	if Input.is_action_just_pressed("stop_level"):
		if audio_player.playing:
			audio_player.stop()
		_level().stop()

	if Input.is_action_just_pressed("start_preview"):
		_delay_level()
		await get_tree().create_timer(starting_panel_delay).timeout
		_level().start_preview()


func _select_level(number: int):
	Global.current_level = number
	audio_player.stream = music[number]
	song_delay_label.text = str(music_offsets[number])
	for i in range(get_child_count()):
		var level = get_child(i) as Level
		if i == number:
			level.visible = true
			level.active = true
		else:
			level.visible = false
			level.active = false
	level_selected.emit()
		
func _delay_level():
	var offset = music_offsets[Global.current_level]
	
#	if song_delay_label:
#		offset = float(song_delay_label.text)
		
	audio_player.play(offset - starting_panel_delay)
	ui.show_starting_panel(starting_panel_delay)

func _level():
	return levels[Global.current_level]
