install.packages("datos")
library(datos)
library(tidyverse)


#trasnformando datos en tablas
tabla4a
tabla4a %>%
  pivot_longer(cols = c(`1999`, `2000`), names_to = "anio", values_to = "casos")

tabla2
tabla2 %>%
  pivot_wider(names_from = tipo, values_from = cuenta)

set.seed(1234)
df <- data.frame(identifier=rep(1:5, each=3),
           location=rep(c("up", "down", "left", "up", "center"), each=3),
           period=rep(1:3, 5), counts=sample(35, 15, replace = TRUE),
           values=runif(15, 5, 10))[-c(4,8,11),]
df

df.wide <- reshape(df, idvar="identifier", timevar = "period",
                   v.names=c("values", "counts"), direction = "wide")
df.wide

reshape(df.wide, direction = "long")


tabla3

tabla3 %>%
  separate(tasa, into = c("casos", "poblacion"))

tabla3 %>%
  separate(tasa, into = c("casos", "poblacion"), sep = "/")

tabla3 %>%
  separate(tasa, into = c("casos", "poblacion"), convert = TRUE)

tabla3 %>%
  separate(anio, into = c("siglo", "anio"), sep = 2)

tabla5
tabla5 %>%
  unite(nueva, siglo, anio)


tabla5 %>%
  unite(nueva, siglo, anio, sep = "")



personas <- tribble(
  ~nombre, ~nombres, ~valores,
  #-----------------|--------|------
  "Phillip Woods", "edad", 45,
  "Phillip Woods", "estatura", 186,
  "Phillip Woods", "edad", 50,
  "Jessica Cordero", "edad", 37,
  "Jessica Cordero", "estatura", 156
)

personas.wide <- personas %>%
  group_by(nombre, nombres) %>%
  mutate(row = row_number()) %>%
  pivot_wider(names_from = nombres, values_from = valores)


embarazo <- tribble(
  ~embarazo, ~hombre, ~mujer,
  "sí", NA, 10,
  "no", 20, 12
)
tabla4a

tabla4a %>%
  pivot_longer(cols = c(`1999`, `2000`), names_to = "anio", values_to = "casos")
embarazo %>%
  pivot_longer(cols = c("hombre", "mujer"), names_to = "embarazo", values_to = "embarazo")








