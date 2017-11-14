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
import itertools as it
import sys


MAX_QUEENS = 10
nQueens = int(sys.argv[1])

if nQueens > MAX_QUEENS:
	print("That's too much, man!")
	exit()

MAX_FIT = nQueens * (nQueens - 1)


class BoardPermutation:
	def __init__(self):
		self.sequence = None
		self.fitness = None
	def setSequence(self, val):
		self.sequence = val
	def setFitness(self, fitness):
		self.fitness = fitness
	def getAttr(self):
		return { 'sequence' : sequence, 'fitness' : fitness }


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

def generateFullPopulation():
	# Create all the boards
	allPerms = list( it.permutations(range(nQueens)) )
	population_size = len(allPerms)
	population = [BoardPermutation() for i in range(population_size)]
	for i in range(population_size):
		population[i].setSequence(allPerms[i])
		population[i].setFitness(fitness(population[i].sequence))

	return population

def get_good_queens(population = None):
	# Print all solutions
	good = 0
	for board in range(len(population)):
		if ( population[board].fitness == MAX_FIT ):
				good += 1
				print( "Q",  board, ":", population[board].sequence, "fitness:", population[board].fitness )
	print("There are", good, "non-fundamental solutions.")


population = generateFullPopulation()
get_good_queens(population)


