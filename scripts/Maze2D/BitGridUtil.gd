extends Object

const AUTOTILE_TILE_INDEX = 1
const AUTOTILE_SIZE = Vector2(12, 4)
var maze := RecursiveBacktrack.new()

class_name BitGridUtil

static func autotile_1_bitgrid(bitgrid : Array, tilemap : TileMap, tile_index : int):
	
	var bitgrid_size = Vector2(bitgrid.size(), bitgrid[0].size())
	
	for x in bitgrid.size():
		for y in bitgrid_size.y:
			if bitgrid[x][y]:
				tilemap.set_cell(x, y, tile_index)

# uses a set-up 3x3min auto tile to put tiles on a bit-grid
static func autotile_47_bitgrid_wrap(bitgrid : Array, tilemap : TileMap, tile_index : int):
	var autotile_size
	var autotile_coords : Dictionary
	
	# gather all available autotile coordinate positions in a dictionary
	# using a each tile's bitmask as a key (only one tile variation is supported)
	var bm
	for x in AUTOTILE_SIZE.x:
		for y in AUTOTILE_SIZE.y:
			bm = tilemap.tile_set.autotile_get_bitmask(AUTOTILE_TILE_INDEX, Vector2(x, y))
			autotile_coords[bm] = Vector2(x, y);
	
	# get the size of the bitgrid always a rectangular 2d array (could be its own class)
	var bitgrid_size = Vector2(bitgrid.size(), bitgrid[0].size())
	
	var xl
	var xr
	var yt
	var yb
	var c
	var t
	var b
	var l
	var r
	var tl
	var tr
	var bl
	var br
	
	for x in bitgrid_size.x:
		# currently clamping the check (wrap could be better for looping purposes)
		xl = max(x-1, 0)
		xr = min(x+1, bitgrid_size.x - 1)
		for y in bitgrid_size.y:
			yt = max(y-1, 0)
			yb = min(y+1, bitgrid_size.y - 1)
			
			# center nulls out all other tiles
			c = bitgrid[x][y]
			
			t = bitgrid[x][yt] & c
			b = bitgrid[x][yb] & c
			l = bitgrid[xl][y] & c
			r = bitgrid[xr][y] & c
			
			# corners get nulled if sides aren't active
			tl = bitgrid[xl][yt] & l & t
			tr = bitgrid[xr][yt] & r & t
			bl = bitgrid[xl][yb] & l & b
			br = bitgrid[xr][yb] & r & b
			
			bm = (
				tl * TileSet.BIND_TOPLEFT |
				t * TileSet.BIND_TOP |
				tr * TileSet.BIND_TOPRIGHT |
				l * TileSet.BIND_LEFT |
				c * TileSet.BIND_CENTER |
				r * TileSet.BIND_RIGHT |
				bl * TileSet.BIND_BOTTOMLEFT |
				b * TileSet.BIND_BOTTOM |
				br * TileSet.BIND_BOTTOMRIGHT)
			
			tilemap.set_cell(x, y, AUTOTILE_TILE_INDEX, false, false, false, autotile_coords[bm])
