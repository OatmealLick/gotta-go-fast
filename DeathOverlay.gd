extends NinePatchRect

@export var player: Player

@onready var rect := $"ColorRect"

func _ready():
	player.lose_last_life.connect(_on_lose_last_life)

func _on_lose_last_life():
	visible = true
	var tween = create_tween()
	tween.tween_property(rect, "modulate", Color(Color.BLACK, 1.0), Global.DeathTimer).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(_set_not_visible)

func _set_not_visible():
	visible = false
