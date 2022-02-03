library("cmdstanr")
library("ggplot2")
printf <- function(msg, ...) cat(sprintf(msg, ...), "\n")

set.seed(1234)

T <- 2
psi <- c(0.8, 0.2)
L <- c(249, 49)
theta <- psi * L / sum(psi * L)
N <- 357

model <- cmdstan_model("cassette-single-sample.stan")
plot_df <- data.frame()
for (u1 in c(335, 340, 344)) {
    y <- c(rep(1, u1), rep(2, 357-u1)) # sample(1:T, size=N, replace=TRUE, prob=theta)
    data <- list(T = 2, L = L, N = N, y = y)
    fit <- model$sample(data, parallel_chains=4, refresh=0, iter_sampling=10000)
    draws_df <- fit$draws(format="df")
    plot_df <- rbind(plot_df,
                     data.frame(psi1 = draws_df$"psi[1]", u1=rep(paste("u1=", u1, sep=""), dim(draws_df)[1])))
}



plot <-
    ggplot(plot_df, aes(x=psi1)) +
    geom_histogram(color="white", binwidth=0.01, size = 0.25) +
    scale_x_continuous(lim = c(0.6, 0.98)) +
    geom_vline(xintercept=0.8, color="red", size=0.5) +
    facet_grid(. ~ u1) +
    xlab(expression(psi[1])) +
    ylab("") +
    theme(axis.ticks.y = element_blank(),
          axis.text.y = element_blank())
plot
ggsave("../latex/bayes-express/img/cassette-posterior.pdf", width=7.5, height=2.5)
