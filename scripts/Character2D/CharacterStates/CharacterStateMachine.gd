extends Node

export(String) var default_state
var state_stack : Array

func init(host):
	for n in get_children():
		n.init(host)
	if default_state.empty():
		push(CharacterState.new())
	else:
		push_by_name(default_state)

func _process(delta: float) -> void:
	var _new_state = get_current_state().process(delta)
	while !_new_state.empty():
		if _new_state == "_":
			pop()
		else:
			push_by_name(_new_state)
		_new_state = get_current_state().process(delta)

# States
func get_current_state() -> CharacterState:
	return state_stack[-1]

func pop():
	get_current_state().exit()
	state_stack.pop_back()
	get_current_state().enter()

func push(val : CharacterState):
	if state_stack.size() > 0:
		get_current_state().exit()
	state_stack.append(val)
	get_current_state().enter()

func push_by_name(val : String):
	var _new_state = get_node_or_null(val)
	if _new_state:
		push(_new_state)
	else:
		print("Character2D: Couldn't push state by name; ", val)
