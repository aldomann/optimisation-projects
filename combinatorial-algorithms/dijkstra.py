
nodes = ('A', 'B', 'C', 'D', 'E') # V: list of vertices
distances = {
	'A': {'B': 10, 'C': 3},
	'B': {'C': 1, 'D': 2},
	'C': {'B':4, 'D':8, 'E':2},
	'D': {'E': 7},
	'E': {'D': 9}}

unvisited = {node: None for node in nodes} # Q: Using None as +inf
visited = {} # S vector of known shortest distances from the source
current = 'A' # s: source
currentDistance = 0
unvisited[current] = currentDistance

while True:
	print("")
	print("PRE STEP ##########################")
	print("Q:       ", unvisited)
	# print("current: ", current)
	print("S:       ", visited)

	for neighbour, distance in distances[current].items():
		print("dist(", current,"-", neighbour, "): ", distance)
		if neighbour not in unvisited:
			print(neighbour, "already visited")
			continue
		newDistance = currentDistance + distance
		if unvisited[neighbour] is None or unvisited[neighbour] > newDistance:
			unvisited[neighbour] = newDistance
	visited[current] = currentDistance
	del unvisited[current]
	if not unvisited: # End of the loop
		break
	candidates = [node for node in unvisited.items() if node[1]]
	current, currentDistance = sorted(candidates, key = lambda x: x[1])[0]

print("")
print("MinDists", visited)

{'D': 12, 'E': 4}
