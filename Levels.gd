extends Node2D

# todo replace with dynamic children iteration I guess?
@onready var level0: Level = $"camptown_races"
@export var audio_player: AudioStreamPlayer
@export var song_delay_label: LineEdit
@export var ui: UserInterface

var music0 : AudioStream = preload("res://camptown_races_cut1.ogg")

func _ready():
	audio_player.stream = music0


func _process(delta):
	if Input.is_action_just_pressed("StartPreview"):
		var delay = 8.25 
		if song_delay_label:
			delay = float(song_delay_label.text)
		
		var starting_panel_delay = 3.0
		audio_player.play(delay - starting_panel_delay)
		
		ui.show_starting_panel(starting_panel_delay)
		await get_tree().create_timer(starting_panel_delay).timeout
			
		level0.start_preview()
		
