data {
  int<lower=0> T;
  vector[T] L;
  int<lower=0> N;
  array[N] int<lower=1, upper=T> y;
}
transformed data {
  array[T] int<lower=0> u = rep_array(0, T);
  for (n in 1:N) u[y[n]] += 1;
}
parameters {
  simplex[T] psi;
}
transformed parameters {
  simplex[T] theta = psi .* L / sum(psi .* L);
}
model {
  u ~ multinomial(theta);
}
