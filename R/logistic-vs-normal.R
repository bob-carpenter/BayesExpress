library("ggplot2")

logit <- function(p) log(p / (1 - p))

logistic_ilogit <- function(u) rep(1, length(u))

normal_ilogit <- function(u) dnorm(logit(u), 0, pi / sqrt(3)) * (1/u + 1 / (1 - u))

x <- seq(0.01, 0.99, 0.01)
N <- length(x)
p1 <- logistic_ilogit(x)
p2 <- normal_ilogit(x)

df <- data.frame(x = c(x, x), y = c(p1, p2),
                 model = c(rep("a ~ logistic(0, 1)", N),
                           rep("a ~ normal(0, pi / sqrt(3))", N)))


plot <-
    ggplot(df, aes(x = x, y = y)) +
    geom_line() +
    facet_grid(. ~ model, labeller = label_bquote(cols = .(model))) +
    scale_y_continuous(lim = c(0, 1.3), breaks = c(0, 0.5, 1), labels = c("0", "1/2", "1")) +
    scale_x_continuous(lim = c(0, 1), breaks = c(0, 0.25, 0.5, 0.75, 1), labels = c("0", "1/4", "1/2", "3/4", "1")) +
    xlab(expression({logit^-1}(a))) +
    ylab(expression(p({logit^-1}(a))))


ggsave("../img/ilogit-logistic-vs-normal.pdf", width=8, height=2.5)
