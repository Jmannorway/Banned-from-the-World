extends Sprite

export var strength := 0.0

func glow():
	if $glow.is_playing():
		$glow.stop()
	$glow.play("glow")
	print("called")
