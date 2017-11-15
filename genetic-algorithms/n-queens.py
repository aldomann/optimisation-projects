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

MAX_QUEENS = 10
N_QUEENS = int(sys.argv[1])

if N_QUEENS > MAX_QUEENS:
	print("That's too much, man!")
	exit()

MAX_FIT = N_QUEENS * (N_QUEENS - 1)
# MUTATE = 0.000001
MUTATE = 0.1
MUTATE_FLAG = True
MAX_ITER = 100000
POPULATION = int(sys.argv[2])


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

def get_parent(population):
	# Get parent using a Tournament Selection algorithm
	best_board = random.randint(0, len(population) - 1)
	tournament_size = 3
	for i in range(2,tournament_size):
		next_board = random.randint(0, len(population) - 1)
		if ( population[next_board].fitness > population[best_board].fitness ):
			best_board = next_board
	return best_board

def mutate(board):
	# Mutate a board using a mask
	# TODO: implement MUTATE_FLAG in main algorithm
	if random.random() < MUTATE :
		a, b = random.randint(0, N_QUEENS - 1), random.randint(0, N_QUEENS - 1)
		while (b == a): # To ensure a true mutation
			b = random.randint(0, N_QUEENS - 1)
		population[board].sequence[a], population[board].sequence[b] = population[board].sequence[b], population[board].sequence[a]
		# print("CANCER!", a, "<->", b)
	# else:
		# print("No mutation :)")

def pmx_crossover(board_a, board_b):
	# Choose crossover points
	cx1 = random.randint(0, N_QUEENS - 1)
	cx2 = random.randint(0, N_QUEENS - 1)
	if cx1 > cx2: # Swap the two cx points
		print ("swapping")
		cx1, cx2 = cx2, cx1
	print("cx1:", cx1, "cx2:", cx2)
	# Apply crossover
	temp_a = []
	temp_b = []
	for i in range(cx1, cx2 + 1):
		# Keep track of the selected values
		temp_a.append(board_a[i])
		temp_b.append(board_b[i])

	for i in range(len(temp_a)):
		print(temp_a[i], "<->",temp_b[i])
		# Swap values on board_a
		board_a[board_a.tolist().index(temp_a[i])], \
		board_a[board_a.tolist().index(temp_b[i])] = \
		board_a[board_a.tolist().index(temp_b[i])], \
		board_a[board_a.tolist().index(temp_a[i])]
		# Swap values on board_b
		board_b[board_b.tolist().index(temp_a[i])], \
		board_b[board_b.tolist().index(temp_b[i])] = \
		board_b[board_b.tolist().index(temp_b[i])], \
		board_b[board_b.tolist().index(temp_a[i])]

def uniform_crossover(board_a, board_b, prob=0.1):
	# Swap individual indexes with probability prob
	for i in range(N_QUEENS):
		if random.random() < prob:
			print(i)
			board_a[i], board_b[i] = board_b[i], board_a[i]

def ux_mask_crossover(board_a, board_b):
	# Fancy stuff
	pass


################################################################

def stop_condition():
	# It stops the GA when a solution is found
	# TODO: implement this in main algorithm
	fitnessvals = [pos.fitness for pos in population]
	if MAX_FIT in fitnessvals:
		return True
	if MAX_ITER == iteration:
		return True
	return False

################################################################

def get_good_queens(population = None):
	good = 0
	for board in range(len(population)):
		if ( population[board].fitness == MAX_FIT ):
				good += 1
				print( "Q",  board, ":", population[board].sequence, "fitness:", population[board].fitness )
	print("There are", good, "non-fundamental solutions.")

def find_good_queen(population = None):
	good = False
	for board in range(len(population)):
		if ( population[board].fitness == MAX_FIT ):
			good = True
			print("Found a non-fundamental solution.")
			print( "Q",  board, ":", population[board].sequence, "fitness:", population[board].fitness )
			break
	if ( good == False ):
		print("Couldn't find any solution.")

################################################################

population = generate_population(POPULATION)
# get_good_queens(population)
find_good_queen(population)

print(population[1].sequence)
print(population[2].sequence)
# pmx_crossover(population[1].sequence, population[2].sequence)
uniform_crossover(population[1].sequence, population[2].sequence)
print(population[1].sequence)
print(population[2].sequence)

# get_parent(population)


# for board in range(len(population)):
# 	print(population[board].sequence)
# 	mutate(board)
# 	print(population[board].sequence)
# 	print()
