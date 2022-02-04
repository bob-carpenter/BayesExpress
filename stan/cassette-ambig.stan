data {
  int<lower=0> T;
  vector[T] L;
  int<lower=0> N;
  int<lower=0> M;
  int<lower=1, upper=M> y_start[N + 1];
  array[M] int<lower=1, upper=T> y;
}
parameters {
  simplex[T] psi;
}
transformed parameters {
  simplex[T] theta = psi .* L / sum(psi .* L);
}
model {
  for (n in 1:N) {
    int start = y_start[n];
    int end = y_start[n + 1];
    int K = end - start + 1;
    vector[K] lp;
    for (k in 1:K) {
      lp[k] = categorical_lpmf(y[start + k - 1] | theta);
    }
    target += log_sum_exp(lp);
  }
}
