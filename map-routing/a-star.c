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

#include "functions.h"

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

	DynamicNode *open_list = NULL;

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
	status[node_start].queue_status = OPEN;
	append(&open_list, status[node_start].h_cost, node_start);

	// A* Algorithm
	astar_algorithm(nodes, open_list, status, node_start, node_goal, nnodes);
}
