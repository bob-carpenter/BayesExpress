data {
  int<lower=0> T;
  int<lower=0> R;  
  int<lower=0> N;
  array[N] int<lower=1, upper=R> y;
  array[R] vector[T] log_phi;
}
parameters {
  simplex[T] psi;
}
model {
  vector[T] log_psi = log(psi);
  for (n in 1:N)
    target += log_sum_exp(log_psi + log_phi[y[n]]);
}
