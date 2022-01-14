functions {
  real length_adjust(real theta, array[] real L) {
    real p1 = theta * L[1];
    real p2 = (1 - theta) * L[2];
    return p1 / (p1 + p2);
  }
}
data {
  int<lower=0> N;
  int<lower=0> M;
  array[M] int<lower=0, upper=1> y;
  array[N] int<lower=1, upper=M> y_end;
  array[2] real<lower=0> L;
}
parameters {
  real<lower=0, upper=1> psi;
}
transformed parameters {
  real<lower=0, upper=1> theta = length_adjust(psi, L);
}
model {
  psi ~ beta(1, 1);

  int start = 0;
  for (n in 1:N) {
    int end = y_end[n];
    int K = end - start + 1;
    if (K == 1) {
      y[start] ~ bernoulli(theta);
      ++start;
    } else {
      target += log_mix(0.5, bernouli_lpmf(y[start] | theta),
			bernoulli_lpmf(y[start + 1] | theta));
      start += 2;
    }
  }
  y ~ binomial(N, theta);
}
