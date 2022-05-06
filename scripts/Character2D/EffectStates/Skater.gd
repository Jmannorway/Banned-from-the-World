extends EffectState

const RUN_SPEED := 8.0
const WALK_SPEED := 8.0
var prev_run_speed := 0.0
var prev_walk_speed := 0.0

func enter():
	.enter()
	prev_walk_speed = player.walk_speed
	prev_run_speed = player.run_speed
	player.walk_speed = WALK_SPEED
	player.run_speed = RUN_SPEED

func exit():
	player.walk_speed = prev_walk_speed
	player.run_speed = prev_run_speed
