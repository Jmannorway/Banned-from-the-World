extends Node

## @desc: First state to be pushed to the stack on init
export(String) var default_state
## @desc: If processing it will call process on the current state each frame
export(bool) var process : bool = true
## @desc: Stack of states, topmost state (aka. last in the array) is the current state
var state_stack : Array
var current_state_index : int

func init(args : Array = []):
	for n in get_children():
		n.callv("init", args)
	
	if default_state.empty():
		push(CharacterState.new())
	else:
		push_by_name(default_state)

func _ready():
	set_process(process)

func _process(delta: float) -> void:
	var _new_state = get_current_state().process(delta)
	while !_new_state.empty():
		if _new_state == State.POP_STATE:
			pop()
		else:
			push_by_name(_new_state)
		_new_state = get_current_state().process(delta)

# States
func get_current_state() -> CharacterState:
	return state_stack[-1]

func get_state_by_name(val : String) -> State:
	return get_node_or_null(val) as State

func get_stack_size() -> int:
	return state_stack.size()

## @desc: Pops current (topmost/last) last state of the stack
func pop():
	get_current_state().exit()
	state_stack.pop_back()
	get_current_state().enter()

## @desc: Pushes a state to the state stack and makes it current
func push(_state : State):
	if state_stack.size() > 0:
		get_current_state().exit()
	state_stack.append(_state)
	get_current_state().enter()

func push_by_name(val : String):
	var _new_state = get_state_by_name(val)
	if _new_state:
		push(_new_state)
	else:
		printerr(name, ": Couldn't push state by name: ", val)

## @desc: Swaps out the current state
func swap(_state : State):
	get_current_state().exit()
	state_stack.pop_back()
	state_stack.append(_state)
	get_current_state().enter()

## @desc: Swaps to a state identified by it's node name
func swap_by_name(val : String):
	var _new_state = get_state_by_name(val)
	if _new_state:
		swap(_new_state)
	else:
		printerr(name, ": Couldn't swap to state by name: ", val)

## @desc: Swaps to next state in child order (for test purposes)
func swap_next():
	var _state = get_current_state()
	for i in get_children().size():
		if get_child(i) == _state:
			swap(get_child((i + 1) % get_child_count()))
