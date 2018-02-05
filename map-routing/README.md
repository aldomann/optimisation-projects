# A* Algorithm

This project consists in computing an optimal path (according to distance, not time) from Basílica de Santa Maria del Mar (Plaça de Santa Maria) in Barcelona to the Giralda (Calle Mateos Gago) in Sevilla by using the A* algorithm.

As the reference starting node for Basílica de Santa Maria del Mar (Plaça de Santa Maria) in Barcelona we will take the node with key (@id) 240949599 whils the goal node close to Giralda (Calle Mateos Gago) in Sevilla will be the node with key (@id) 195977239.

This repository contains an implementation in C for such purpose. The `createbin.c` program reads the RAW `.csv` files to create a graph in a binary file, whilst the `a-star.c` contains the A* algorithm to find the optimal path.

A previous pre-processing of the RAW `.csv` files is required using AWK.
