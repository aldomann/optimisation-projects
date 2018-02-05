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

typedef struct {
	unsigned long id;     // Node identification
	unsigned short namelen;
	char *name;
	double lat, lon;      // Node position
	unsigned short nsucc; // Node successors: wighted edges
	unsigned long *successors;
} Node;

typedef char Queue;
	enum whichQueue {
		NONE, OPEN, CLOSED
	};

typedef struct {
	double g, h;
	unsigned long parent;
	Queue whq;
} AStarStatus;

typedef struct Node {
	double f;
	unsigned long index;
	struct Node * next;
} NodeT;

// Linked List functions
void push(NodeT ** head, double f, unsigned long index) {
	NodeT * new_node;
	new_node = malloc(sizeof(NodeT));

	new_node->f = f;
	new_node->index = index;
	new_node->next = *head;
	*head = new_node;
}

int remove_first(NodeT ** head) {
	NodeT * next_node = NULL;

	if (*head == NULL) {
		return -1;
	}

	next_node = (*head)->next;
	free(*head);
	*head = next_node;
	return 1;
}

int remove_by_index(NodeT ** head, unsigned long index) {
	NodeT * current = *head;
	if (current == NULL) {
		return -1;
	}
	NodeT * temp_node = NULL;

	if (index == current->index) {
		remove_first(head);
		return 1;
	}

	while (current->next->index != index) {
		current = current->next;
		if (current == NULL) return -1;
	}

	temp_node = current->next;
	current->next = temp_node->next;
	free(temp_node);
	return 1;
}

unsigned long index_minimum(NodeT * head) {
	NodeT * current = head;
	if (current == NULL) return ULONG_MAX;
	NodeT * minimum = NULL;
	double min = 9999999;

	while (current != NULL) {
		if (current->f < min) {
			minimum = current;
			min = current->f;
		}
		current = current->next;
	}
	return minimum->index;
}

unsigned long perform_binary_search(unsigned long key, unsigned long *list, unsigned long lenlist) {
	register unsigned long start = 0UL, afterend = lenlist, middle;
	register unsigned long try;
	while (afterend > start) {
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

double distance (Node * nodes, unsigned long node_start, unsigned long node_goal) {
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

int main (int argc, char* argv[]) {
	int i;
	unsigned long nnodes, ntotnsucc, ntotname, node_start, node_goal, node_current; //, node_successor;
	unsigned long *allsuccessors;
	char *allnames;
	Node *nodes;

	FILE *fin;

	if ((fin = fopen ("data/spain-data.bin", "r")) == NULL) {
		printf("the data file does not exist or cannot be opened\n");
	}

	/* Global data --- header */
	if ( fread(&nnodes, sizeof(unsigned long), 1, fin) +
	fread(&ntotnsucc, sizeof(unsigned long), 1, fin) +
	fread(&ntotname, sizeof(unsigned long), 1, fin) != 3 ) {
		printf("when reading the header of the binary data file\n");
	}

	/* getting memory for all data */
	if ((nodes = (Node *) malloc(nnodes*sizeof(Node))) == NULL) {
		printf("when allocating memory for the nodes vector\n");
	}
	if ((allsuccessors = (unsigned long *) malloc(ntotnsucc*sizeof(unsigned long))) == NULL) {
		printf("when allocating memory for the edges vector\n");
	}
	if ((allnames = (char *) malloc(ntotname*sizeof(char))) == NULL) {
		printf("when allocating memory for the names\n");
	}

	/* Reading all data from file */
	if ( fread(nodes, sizeof(Node), nnodes, fin) != nnodes ) {
		printf("when reading nodes from the binary data file\n");
	}
	if ( fread(allsuccessors, sizeof(unsigned long), ntotnsucc, fin) != ntotnsucc ) {
		printf("when reading sucessors from the binary data file\n");
	}
	if ( fread(allnames, sizeof(char), ntotname, fin) != ntotname ) {
		printf("when reading names from the binary data file\n");
	}
	fclose(fin);

	unsigned long *list;
	list = (unsigned long *)malloc(sizeof(unsigned long)*nnodes);
	for (i = 0; i < nnodes; i++) list[i] = nodes[i].id;

	//Setting pointers to successors
	for (i = 0; i < nnodes; i++) {
		if (nodes[i].nsucc) {
			nodes[i].successors = allsuccessors;
			allsuccessors += nodes[i].nsucc;
		}
	}

	//Setting pointers to names
	for (i = 0; i < nnodes; i++) {
		if (nodes[i].namelen) {
			nodes[i].name = allnames;
			allnames += nodes[i].namelen;
		}
	}

	NodeT * open_list = NULL;

	if ((node_start = perform_binary_search(240949599, list, nnodes)) == ULONG_MAX) {
		printf("Node start not found.\n");
	}
	if ((node_goal = perform_binary_search(195977239, list, nnodes)) == ULONG_MAX) {
		printf("Node goal not found.\n");
	}
	AStarStatus *status;
	status = (AStarStatus *)malloc(sizeof(AStarStatus)*nnodes);

	status[node_start].g = 0;
	status[node_start].h = distance(nodes, node_start, node_goal);
	status[node_start].whq = OPEN;
	push(&open_list, status[node_start].h, node_start);

	double successor_current_cost;


	while ((node_current = index_minimum(open_list)) != ULONG_MAX) {

		if (node_current == node_goal) {
			break;
		}

		for (i = 0; i < nodes[node_current].nsucc; i++) {
			unsigned long node_successor = nodes[node_current].successors[i];
			successor_current_cost = status[node_current].g + distance(nodes, node_current, node_successor);

			if (status[node_successor].whq == OPEN) {
				if (status[node_successor].g <= successor_current_cost){
					continue;
				}
			} else if (status[node_successor].whq == CLOSED) {
				if (status[node_successor].g <= successor_current_cost) continue;

				status[node_successor].whq = OPEN;
				push(&open_list, successor_current_cost + status[node_successor].h, node_successor);
			} else {
				status[node_successor].whq = OPEN;
				status[node_successor].h = distance(nodes, node_successor, node_goal);
				push(&open_list, (successor_current_cost + status[node_successor].h), node_successor);
			}

			status[node_successor].g = successor_current_cost;
			status[node_successor].parent = node_current;
		}
		status[node_current].whq = CLOSED;

		if ((remove_by_index(&open_list, node_current)) != 1) {
			printf("Remove failed.\n");
		}
	}
	if (node_current != node_goal) {
		printf("OPEN list is empty.\n");
	}

	// Print the route
	unsigned long * path;
	unsigned long next_node;
	i = 0;
	next_node = node_current;
	path = (unsigned long *)malloc(nnodes*sizeof(unsigned long));
	path[0] = next_node;
	while (next_node != node_start) {
		i++;
		next_node = status[next_node].parent;
		path[i] = next_node;
	}
	int path_length = i + 1;

	for (i = path_length-1; i >= 0;i--) {
		// printf("Node id: %lu, Distance: %.2f m, Name: %s\n", nodes[path[i]].id, status[path[i]].g, nodes[path[i]].name);
		printf("Node ID: %lu, Distance: %.2f m\n", nodes[path[i]].id, status[path[i]].g);
	}
}


