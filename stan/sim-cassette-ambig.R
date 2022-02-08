library("cmdstanr")
library("ggplot2")
printf <- function(msg, ...) cat(sprintf(msg, ...), "\n")
ifel <- function(c, r1, r2) if (c) r1 else r2

set.seed(12346)

T <- 2
R <- 3
phi <- matrix(c(1/3, 1/2,
                1/3, 0,
                1/3, 1/2),
              nrow = R, ncol = T, byrow=TRUE)
log_phi <- log(phi)

psi <- c(0.8, 0.2)
N <- 1000
y <- c()
y_start <- c()
M <- 0
for (n in 1:N) {
    iso <- rbinom(1, 1, psi)       
    exons <- ifel(iso, 1:3, c(1, 3))
    M <- M + 1
    y[M] <- sample(exons, 1)
}


mod <- cmdstan_model("cassette-ambig.stan")
data <- list(T = T, R = R, N = N, y = y, log_phi = log_phi)
fit <- mod$sample(data = data, parallel_chains=4)
