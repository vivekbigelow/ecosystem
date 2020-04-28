extends Node

static func new_2d_array(width, height, value):
	var a = []
	
	for y in range(height):
		a.append([])
		a[y].resize(width)
		
		for x in range(width):
			a[y][x] = value
			
	return a
	


	
