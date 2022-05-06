extends Node

class_name CharacterState

const PUSH_STATE := "_"
var character # Is of type Character2D (no static typing due to cyclic dependency)

func init(_character):
	character = _character

func enter():
	pass

func exit():
	pass

# Gets called every frame in Character2D::_process
# Override to make behavior and chose what state should be next
# Possible return values:
# "" = don't change the state
# "_" = pop this off the state stack (should never be returned if the class is meant as a base state)
# <state_name> = push <state_name> onto state stack
func process(delta : float) -> String:
	return ""
