cinco <- 5
seis <- 6
doce = 6 + 6
doce

.var_name2 <- 7

my.summary <- function(x) {
  suma <- sum(x)
  total <- length(x)
  promedio <- suma/total
  return(promedio)
}

s <- 1:10
my.summary(s)

v <- my.summary(s)
