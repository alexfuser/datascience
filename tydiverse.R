
library(tidyverse)
library(nycflights13)

str(iris)

tiris <- as_tibble(iris)

dates <- select(flights, year, month, day)
names(flights)

select(flights, year:dep_delay)

select(flights, -(year: day))


# Convertirmos a iris en tibble
iris <- as_tibble(iris)
iris

# Selecciona todas las columna que empiezan con "Petal"
select(iris, starts_with("Petal"))

# Selecciona todas las columnas que terminan con "Width"
select(iris, ends_with("Width"))

# Selecciona todas las columnas que contengan la cadena "etal"
select(iris, contains("etal"))

select(iris, Species, everything())

### FILTER

str(mtcars)

filter(mtcars, cyl == 8)

filter(mtcars, cyl < 6 & vs == 1)  #  es igual filter(mtcars, cyl < 6, vs == 1) 

filter(mtcars, cyl < 6 |  vs == 1) 

flights_nov_dec <- filter(flights, month %in% c(11, 12))
summary(flights_nov_dec$month)

## ARRANGE
mtcars
arrange(mtcars, cyl , desc(disp))

##ordenamiento alfabetico usando pipepline
select(flights, dest, air_time) %>%
  arrange(dest, desc(air_time))

## MUTATE

flights
flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, air_time) %>%
               mutate(gain = arr_delay - dep_delay, 
                      speed = distance / air_time * 60)

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, air_time) %>%
               transmute(gain = arr_delay - dep_delay,   ## solo esas columnas
                      speed = distance / air_time * 60)



## lo mismo de transmute pero con select

flights_sml <- select(flights, 
                      year:day, 
                      ends_with("delay"), 
                      distance, air_time) %>%
  mutate(gain = arr_delay - dep_delay, 
         speed = distance / air_time * 60) %>%
  select(-(year:air_time))



library(plyr)

??baseball


baseball <- as_tibble(baseball)

detach(package:plyr)
str(baseball)

summary(baseball$year)

summarise(baseball, duration = max(year) - min(year), nteams = length(unique(team)))

# Total de hits por jugador
by_player <- group_by(baseball, id)
summarise(by_player, mean_hits = mean(h, na.rm = TRUE))

# Total de hits por jugador por año
by_player_year <- group_by(baseball, id, year)
summarise(by_player_year, mean_hits = mean(h, na.rm = TRUE))

# Total de hits por jugador por año y por equipo
by_player_year_team <- group_by(baseball, id, year, team)
summarise(by_player_year_team, mean_hits = mean(h, na.rm = TRUE))



################ practica ###################
dataset2 <- read.csv("~/Documents/CursoDataScience/datascience/adult.data")


colnames(dataset2) <- c('age',
                             'workclass',
                             'fnlwgt',
                             'education',
                             'education-num',
                             'marital-status',
                             'occupation',
                             'relationship',
                             'race',
                             'sex',
                             'capital-gain',
                             'capital-loss',
                             'hours-per-week',
                             'native-country', '50K')

dataset2 <- as_tibble(dataset2)
hombres <- filter(dataset2, sex == " Male")
hombres
select(dataset2, age, education, 'native-country')
arrange(dataset2, "native-country")
arrange(dataset2, desc(age))
dataset_sexo_pais <- summarise(group_by(dataset2, sex, 'native-country'), count = n())
dataset_sexo_pais








