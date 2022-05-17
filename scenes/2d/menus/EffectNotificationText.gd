extends Label

const POSTFIX := " unlocked"
var effect_name := ""

func set_effect_name(val : String):
	effect_name = val
	text = effect_name + POSTFIX
