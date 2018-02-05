#!/bin/python3
# Authors: Alfredo Hern?dez <aldomann.designs@gmail.com>
#          Ruth Kristianingsih <ruth.kristianingsih30@gmail.com>
#
# Description
#	Script to solve the following problem using Simulated Annealing:
#	We have to load a truck with some goods and it can carry a maximum weight of 600 Kg.
#	We want to maximize the total value of the taken goods.
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
import pandas as pd
import os

home = os.path.expanduser("~/Code/R/optimisation-projects/simulated-annealing")
os.chdir(os.path.join(home))

MAX_TEMP = 100
MAX_ITER = 500000

# Old code
# values, weights = np.genfromtxt('data.dat', delimiter=',').transpose()

# Praise Bill
data = pd.read_csv('data.dat')
values = np.array(data["values"])
weights = np.array(data["weights"])

ind = np.ones(len(values))
# Gotta decide the shape of these arrays
#inds = np.empty(shape = [len(values)], dtype="float64")
inds = np.empty(0)
temp = np.empty(0)
prob = np.empty(0)
solution = np.empty(0)

inds = np.append(inds, 2)

def get_value(ind, values, weights):
	a = sum(ind * weights)
	if (a <= 600):
		b = sum(ind * values)
	else:
		b = - sum(ind * weights)**100
	return b

# Testing the function
get_value(ind, values, weights)
