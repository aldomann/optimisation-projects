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

import itertools as it

MAX_QUEENS = 10
while True:
		nQueens = int(input("How many queens? "))
		if nQueens > MAX_QUEENS:
				print("That's too much, man! \n")
				continue
		else: break

MAX_FIT = nQueens * (nQueens - 1)

allQueens = list(it.permutations(range(nQueens)))

def fitness(chromosome = None):
	clashes = 0
	# Calculate diagonal clashes
	for i in range(len(chromosome)):
		for j in range(len(chromosome)):
			if ( i != j ):
				dx = abs(i-j)
				dy = abs(chromosome[i] - chromosome[j])
				if(dx == dy):
					clashes += 1
	return (MAX_FIT - clashes)

def get_all_queens():
	for queen in range(len(allQueens)):
		print("queen", queen, ":", allQueens[queen], fitness(allQueens[queen]) )

def get_good_queens():
	good = 0
	for queen in range(len(allQueens)):
		fit = fitness(allQueens[queen])
		if ( fit == MAX_FIT ):
			good += 1
			print("Q", queen, ":", allQueens[queen], "fitness =", fit )
	print("There are", good, "non-fundamental solutions.")

get_good_queens()


