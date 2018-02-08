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
#include <math.h>
#include <string.h>
#include <float.h>
#include <stdbool.h>
#include <limits.h>

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
	Queue queue_status;
} AStarStatus;

typedef struct Node {
	double f_cost;
	unsigned long index;
	struct Node *next;
} DynamicNode;

// Linked List functions
void push(DynamicNode **head, double f_cost, unsigned long index);
int remove_first(DynamicNode **head);
int remove_by_index(DynamicNode **head, unsigned long index);
unsigned long index_minimum(DynamicNode *head);

// Binary Search function
unsigned long perform_binary_search(unsigned long key, unsigned long *list, unsigned long lenlist);

// Haversine Distance function
double distance (Node *nodes, unsigned long node_start, unsigned long node_goal);

// Function to print path
void print_path (Node *nodes, AStarStatus *status, unsigned long node_start, unsigned long node_goal, unsigned long node_current, unsigned long nnodes);

// A* Algorithm
void astar_algorithm (Node *nodes, DynamicNode *open_list, AStarStatus *status, unsigned long node_start, unsigned long node_goal, unsigned long nnodes );
