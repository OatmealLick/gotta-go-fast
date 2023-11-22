extends Control
class_name UserInterface


@onready var panel = $"PanelContainer"
@onready var timer_label: Label = $"PanelContainer/CenterContainer/Label"

var timer := 0.0
var duration := 0.0
var active := false

func show_starting_panel(duration_seconds: float):
	timer = 0.0
	duration = duration_seconds
	active = true
	timer_label.text = Global.to_str(duration)
	panel.visible = true


func hide_starting_panel():
	active = false
	panel.visible = false


func _process(delta):
	if not active:
		return
		
	timer += delta
	if timer >= duration:
		hide_starting_panel()
		
	timer_label.text = Global.to_str(duration - timer)
