extends CanvasLayer

onready var inner_world_menu := $inner_world_menu
onready var outer_world_menu = null

var menu : CanvasItem setget set_menu
var in_menu := false setget set_in_menu
var allow_menu := true setget set_allow_menu

func _init():
	Util.connect_safe(Game, "world_changed", self, "_on_Game_world_changed")

func _enter_tree():
	if !menu:
		set_menu(outer_world_menu)

func _ready():
	for n in get_children():
		n.visible = false

func _input(event):
	if Input.is_action_just_pressed("menu"):
		if menu && allow_menu && !XToFocus.focus:
			print("in menu happened")
			set_in_menu(!in_menu)
		else:
			print("nothing")

func set_menu(new_menu : CanvasItem):
	var _in_menu = in_menu
	set_in_menu(false)
	menu = new_menu
	set_in_menu(_in_menu)

func set_in_menu(val : bool):
	in_menu = val
	
	if menu:
		menu.visible = in_menu
	
	var _player = PlayerAccess.get_player(get_tree())
	if _player as Player2D:
		_player.set_frozen(in_menu)
	elif _player as CharacterController3D:
		_player.canMove = in_menu

func set_allow_menu(val : bool):
	if !val:
		set_in_menu(false)
	allow_menu = val

func _on_Game_world_changed():
	set_in_menu(false)
	
	print(Game.world)
	
	if Game.world == Game.WORLD.OUTER:
		menu = outer_world_menu
	else:
		menu = inner_world_menu
