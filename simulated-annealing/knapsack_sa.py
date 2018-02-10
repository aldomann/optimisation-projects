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

data = pd.read_csv('data.dat')
values = np.array(data["values"])
weights = np.array(data["weights"])

ind = np.random.randint(2, size = len(data))
inds = np.empty(0)
temp = np.empty(0)
prob = np.empty(0)
solution = np.empty(0)


def get_value(ind, values, weights):
	total_weight = sum(ind * weights)
	if (total_weight <= 600):
		total_value = sum(ind * values)
	else:
		total_value = - total_weight**100
	return total_value

def random_walk():
	return np.random.randint(2)

def moving_average(arr, n = 100):
	res = arr
	for i in range(n, len(arr)):
		res[i] = np.mean(arr[(i-n):i])
	return res


