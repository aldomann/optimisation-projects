#!/bin/python3
# Author: Alfredo Hernández <aldomann.designs@gmail.com>
#
# Description
#	Script to solve the 8 queens problem using genetic algorithms
#
# Legal Stuff:
#	This script is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, version 3.

#	This script is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#	GNU General Public License for more details.

#	You should have received a copy of the GNU General Public License
#	along with this script. If not, see <http://www.gnu.org/licenses/>.

import numpy as np
import sys
import random

MAX_QUEENS = 20
N_QUEENS = int(sys.argv[1])

if N_QUEENS > MAX_QUEENS:
	print("That's too much, man!")
	exit()

MAX_FIT = N_QUEENS * (N_QUEENS - 1)
TOURN_SIZE = int(sys.argv[4])
MUTATE_FLAG = True
MUTATE_PROB = float(sys.argv[3])
MAX_ITER = 10000
POPULATION = int(sys.argv[2])

VERBOSE_FLAG = True

WRITE_FLAG = False
if (WRITE_FLAG):
	import csv

class BoardPermutation:
	def __init__(self):
		self.sequence = None
		self.fitness = None
	def set_sequence(self, val):
		self.sequence = val
	def set_fitness(self, fitness):
		self.fitness = fitness
	def get_attr(self):
		return { 'sequence' : sequence, 'fitness' : fitness }


def generate_chromosome():
	# Randomly generates a sequence of board states.
	init_distribution = np.arange(N_QUEENS)
	np.random.shuffle(init_distribution)
	return init_distribution

def assess_fitness(chromosome = None):
	clashes = 0
	# Calculate diagonal clashes
	for i in range(len(chromosome)):
		for j in range(len(chromosome)):
			if ( i != j):
				dx = abs(i-j)
				dy = abs(chromosome[i] - chromosome[j])
				if(dx == dy):
					clashes += 1
	return (MAX_FIT - clashes)

def generate_population(population_size = 100):
	# Create the different boards
	population = [BoardPermutation() for i in range(population_size)]
	for i in range(population_size):
		population[i].set_sequence(generate_chromosome())
		population[i].set_fitness(assess_fitness(population[i].sequence))
	return population

def get_parent(population = None):
	# Get parent using a Tournament Selection algorithm
	best_board = random.randint(0, len(population) - 1)
	for i in range(1,TOURN_SIZE):
		next_board = random.randint(0, len(population) - 1)
		if ( population[next_board].fitness > population[best_board].fitness ):
			best_board = next_board
	return best_board

def mutate(board = None):
	# Mutate a board using a mask
	if random.random() < MUTATE_PROB :
		a, b = random.sample(range(N_QUEENS), 2)
		while (b == a): # To ensure a true mutation
			b = random.sample(range(N_QUEENS), 1)
		population[board].sequence[a], population[board].sequence[b] = population[board].sequence[b], population[board].sequence[a]

def ordered_crossover(ind1 = None, ind2 = None):
	# Ordered crossover
	a, b = random.sample(range(N_QUEENS), 2)
	if a > b:
			a, b = b, a
	holes1, holes2 = [True]*N_QUEENS, [True]*N_QUEENS
	for i in range(N_QUEENS):
		if i < a or i > b:
			holes1[ind2[i]] = False
			holes2[ind1[i]] = False
	# We must keep the original values somewhere before scrambling everything
	temp1, temp2 = ind1, ind2
	k1 , k2 = b + 1, b + 1
	for i in range(N_QUEENS):
		if not holes1[temp1[(i + b + 1) % N_QUEENS]]:
			ind1[k1 % N_QUEENS] = temp1[(i + b + 1) % N_QUEENS]
			k1 += 1
		if not holes2[temp2[(i + b + 1) % N_QUEENS]]:
			ind2[k2 % N_QUEENS] = temp2[(i + b + 1) % N_QUEENS]
			k2 += 1
	# Swap the content between a and b (included)
	for i in range(a, b + 1):
		ind1[i], ind2[i] = ind2[i], ind1[i]

################################################################

def find_good_queen(population = None):
	global good
	# Look for a good board
	for board in range(len(population)):
		if ( population[board].fitness == MAX_FIT ):
			if VERBOSE_FLAG:
				print("Found a non-fundamental solution on generation", iteration)
				print( "Q",  board, ":", population[board].sequence, "fitness:", population[board].fitness )
			good = True
			return True

def genetic_algorithm(MAX_ITER):
	global iteration
	for iteration in range(MAX_ITER):
		# Select parents
		parent1 = get_parent(population)
		parent2 = get_parent(population)
		ordered_crossover(population[parent1].sequence, population[parent2].sequence)
		# Mutate children
		if(MUTATE_FLAG):
			mutate(parent1)
			mutate(parent2)
		# Reassess fitness
		population[parent1].set_fitness(assess_fitness(population[parent1].sequence))
		population[parent2].set_fitness(assess_fitness(population[parent2].sequence))
		# Stop the algorithm
		if find_good_queen(population):
			if(WRITE_FLAG):
				with open('results.csv', 'a') as csvfile:
					writer = csv.writer(csvfile)
					writer.writerow([N_QUEENS, POPULATION, MUTATE_PROB, TOURN_SIZE, iteration])
			break

################################################################

population = generate_population(POPULATION)
good = False
genetic_algorithm(MAX_ITER)
if VERBOSE_FLAG and not good:
	print("Couldn't find any solution in", MAX_ITER, "generations.")
