library("cmdstanr")
library("ggplot2")
printf <- function(msg, ...) cat(sprintf(msg, ...), "\n")
ifel <- function(c, r1, r2) if (c) r1 else r2

set.seed(123467)

T <- 2
R <- 3
phi <- matrix(c(1/3, 1/2,
                1/3, 0,
                1/3, 1/2),
              nrow = R, ncol = T, byrow=TRUE)
log_phi <- log(phi)



mod <- cmdstan_model("cassette-ambig.stan")

psi <- c(0.8, 0.2)
N <- 1000
plot_df <- data.frame()
draws_df <- list()
Bs <- c()
for (trials in 1:3) {
  y <- c()
  M <- 0
  for (n in 1:N) {
    iso <- rbinom(1, 1, psi)       
    exons <- ifel(iso, 1:3, c(1, 3))
    M <- M + 1
    y[M] <- sample(exons, 1)
  }
  B <- sum(y == 2)
  Bs[trials] <- B
  data <- list(T = T, R = R, N = N, y = y, log_phi = log_phi)
  fit <- mod$sample(data = data, parallel_chains=4, refresh=0, iter_sampling=10000)
  draws_df[[trials]] <- fit$draws(format="df")
}
plot_df <- rbind(data.frame(psi1=draws_df[[2]]$"psi[1]",  B = rep(paste("B=", Bs[2], sep=""), dim(draws_df[[2]])[1])),
                 data.frame(psi1=draws_df[[3]]$"psi[1]",  B = rep(paste("B=", Bs[3], sep=""), dim(draws_df[[3]])[1])),
                 data.frame(psi1=draws_df[[1]]$"psi[1]",  B = rep(paste("B=", Bs[1], sep=""), dim(draws_df[[1]])[1])))



plot <-
    ggplot(plot_df, aes(x=psi1)) +
    geom_histogram(color="white", binwidth=0.01, size = 0.25) +
    scale_x_continuous(lim = c(0.6, 1.0)) +
    geom_vline(xintercept=0.8, color="red", size=0.5) +
    facet_grid(. ~ B) +
    xlab(expression(psi[1])) +
    ylab("") +
    theme(axis.ticks.y = element_blank(),
          axis.text.y = element_blank())

ggsave("../latex/bayes-express/img/cassette-ambig-posterior.pdf", width=7.5, height=2.5)
