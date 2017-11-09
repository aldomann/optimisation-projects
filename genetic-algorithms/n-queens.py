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

MAX_QUEENS = 10
nQueens = int(sys.argv[1])

if nQueens > MAX_QUEENS:
	print("That's too much, man!")
	exit()

POP_SIZE = int(sys.argv[2])

MAX_FIT = nQueens * (nQueens - 1)
MUTATE = 0.000001
MUTATE_FLAG = True
MAX_ITER = 100000
POPULATION = None

class BoardPermutation:
	def __init__(self):
		self.sequence = None
		self.fitness = None
	def setSequence(self, val):
		self.sequence = val
	def setFitness(self, fitness):
		self.fitness = fitness
	def getAttr(self):
		return { 'sequence':sequence, 'fitness':fitness }

def generateChromosome():
	# Randomly generates a sequence of board states.
	init_distribution = np.arange(nQueens)
	np.random.shuffle(init_distribution)
	return init_distribution

def fitness(chromosome = None):
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

def generatePopulation(population_size = 100):
	POPULATION = population_size
	# Create the different boards
	population = [BoardPermutation() for i in range(population_size)]
	for i in range(population_size):
		population[i].setSequence(generateChromosome())
		population[i].setFitness(fitness(population[i].sequence))

	return population

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


population = generatePopulation(POP_SIZE)
# get_good_queens(population)
find_good_queen(population)
