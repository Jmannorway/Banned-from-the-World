extends Node

class_name State

# This class is meant to be treated as a virtual interface

const POP_STATE := "_"
const KEEP_STATE := ""

# Depending on the type of state the state machine handles
# the host can pass arguments that'll be useful to the state here
# The inheriting state class will have to implement this function
#func init():
#	pass

# Called when the state becomes current
func enter():
	pass

# Called when the state ceases to be current
func exit():
	pass

# Gets called every frame in Character2D::_process
# Override to make behavior and chose what state should be next
# Possible return values:
# "" = don't change the state
# "_" = pop this off the state stack (should never be returned if the class is meant as a base state)
# <state_name> = push <state_name> onto state stack
func process(delta : float) -> String:
	return KEEP_STATE
