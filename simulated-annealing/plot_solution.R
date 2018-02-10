# Authors:
#	Alfredo Hernández <aldomann.designs@gmail.com>
#	Ruth Kristianingsih <ruth.kristianingsih30@gmail.com>

# Libraries ------------------------------------------------

library(tidyverse)
library(rPython)

# setwd("simulated-annealing/")


# Run SA in Python -----------------------------------------

python.load("knapsack_sa.py")

values <- python.get("sol_values")
weights <- python.get("sol_weights")
temps <- python.get("temp")
probs <- python.get("prob")
solution <- python.get("solution")

results <- data.frame(tot.value = values,
											tot.weight = weights,
											temp = temps,
											prob = probs)

# write.csv(results, "results.csv")

tail(weights)
print(solution)

ggplot(results) +
	geom_path(aes(y = probs))
