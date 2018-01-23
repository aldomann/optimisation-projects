// Code for Map Routing Problem (A* Algorithm)
// Authors: Alfredo Hernández <aldomann.designs@gmail.com>
//          Ruth Kristianingsih <ruth.kristianingsih@mathmods.eu>

void AStarAlgorithm ( vector <Node>∗ nodes, unsigned int numNodes, vector <short int> ∗numSuc, vector <AStarStatus> *AStarList, usigned long ∗startNode, usigned long ∗goalNode ) {
	unsigned int start = 0, goal = 0;
	if ( !(binarySearch(nodes, ∗ startNode, numNodes, &start) && binarySearch(nodes, ∗ goalNode, numNodes, &goal)) ) {
		cout << "Incorrect input \n";
		exit(EXIT FAILURE);
	}
	∗ startNode = start;
	∗ goalNode = goal;
	(*AStarList)[start].whq = open;
	(*AStarList)[start].h = ComputeWeight(&(∗nodes)[start], &(∗nodes)[goal]);

	list <unsigned int > openQueue (1, start);
	unsigned int node current = 0;

	while( !openQueue.empty() ) {
	// the openQueue is maintained sorted => every time we take an element from the beginning
		nodecurrent = ∗ openQueue.begin();
		if ( nodecurrent == goal ) {
			break;
		}
		for ( int j = 0; j < (*nodes)[nodecurrent].nSucc; j ++) {
			bool flag = false;
			double succCurrentCost = (∗AStarList)[node current].g +
			(*nodes)[nodecurrent].successors[j].weight;
			if ( (*AStarList)[(*nodes)[nodecurrent].successors[j].node].whq == open ) {
				if ( (*AStarList)[(*nodes)[nodecurrent].successors[j].node].g <= succCurrentCost ) {
					continue;
				}
			} elseif ( (*AStarList)[(*nodes)[nodecurrent].successors[j].node].whq == closed ) {
				if ( (*AStarList)[(*nodes)[nodecurrent].successors[j].node].g <= succCurrentCost ) {
					continue;
				}
				flag = true;
				(*AStarList)[(*nodes)[nodecurrent].successors[j].node].whq = open;
			} else {
				flag = true;
				(*AStarList)[(*nodes)[nodecurrent].successors[j].node].whq = open;
				(*AStarList)[(*nodes)[nodecurrent].successors[j].node].h =
				ComputeWeight (&(∗ nodes )[(*nodes)[nodecurrent].successors[j].node], &(∗ nodes )[goal]);
			}
			(*AStarList)[(*nodes)[nodecurrent].successors[j].node].g = succCurrentCost;
			(*AStarList)[(*nodes)[nodecurrent].successors[j].node].parent = nodecurrent;
			// the thing is that we want to update the position in the queue =>
			// if the element was there before we firstly remove it, then insert.
			if (! flag ) {
				openQueue.remove((*nodes)[nodecurrent].successors[j].node);
			}
			insertInQueue(AStarList, &openQueue, (*nodes)[nodecurrent].successors[j].node);
		}
		(*AStarList)[nodecurrent].whq = closed;
		if ( nodecurrent == ∗ openQueue.begin() )
		openQueue.popfront();
		else
		openQueue.remove(nodecurrent);
	}
	if ( nodecurrent != goal ) {
	cout << " \n Error: open list is empty\n";
	exit (EXIT FAILURE );
	}
}
