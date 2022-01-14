library("cmdstanr")

T <- 2
psi <- c(0.8, 0.2)
L <- c(250, 50)
theta <- psi * L / sum(psi * L)
N <- 400
y <- sample(1:T, size=N, replace=TRUE, prob=theta)

model <- cmdstan_model("cassette-single-sample.stan")
data <- list(T = 2, L = L, N = N, y = y)
fit <- model$sample(data)
print(fit, "psi")
