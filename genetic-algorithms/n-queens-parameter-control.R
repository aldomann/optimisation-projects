# Comparison between brute force methods complexity for the N queen puzzle
# Author: Alfredo Hernández <aldomann.designs@gmail.com>

library(tidyverse)


# Read data and split into data frames ---------------------

results.df <- read.csv("genetic-algorithms/results_all.csv",
											 col.names = c("N","pop.size", "mutate.prob", "iteration"))

eight.df <- results.df %>%
	filter(N == 8) %>%
	select(-N)

nine.df <- results.df %>%
	filter(N == 9) %>%
	select(-N)

ten.df <- results.df %>%
	filter(N == 10) %>%
	select(-N)

eight.df <- eight.df %>%
	group_by(pop.size, mutate.prob) %>%
	summarise(iteration = mean(iteration))

nine.df <- nine.df %>%
	group_by(pop.size, mutate.prob) %>%
	summarise(iteration = mean(iteration))

ten.df <- ten.df %>%
	group_by(pop.size, mutate.prob) %>%
	summarise(iteration = mean(iteration))


# Data visualisation ---------------------------------------

color_palette <- c('#d7191c','#fdae61','#ffffbf','#abd9e9','#2c7bb6')

plot_heatmap <- function(n.df){
	ggplot(n.df, aes(x = pop.size, y = mutate.prob)) +
		geom_tile(aes(fill = iteration)) +
		scale_fill_gradientn(colours = color_palette) +
		labs(x = "Population size", y = "Mutation probability",
					 fill = "Iteration") +
		theme_bw()
}

plot_heatmap(eight.df) + theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "params_8.pdf", width = 4.8, height = 3, dpi = 96, device = cairo_pdf)
plot_heatmap(nine.df) + theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "params_9.pdf", width = 5.3, height = 3, dpi = 96, device = cairo_pdf)
plot_heatmap(ten.df) + theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "params_10.pdf", width = 5.7, height = 3, dpi = 96, device = cairo_pdf)
