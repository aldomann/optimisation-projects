#!/bin/bash

# Script to find the "optimal" parameters for the N Queens Problem
# Author: Alfredo Hernández <aldomann.designs@gmail.com>

N=8

echo 'Running the Genetic Algorithm for N =' $N
# Looping over POPULATION
for (( P = 50; P <= 50 * N ; P += 10 )); do
	echo 'Running with POPULATION =' $P
	# Looping over MUTATE_PROB
	for M in 0.00500 0.00525 0.00550 0.00575 0.00600 0.00625 0.00650 0.00675 0.00700 0.00725 0.00750 0.00775 0.00800 0.00825 0.00850 0.00875 0.00900 0.00925 0.00950 0.00975 0.01000; do
		# 100 runs for each tuple
		for (( i = 0; i < 100; i++ )); do
			python n-queens.py $N $P $M 2
		done
	done
done
