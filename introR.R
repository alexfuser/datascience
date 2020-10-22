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


var1 <- 3
var2 <- 6

if(var1==var2){
  print('son iguales')
}else if(var1<var2){
  print('var1 es menor que var 2')
}else {
  print('ninguna de las anteriores')
}

caso <- 'T4'

switch(caso, 
       T1={X <- 'Entro en el caso T1'},
       T2={X <- 'Entro en el caso T2'},
       T3={X <- 'Entro en el caso T3'},
       stop('No paso nada')
       )

v <- LETTERS[1:4]

for (i in v) {
  print(i)
  
}


mensaje <- "dentro del while loop"
contador <- 1

while (contador < 10) {
  print(mensaje)
  contador = contador + 1
}


mensaje <- "dentro del repeat"
contador <- 1

repeat {
  print(mensaje)
  contador <- contador+1
  
  if(contador > 5) {
    break
  }
}










