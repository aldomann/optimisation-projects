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

typedef struct {
	unsigned long id; // Node identification
	unsigned short namelen;
	char *name;
	double lat, lon; // Node position
	unsigned short nsucc; // Number of node successors; i. e. length of successors
	unsigned long *successors;
} node;

unsigned long BinarySearch(unsigned long key, node *nodes, unsigned long lenlist) {
	register unsigned long start = 0UL, afterend = lenlist, middle;
	register unsigned long try;
	while ( afterend > start ) {
		middle = start + ((afterend-start-1)>>1);
		try = nodes[middle].id;
		if ( key == try ) {
			return middle;
		} else if ( key > try ) {
			start = middle+1;
		} else {
			afterend = middle;
		}
	}
	return ULONG_MAX;
}

int main(int argc, char* argv[]) {

	int j = 0, n = 0;
	unsigned long i = 0;

	char *buffer,*field;
	size_t bufsize = 79857;
	size_t bytes_read;
	buffer = (char *)malloc(sizeof(char) * bufsize);
	field = (char *)malloc(sizeof(char) * 184);

	node *nodes;
	unsigned long nnodes = 23895681UL;
	nodes = (node *) malloc(nnodes*sizeof(node));
	unsigned long *way;
	way = (unsigned long *)malloc(sizeof(unsigned long) * 5306);

	// READING NODES
	FILE *file;

	file = fopen("data/spain-nodes.csv","r");
	printf("Starting to read nodes...\n");
	while((bytes_read = getline(&buffer,&bufsize,file)) != -1) {
		field = strsep(&buffer,"|");
		field = strsep(&buffer,"|");
		if((nodes[i].id = strtoul(field,'\0',10)) == 0) printf("ERROR: Conversion failed.\n");
		field = strsep(&buffer,"|");
		nodes[i].namelen = strlen(field)+1;
		nodes[i].name = (char *) malloc(nodes[i].namelen*sizeof(char));
		strcpy(nodes[i].name,field);
		field = strsep(&buffer,"|");
		nodes[i].lat = atof(field);
		field = strsep(&buffer,"|");
		nodes[i].lon = atof(field);
		i++;
		if(i % 500000 == 0) {
			double x = ((100*(double)i)/(double)nnodes);
			printf("%.2f percent of the nodes have been read.\n",x);
		}
	}

	i = 0;
	bytes_read = 0;
	printf("100 percent of the nodes have been read.\n");
	fclose(file);

	// READING WAYS
	file = fopen("data/spain-ways.csv","r");

	unsigned long a,b,A,B,member,waylen,index;
	bool oneway;

	for (i = 0; i < nnodes; i++) {
		if((nodes[i].successors = (unsigned long *)malloc(sizeof(unsigned long)*16)) == NULL) {
			printf("Memory allocation for the successors failed at node %lu\n",i);
			break;
		}
	}
	i = 0;
	printf("\nStarting to read ways...\n");
	while((bytes_read = getline(&buffer,&bufsize,file)) != -1) {
		i++;
		field = strsep(&buffer,"|");
		field = strsep(&buffer,"|");
		field = strsep(&buffer,"|");
		if (strlen(field)>0) {
			oneway = 1;
		} else {
			oneway = 0;
		}

		while((field = strsep(&buffer,"|")) != NULL) {
			member = strtoul(field,'\0',10);
			if((index = BinarySearch(member, nodes, nnodes)) != ULONG_MAX) {
					way[n] = member;
					n++;
			}
		}
		waylen = n;
		n = 0;

		for (j = 0; j < waylen-1; j++) {
			A = way[j];
			a = BinarySearch(A, nodes, nnodes);
			B = way[j+1];
			b = BinarySearch(B, nodes, nnodes);

			nodes[a].successors[nodes[a].nsucc] = b;
			nodes[a].nsucc++;

			if(oneway == 0) {
				nodes[b].successors[nodes[b].nsucc] = a;
				nodes[b].nsucc++;
			}
		}

		if(i % 500000 == 0) {
			double x = ((100*(double)i)/(double)nnodes);
			printf("%.2f percent of the ways have been read.\n",x);
		}
	}

	printf("100 percent of the ways have been read.\n");
	fclose(file);
	free(buffer); free(field);

	// CREATING BIN FILE
	const char filename[] = "data/spain-data.bin";

	unsigned long ntotnsucc = 0UL;
	for (i = 0; i < nnodes; i++) {
		ntotnsucc += nodes[i].nsucc;
	}

	unsigned long ntotname = 0UL;
	for (i = 0; i < nnodes; i++) {
		ntotname += nodes[i].namelen;
	}
	printf("Starting to write the bin file.\n");

	if ((file = fopen (filename, "wb")) == NULL) printf("The output binary data file cannot be opened.\n");

	// Global data --- header
	if( fwrite(&nnodes, sizeof(unsigned long), 1, file) +
	fwrite(&ntotnsucc, sizeof(unsigned long), 1, file) +
	fwrite(&ntotname, sizeof(unsigned long), 1, file)!= 3 ) {
		printf("Error when initializing the output binary data file.\n");
	}

	// Writing all nodes
	if( fwrite(nodes, sizeof(node), nnodes, file) != nnodes ) {
		printf("Error when writing nodes to the output binary data file.\n");
	}

	// Writing sucessors in blocks
	for (i = 0; i < nnodes; i++) if(nodes[i].nsucc) {
		if( fwrite(nodes[i].successors, sizeof(unsigned long), nodes[i].nsucc, file) != nodes[i].nsucc ) {
			printf("Error when writing edges to the output binary data file.\n");
		}
	}

	// Writing names in blocks
	for (i = 0; i < nnodes; i++) if(nodes[i].namelen) {
		if( fwrite(nodes[i].name, sizeof(char), nodes[i].namelen, file) != nodes[i].namelen ) {
			printf("Error when writing names to the output binary data file.\n");
		}
	}

	fclose(file);

	return 0;
}
