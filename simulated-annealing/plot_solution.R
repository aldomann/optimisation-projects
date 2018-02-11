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

results <- data.frame(iter = seq(1:n.iter),
											tot.value = values,
											tot.weight = weights,
											temp = temps,
											prob = probs)

n.iter = nrow(results)

write.csv(results, "results.csv")


# Plot results ---------------------------------------------

small.results <- results[sample(nrow(results), 10000), ]

gg.value <- ggplot(small.results) +
	geom_point(aes(x = iter, y = tot.value), colour = "slateblue2",
						 size = 0.1, alpha = 1) +
	labs(x = "Time Step (Iteration)",
			 y = "Total Value of the Items")

gg.weight <- ggplot(small.results) +
	geom_point(aes(x = iter, y = tot.weight), colour = "seagreen3", size = 0.1) +
	labs(x = "Time Step (Iteration)",
			 y = "Total Weight of the Items")

gg.temp <- ggplot(results) +
	geom_line(aes(x = iter, y = temp), colour = "lightcoral") +
	labs(x = "Time Step (Iteration)",
			 y = "Temperature")

gg.value + theme_bw() #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "value.pdf", width = 6, height = 3, dpi = 96, device = cairo_pdf)
gg.weight + theme_bw() #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "weight.pdf", width = 6, height = 3, dpi = 96, device = cairo_pdf)
gg.temp + theme_bw() #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "temp.pdf", width = 6, height = 3.5, dpi = 96, device = cairo_pdf)
