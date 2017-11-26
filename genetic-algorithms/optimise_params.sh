#!/bin/bash

# Script to find the "optimal" parameters for the N Queens Problem
# Author: Alfredo Hernández <aldomann.designs@gmail.com>


# Python and its libraries are provided by Anaconda 3
# anacondainit

# Looping over N
for (( N = 8; N <= 10; N ++ )); do
	echo 'Running the Genetic Algorithm for N =' $N
	# Looping over POPULATION
	for (( P = 50; P <= 50 * N ; P += 50 )); do
		# Looping over MUTATE_PROB
		# for (( M = 5; M <= 10; M ++ )); do
		for M in 0.005 0.006 0.007 0.008 0.009 0.01; do
			# 100 runs for each tuple
			for (( i = 0; i < 100; i++ )); do
				python n-queens.py $N $P $M 2
			done
		done
	done
done
