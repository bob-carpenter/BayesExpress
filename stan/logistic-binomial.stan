functions {
  real length_adjust(real psi, array[] real L) {
    real p1 = psi * L[1];
    real p2 = (1 - psi) * L[2];
    return p1 / (p1 + p2);
  }
}
data {
  int<lower=0> N;
  int<lower=0, upper=N> y;
  array[2] real<lower=0> L;
}
parameters {
  real alpha;
}
transformed parameters {
  real<lower=0, upper=1> psi = inv_logit(alpha);
  real<lower=0, upper=1> theta = length_adjust(psi, L);
}
model {
  alpha ~ logistic(0, 1);
  y ~ binomial(N, theta);
}
