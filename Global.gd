extends Node

var current_level = 3

const DefaultLivesNumberPerLevel = 8
const LivesNumberPerLevel = {
	0: 5,
	1: 3
}


const Scale = 32
const Eps = 0.001
const DeathTimer := 0.4
const MusicVolume := -24.0

const TileDelay := 1.0 # unused

# in seconds, time window before (or after) the optimal time for player step
# this times 2 gives total duration that is safe for player
# use this to tweak difficulty
const FreezoneDurationHalf := 0.3
# in seconds
const DeadlyDuration := 2.0
# time for full cycle (idle, anticipating, deadly)
#const Period := FreezoneDurationHalf * 2 + DeadlyDuration

const AnticipationDuration := 0.6
const Period := 2.5

#const starting_panel_delay = 1.0
const MusicOffsets = {
	0: 1.2,
	1: 1.1,
	2: 5.0
}

# used for making up for the delay while recording keys, and hitting key a bit later after the song hits
const MusicMiniDelay := 0.05

const DEFAULT_TILE_COLOR = Color("d288d2")
const ANTICIPATING_TILE_COLOR = Color("8183e1")
const DEADLY_TILE_COLOR = Color("080720")

func grid_pos(pos: Vector2) -> Vector2i:
	return Vector2i(round(pos.x / Scale), round(pos.y / Scale))

func world_pos(pos: Vector2i) -> Vector2:
	return Vector2(pos.x * Scale, pos.y * Scale)

func float_equals(x, y, eps = Eps) -> bool:
	return abs(x - y) < Eps

func direction_to_delta(direction: String) -> Vector2i:
	assert(direction in ["up", "down", "left", "right"], "Direction must be left right up or down.")
	if direction == "down":
		return Vector2i(0, 1)
	if direction == "up":
		return Vector2i(0, -1)
	if direction == "left":
		return Vector2i(-1, 0)
	
	return Vector2i(1, 0)

func to_str(f: float):
	return "%.1f" % f

func modulo_period(v: float):
	return float((int(1000*v) % int(1000*Global.Period)) / 1000.0) 
