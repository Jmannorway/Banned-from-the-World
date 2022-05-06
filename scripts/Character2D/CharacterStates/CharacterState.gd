extends State

class_name CharacterState

var character # Is of type Character2D (no static typing due to cyclic dependency)

func init(_character):
	character = _character
