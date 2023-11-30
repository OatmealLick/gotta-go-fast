extends Node2D
class_name Levels

var levels: Array = []
@export var audio_player: AudioStreamPlayer
@export var song_delay_label: LineEdit
@export var ui: UserInterface
@export var player: Player

var music0 : AudioStream = preload("res://camptown_races_cut1.ogg")
var music1 : AudioStream = preload("res://comfort-fit-sorry.ogg")
var music2 : AudioStream = preload("res://timtaj-hours-gone-forever.ogg")
var music3 : AudioStream = preload("res://camptown_races_2.mp3")
var music = [
	music0,
	music1,
	music2,
	music3,
]


signal level_selected
signal level_reset
signal level_started
signal level_reset_and_starting # both reset and scheduling start

const starting_panel_delay = 1.0

func _ready():
	audio_player.stream = music[Global.current_level]
	for c in get_children():
		levels.append(c)
	song_delay_label.text = str(Global.MusicOffsets.get(Global.current_level, 0.0))
	levels[Global.current_level].reset()
	player.lose_last_life.connect(_on_lose_last_life)


func _process(delta):
	
	if Input.is_action_just_pressed("select_level_0"):
		_select_level(0)
	if Input.is_action_just_pressed("select_level_1"):
		_select_level(1)
	if Input.is_action_just_pressed("select_level_2"):
		_select_level(2)
	
	if Input.is_action_just_pressed("start_level"):
		_reset_level()
		var offset = Global.MusicOffsets.get(Global.current_level, 0.0)
		
		ui.show_starting_panel(offset)
		level_reset_and_starting.emit()
		
		levels[Global.current_level].start()
		# might not use MiniDelay
		await get_tree().create_timer(Global.MusicMiniDelay).timeout
		audio_player.play()
		await get_tree().create_timer(offset - Global.MusicMiniDelay).timeout
		level_started.emit()
		
	
	if Input.is_action_just_pressed("stop_level"):
		if audio_player.playing:
			audio_player.stop()
		levels[Global.current_level].stop()
	
	if Input.is_action_just_pressed("reset_level"):
		_reset_level()

	if Input.is_action_just_pressed("start_preview"):
		var offset = Global.MusicOffsets[Global.current_level]
		audio_player.play()
		ui.show_starting_panel(offset)
		
		await get_tree().create_timer(offset).timeout
		levels[Global.current_level].start_preview()


func _select_level(number: int):
	Global.current_level = number
	audio_player.stream = music[number]
	song_delay_label.text = str(Global.MusicOffsets[number])
	for i in range(get_child_count()):
		var level = get_child(i) as Level
		if i == number:
			level.visible = true
		else:
			level.visible = false
	level_selected.emit()
		
func _delay_level():
	var offset = Global.MusicOffsets[Global.current_level]
	
#	if song_delay_label:
#		offset = float(song_delay_label.text)
		
	audio_player.play()
	ui.show_starting_panel(offset)

func _on_lose_last_life():
	if audio_player.playing:
		var tween = create_tween()
		tween.tween_property(audio_player, "volume_db", -50.0, Global.DeathTimer * 0.95).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(Global.DeathTimer).timeout
	audio_player.stop()
	audio_player.volume_db = Global.MusicVolume
	_reset_level()
	

func _reset_level():
	levels[Global.current_level].reset()
	level_reset.emit()
	
