extends Node2D

# todo replace with dynamic children iteration I guess?
@onready var level0: Level
@export var audio_player: AudioStreamPlayer
@export var song_delay_label: LineEdit
@export var ui: UserInterface

var music0 : AudioStream = preload("res://camptown_races_cut1.ogg")
var starting_panel_delay = 3.0

func _ready():
	audio_player.stream = music0
	level0 = get_child(0) as Level


func _process(delta):
	
	if Input.is_action_just_pressed("start_level"):
		_delay_level0()
		await get_tree().create_timer(starting_panel_delay).timeout
		level0.start()
	
	if Input.is_action_just_pressed("stop_level"):
		if audio_player.playing:
			audio_player.stop()
		level0.stop()

	if Input.is_action_just_pressed("start_preview"):
		_delay_level0()
		await get_tree().create_timer(starting_panel_delay).timeout
		level0.start_preview()
		
func _delay_level0():
	var delay = 8.25 
	if song_delay_label:
		delay = float(song_delay_label.text)
	audio_player.play(delay - starting_panel_delay)
	ui.show_starting_panel(starting_panel_delay)
