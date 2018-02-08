// Authors:
//	Alfredo Hernández <aldomann.designs@gmail.com>
//	Ruth Kristianingsih <ruth.kristianingsih@mathmods.eu>

// Legal Stuff:
//	This script is free software: you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation, version 3.

//	This script is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
//	GNU General Public License for more details.

//	You should have received a copy of the GNU General Public License
//	along with this script. If not, see <http://www.gnu.org/licenses/>.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <limits.h>
#include <math.h>
#include <float.h>

// Structures
typedef struct {
	unsigned long id;              // Node identification
	unsigned short name_lenght;
	char *name;
	double lat, lon;               // Node position
	unsigned short num_successors; // Node successors: wighted edges
	unsigned long *successors;
} Node;

typedef char Queue;
enum whichQueue {
	NONE, OPEN, CLOSED
};

typedef struct {
	double g_cost, h_cost;
	unsigned long parent;
	Queue whq;
} AStarStatus;

typedef struct Node {
	double f_cost;
	unsigned long index;
	struct Node *next;
} LinkedNode;

// Linked List functions
void push(LinkedNode **head, double f_cost, unsigned long index) {
	LinkedNode *node_new;
	node_new = malloc(sizeof(LinkedNode));

	node_new -> f_cost = f_cost;
	node_new -> index = index;
	node_new -> next = *head;
	*head = node_new;
}

int remove_first(LinkedNode **head) {
	LinkedNode *node_next = NULL;

	if (*head == NULL) {
		return -1;
	}

	node_next = (*head) -> next;
	free(*head);
	*head = node_next;
	return 1;
}

int remove_by_index(LinkedNode **head, unsigned long index) {
	LinkedNode *current = *head;
	if (current == NULL) {
		return -1;
	}
	LinkedNode *node_temp = NULL;

	if (index == current -> index) {
		remove_first(head);
		return 1;
	}

	while (current -> next -> index != index) {
		current = current -> next;
		if (current == NULL) return -1;
	}

	node_temp = current -> next;
	current -> next = node_temp -> next;
	free(node_temp);
	return 1;
}

unsigned long index_minimum(LinkedNode *head) {
	LinkedNode *current = head;
	if (current == NULL) {
		return ULONG_MAX;
	}
	LinkedNode *minimum = NULL;
	double min = 9999999;

	while (current != NULL) {
		if (current -> f_cost < min) {
			minimum = current;
			min = current -> f_cost;
		}
		current = current -> next;
	}
	return minimum -> index;
}

// Binary Search function
unsigned long perform_binary_search(unsigned long key, unsigned long *list, unsigned long lenlist) {
	register unsigned long start = 0UL, afterend = lenlist, middle;
	register unsigned long try;
	while ( afterend > start ) {
		middle = start + ((afterend-start-1)>>1); try = list[middle];
		if (key == try) {
			return middle;
		} else if ( key > try ) {
			start = middle + 1;
		} else {
			afterend = middle;
		}
	}
	return ULONG_MAX;
}

// Haversine Distance function
double distance (Node *nodes, unsigned long node_start, unsigned long node_goal) {
	double R = 6371000;
	double lat1 = nodes[node_start].lat*(M_PI/180);
	double lat2 = nodes[node_goal].lat*(M_PI/180);
	double lon1 = nodes[node_start].lon*(M_PI/180);
	double lon2 = nodes[node_goal].lon*(M_PI/180);
	double d_lat = lat2-lat1;
	double d_lon = lon2-lon1;
	double a = sin(d_lat/2) * sin(d_lat/2) + cos(lat1) * cos(lat2) * sin(d_lon/2) * sin(d_lon/2);
	double c = 2 * atan2(sqrt(a), sqrt(1-a));
	return R * c;
}

// Function to print path
void print_path (Node *nodes, AStarStatus *status, unsigned long node_start, unsigned long node_goal, unsigned long node_current, unsigned long nnodes) {
	// Print the path
	unsigned long *path;
	unsigned long node_next;
	int i = 0;

	node_next = node_current;
	path = (unsigned long *)malloc(nnodes*sizeof(unsigned long));
	path[0] = node_next;
	while (node_next != node_start) {
		i++;
		node_next = status[node_next].parent;
		path[i] = node_next;
	}
	int path_length = i + 1;

	// Header
	printf("Node ID, Distance (m), Lat, Lon\n");
	// Print nodes
	for (i = path_length-1; i >= 0;i--) {
		printf("%lu, %.2f, %.5f, %.5f \n", nodes[path[i]].id, status[path[i]].g_cost, nodes[path[i]].lat, nodes[path[i]].lon);
	}
}

// A* Algorithm
void astar_algorithm (Node *nodes, LinkedNode *open_list, AStarStatus *status, unsigned long node_start, unsigned long node_goal, unsigned long nnodes ) {
	double successor_current_cost;
	unsigned long node_current;

	int i = 0;
	while ((node_current = index_minimum(open_list)) != ULONG_MAX) {

		if (node_current == node_goal) {
			break;
		}

		for (i = 0; i < nodes[node_current].num_successors; i++) {
			unsigned long node_successor = nodes[node_current].successors[i];
			successor_current_cost = status[node_current].g_cost + distance(nodes, node_current, node_successor);

			if (status[node_successor].whq == OPEN) {
				if (status[node_successor].g_cost <= successor_current_cost){
					continue;
				}
			} else if (status[node_successor].whq == CLOSED) {
				if (status[node_successor].g_cost <= successor_current_cost) continue;

				status[node_successor].whq = OPEN;
				push(&open_list, successor_current_cost + status[node_successor].h_cost, node_successor);
			} else {
				status[node_successor].whq = OPEN;
				status[node_successor].h_cost = distance(nodes, node_successor, node_goal);
				push(&open_list, (successor_current_cost + status[node_successor].h_cost), node_successor);
			}

			status[node_successor].g_cost = successor_current_cost;
			status[node_successor].parent = node_current;
		}
		status[node_current].whq = CLOSED;

		if ((remove_by_index(&open_list, node_current)) != 1) {
			printf("Removal failed.\n");
		}
	}
	if (node_current != node_goal) {
		printf("OPEN list is empty.\n");
	}

	print_path(nodes, status, node_start, node_goal, node_current, nnodes);
}


int main (int argc, char* argv[]) {
	int i;
	unsigned long nnodes, num_total_successors, num_total_name;
	unsigned long node_start, node_goal;
	unsigned long *allsuccessors;
	char *allnames;
	Node *nodes;

	// Read binary file
	FILE *fin;

	if ((fin = fopen ("data/spain-data.bin", "r")) == NULL) {
		printf("The data file does not exist or cannot be opened\n");
	}

	/* Global data --- header */
	if ( fread(&nnodes, sizeof(unsigned long), 1, fin) +
	fread(&num_total_successors, sizeof(unsigned long), 1, fin) +
	fread(&num_total_name, sizeof(unsigned long), 1, fin) != 3 ) {
		printf("Error when reading the header of the binary data file\n");
	}

	/* getting memory for all data */
	if ((nodes = (Node *) malloc(nnodes*sizeof(Node))) == NULL) {
		printf("Error when allocating memory for the nodes vector\n");
	}
	if ((allsuccessors = (unsigned long *) malloc(num_total_successors*sizeof(unsigned long))) == NULL) {
		printf("Error when allocating memory for the edges vector\n");
	}
	if ((allnames = (char *) malloc(num_total_name*sizeof(char))) == NULL) {
		printf("Error when allocating memory for the names\n");
	}

	/* Reading all data from file */
	if ( fread(nodes, sizeof(Node), nnodes, fin) != nnodes ) {
		printf("Error when reading nodes from the binary data file\n");
	}
	if ( fread(allsuccessors, sizeof(unsigned long), num_total_successors, fin) != num_total_successors ) {
		printf("Error when reading sucessors from the binary data file\n");
	}
	if ( fread(allnames, sizeof(char), num_total_name, fin) != num_total_name ) {
		printf("Error when reading names from the binary data file\n");
	}
	fclose(fin);

	unsigned long *list;
	list = (unsigned long *)malloc(sizeof(unsigned long)*nnodes);
	for (i = 0; i < nnodes; i++) list[i] = nodes[i].id;

	//Setting pointers to successors
	for (i = 0; i < nnodes; i++) {
		if (nodes[i].num_successors) {
			nodes[i].successors = allsuccessors;
			allsuccessors += nodes[i].num_successors;
		}
	}

	//Setting pointers to names
	for (i = 0; i < nnodes; i++) {
		if (nodes[i].name_lenght) {
			nodes[i].name = allnames;
			allnames += nodes[i].name_lenght;
		}
	}

	LinkedNode *open_list = NULL;

	if ((node_start = perform_binary_search(240949599, list, nnodes)) == ULONG_MAX) {
		printf("Node start not found.\n");
	}
	if ((node_goal = perform_binary_search(195977239, list, nnodes)) == ULONG_MAX) {
		printf("Node goal not found.\n");
	}
	AStarStatus *status;
	status = (AStarStatus *)malloc(sizeof(AStarStatus)*nnodes);

	status[node_start].g_cost = 0;
	status[node_start].h_cost = distance(nodes, node_start, node_goal);
	status[node_start].whq = OPEN;
	push(&open_list, status[node_start].h_cost, node_start);

	// A* Algorithm
	astar_algorithm(nodes, open_list, status, node_start, node_goal, nnodes);
}
