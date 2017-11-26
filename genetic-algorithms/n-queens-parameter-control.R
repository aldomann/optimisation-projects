# Comparison between brute force methods complexity for the N queen puzzle
# Author: Alfredo Hernández <aldomann.designs@gmail.com>

library(tidyverse)
library(scales)

# Read data and split into data frames ---------------------

# Analysis of N Queens Problem for N = 8,9,10
results.df <- read.csv("genetic-algorithms/results_all.csv",
											 col.names = c("N","pop.size", "mutate.prob", "tourn.size", "iteration"))

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

# Granular analysis of 8 Queens Problem
results8b.df <- read.csv("genetic-algorithms/results_8_pop_mut.csv",
												 col.names = c("N","pop.size", "mutate.prob", "tourn.size", "iteration"))

eightb.df <- results8b.df %>%
	select(-N) %>%
	group_by(pop.size, mutate.prob) %>%
	summarise(iteration = mean(iteration))

# Population size = 100
results8c.df <- read.csv("genetic-algorithms/results_8_100_tau_mut.csv",
												 col.names = c("N","pop.size", "mutate.prob", "tourn.size", "iteration"))

eightc.df <- results8c.df %>%
	select(-N) %>%
	group_by(tourn.size, mutate.prob) %>%
	summarise(iteration = mean(iteration))

# Population size = 350
results8d.df <- read.csv("genetic-algorithms/results_8_350_tau_mut.csv",
												 col.names = c("N","pop.size", "mutate.prob", "tourn.size", "iteration"))

eightd.df <- results8d.df %>%
	select(-N) %>%
	group_by(tourn.size, mutate.prob) %>%
	summarise(iteration = mean(iteration))

# Data visualisation ---------------------------------------

color_palette <- c('#d7191c','#fdae61','#ffffbf','#abd9e9','#2c7bb6')

plot_heatmap <- function(n.df){
	ggplot(n.df, aes(x = pop.size, y = mutate.prob)) +
		geom_tile(aes(fill = log10(iteration))) +
		scale_fill_gradientn(colours = color_palette) +
		labs(x = "Population size", y = "Mutation probability",
					 fill = "log10(iter)") +
		theme_bw()
}

plot_heatmap_alt <- function(n.df){
	ggplot(n.df, aes(x = mutate.prob, y = tourn.size)) +
		geom_tile(aes(fill = log10(iteration))) +
		scale_fill_gradientn(colours = color_palette) +
		labs(x = "Mutation probability", y = "Tournament size",
				 fill = "log10(iter)") +
		theme_bw()
}

# Plots for N = 8, 9, 10
plot_heatmap(eight.df) #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "params_8.pdf", width = 4.8, height = 3, dpi = 96, device = cairo_pdf)
plot_heatmap(nine.df) #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "params_9.pdf", width = 5.3, height = 3, dpi = 96, device = cairo_pdf)
plot_heatmap(ten.df) #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "params_10.pdf", width = 5.7, height = 3, dpi = 96, device = cairo_pdf)

# Plots for N = 8 only (more granular analysis)
plot_heatmap(eightb.df) #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "params_8b.pdf", width = 5.7, height = 3, dpi = 96, device = cairo_pdf)
plot_heatmap_alt(eightc.df) #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "params_8c.pdf", width = 6, height = 2, dpi = 96, device = cairo_pdf)
plot_heatmap_alt(eightd.df) #+ theme(text = element_text(family = "LM Roman 10")) + ggsave(filename = "params_8d.pdf", width = 6, height = 2, dpi = 96, device = cairo_pdf)

# Improvements? --------------------------------------------

min((eightb.df %>% filter(pop.size == 100))$iteration)
min((eightc.df)$iteration)

min((eightb.df %>% filter(pop.size == 350))$iteration)
min((eightd.df)$iteration)
