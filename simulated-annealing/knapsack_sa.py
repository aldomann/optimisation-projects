#!/bin/python3
# Authors: Alfredo Hernández <aldomann.designs@gmail.com>
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
from math import exp, log, tanh
import os

home = os.path.expanduser("~/Code/R/optimisation-projects/simulated-annealing")
os.chdir(os.path.join(home))

MAX_TEMP = 100
MAX_ITER = 500000

# Read the items data
data = pd.read_csv('data.csv')
values = np.array(data["values"])
weights = np.array(data["weights"])
num_items = len(data)

# Initialise arrays
individual = np.random.randint(2, size = num_items)
temp = np.empty(MAX_ITER, dtype=float)
prob = np.empty(MAX_ITER, dtype=float)
sol_values = np.empty(MAX_ITER, dtype=int)
sol_weights = np.empty(MAX_ITER, dtype=int)


def get_weight(individual, weights):
	return int(np.sum(individual * weights))

def get_value(individual, values, weights):
	total_weight = get_weight(individual, weights)
	if (total_weight <= 600):
		total_value = np.sum(individual * values)
	else:
		total_value = - pow(total_weight, 100)
	return int(total_value)

def random_bool():
	return np.random.randint(2)

def simulated_annealing(individual, MAX_ITER):
	for iter in range(0, MAX_ITER):
		# Temperature cooling schedule
		temp[iter] = MAX_TEMP * 0.5 * (tanh(-log(iter+1) + 10) + 1 )

		# Exploring the neighbourhood
		individual_new = np.copy(individual)
		for m in range(0, 5):
			index = np.random.randint(num_items)
			individual_new[index] = random_bool()

		# Total value of items inside the truck
		value_old = get_value(individual, values, weights)
		value_new = get_value(individual_new, values, weights)

		# Acceptance probabilities
		if (value_old < value_new):
			prob[iter] = 1
		else:
			prob[iter] = exp(-(value_old - value_new) / temp[iter])

		# Acceptance rule
		if (float(np.random.random(1)) < prob[iter]):
			individual = np.copy(individual_new)

		# Update total value and weight
		sol_values[iter] = get_value(individual, values, weights)
		sol_weights[iter] = get_weight(individual, weights)
	return individual

# Run Simulated Annealing
solution = simulated_annealing(individual, MAX_ITER)

# Transform NumPy arrays to list, to read them in R
sol_values = sol_values.tolist()
sol_weights = sol_weights.tolist()
temp = temp.tolist()
prob = prob.tolist()
solution = solution.tolist()
