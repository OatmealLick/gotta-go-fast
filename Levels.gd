extends Node2D

# todo replace with dynamic children iteration I guess?
@onready var level0: Level = $"camptown_races"
@export var audio_player: AudioStreamPlayer
@export var song_delay_label: LineEdit
@export var ui: UserInterface

var music0 : AudioStream = preload("res://camptown_races_cut1.ogg")

func _ready():
	pass


func _process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		var delay = 8.25 
		if song_delay_label:
			delay = float(song_delay_label.text)
			
		level0.toggle_preview()
		audio_player.stream = music0
		audio_player.play(delay)
