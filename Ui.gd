extends Control
class_name UserInterface


@onready var panel = $"PanelContainer"
@onready var timer_label: Label = $"PanelContainer/CenterContainer/Label"
@onready var lives_parent: Control = $"HBoxContainer/Left/MarginContainer/Lives"
@onready var life_texture = preload("res://heart-outline.png")

@export var player: Player
@export var levels: Levels

const life_texture_scale := Vector2(0.2, 0.2)
const life_offset := 50
const life_lose_duration := 1.0
const life_lose_position_offset := 100

var timer := 0.0
var duration := 0.0
var active := false

func _ready():
	player.lose_life.connect(_lose_life)
	player.lose_last_life.connect(_lose_life)
	levels.level_reset.connect(set_lives_for_level)

func _process(delta):
	if not active:
		return
		
	timer += delta
	if timer >= duration:
		hide_starting_panel()
		
	timer_label.text = Global.to_str(duration - timer)


func show_starting_panel(duration_seconds: float):
	timer = 0.0
	duration = duration_seconds
	active = true
	timer_label.text = Global.to_str(duration)
	panel.visible = true


func hide_starting_panel():
	active = false
	panel.visible = false

func set_lives_for_level():
	set_lives(Global.LivesNumberPerLevel.get(Global.current_level, Global.DefaultLivesNumberPerLevel))

func set_lives(number: int):
	for c in lives_parent.get_children():
		c.queue_free()
	
	for i in range(number):
		var new_life = TextureRect.new()
		new_life.texture = life_texture
		new_life.scale = life_texture_scale
		new_life.position = Vector2i(i * life_offset, 0)
		lives_parent.add_child(new_life)


func _lose_life():
	var lives_number = lives_parent.get_child_count()
	if lives_number <= 0:
		return
	var life = lives_parent.get_child(lives_number - 1)
	var pos = life.position + Vector2(0, -life_lose_position_offset)
	var tween = create_tween().set_parallel(true)
	tween.tween_property(life, "scale", Vector2(0.3, 0.3), life_lose_duration)
	tween.tween_property(life, "position", pos, life_lose_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_property(life, "modulate", Color(Color.WHITE, 0.0), life_lose_duration)
	tween.chain().tween_callback(life.queue_free)
	
	

