# Comparison between brute force methods complexity for the N queen puzzle
# Author: Alfredo Hernández <aldomann.designs@gmail.com>

library(tidyverse)

# Raw data -------------------------------------------------

n <- c(1, 4, 5, 6, 7, 8, 9, 10)
sols <- c(1, 1, 2, 1, 6, 12, 46, 92)
all <- n^n
perms <- factorial(n)

# Data visualisation ---------------------------------------

# First method (stacked)
queens.df <- data.frame(cbind(n,sols,all,perms))

queens.plot <- ggplot(queens.df, aes(x = as.factor(n))) +
	geom_bar(aes(y = all, fill = "all"), stat = "identity") +
	geom_bar(aes(y = perms, fill = "perms"), stat = "identity") +
	geom_bar(aes(y = sols, fill = "sols"), stat = "identity") +
	scale_fill_manual(values = c("all" = "brown1", "perms" = "slateblue", "sols" = "limegreen")) +
	scale_y_log10() +
	labs(title =  "Comparison of brute force complexity for the N queens problem",
			 x = "Board size (N)", y = "Count", fill = "Type")

# Second method (dodge)
library(reshape2)
queens.df2 <- melt(data.frame(cbind(n,all,perms,sols)),id.vars = 1)

queens.plot.dodge <- ggplot(queens.df2, aes(x = as.factor(n), y = value)) +
	geom_bar(aes(fill = variable),stat = "identity",position = "dodge") +
	scale_fill_manual(values = c("all" = "brown1", "perms" = "slateblue", "sols" = "limegreen")) +
	scale_y_log10() +
	labs(title =  "Comparison of brute force complexity for the N queens problem",
			 x = "Board size (N)", y = "Count", fill = "Type")


queens.plot + theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "queens-sols-alt.pdf", width = 5.75, height = 3.75, dpi = 96, device = cairo_pdf)

queens.plot.dodge + theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "queens-sols.pdf", width = 5.75, height = 3.75, dpi = 96, device = cairo_pdf)
