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

n.iter = nrow(results)

write.csv(results, "results.csv")

tail(weights)
print(solution)

gg.value <- ggplot(results) +
	geom_point(aes(x = seq(1:n.iter), y = tot.value), size = 0.5) +
	labs(title = "",
			 x = "Time step (iteration)",
			 y = "Total value of the items")

ggc.weight <- ggplot(results) +
	geom_point(aes(x = seq(1:n.iter), y = tot.weight), size = 0.5) +
	labs(title = "",
			 x = "Time step (iteration)",
			 y = "Total weight of the items")

gg.temp <- ggplot(results) +
	geom_point(aes(x = seq(1:n.iter), y = temp)) +
	labs(title = "",
			 x = "Time step (iteration)",
			 y = "Temperature")


gg.value
gg.weight
gg.temp
