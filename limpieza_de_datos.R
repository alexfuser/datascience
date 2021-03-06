# Cargamos los paquetes con los que vamos a trabajar
library(stringr) # Tratamiento de strings https://stringr.tidyverse.org/index.html
library(tibble) # Tidyverse https://tibble.tidyverse.org/
library(dplyr) # Tidyverse https://dplyr.tidyverse.org/
library(ggplot2) # Graphs https://ggplot2.tidyverse.org/
library(lubridate) # Tratamiento de fechas https://lubridate.tidyverse.org/
library(assertive) # Validaciones https://rdrr.io/cran/assertive/
library(visdat) # Visualizar missing data 

num <- c(1,2,3,4,5,6,7,8,9,10)
char <- c('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j')
log <- c(TRUE, FALSE, FALSE, TRUE, T, F, T, T, T, F)
to.factor <- c(10, 20, 30, 20, 30, 20, 10, 10, 10, 20)
factor <- factor(to.factor, levels = c(10,20,30))

(df <- data.frame(num, char, log, factor, stringsAsFactors = FALSE))

sumatoria <- function(valores) {
  result <- sum(valores)
  return(result)
}

# ¿Qué pasa si hago lo siguiente?
sumatoria(df$factor)   

#no se puede por el tipo de valor, hay que poner condiciones como abajo


sumatoria <- function(valores) {
  result = NULL
  if(is.factor(valores) | is.character(valores)) {
    print('No es posible')
  } else {
    result <- sum(valores)
  }
  return(result)
}
# Note que utilizamos el operador lógico OR ( | ), esto porque no podemos
# tener un conjunto de datos con dos tipos a la vez.


sumatoria(df$factor)   


is.character(df$num)

assert_is_character(df$char)

as.numeric(as.character(df$factor))


# Hacemos una copia para proteger nuestro dataset original de alteraciones
columna.factor <- df$factor
# Si de verdad quieres sobrescribir la columna factor:
# df$factor <- as.numeric(as.character(df$factor))
columna.numeric <- as.numeric(as.character(columna.factor))
sumatoria(columna.numeric)


# Directorio de las bases de datos
dir <- 'Documents/CursoDataScience/datascience/databases/'

# Utilizaremos la base de datos de fifa.csv
fifa <- read.csv(paste(dir, 'fifa.csv', sep='/'), stringsAsFactors = FALSE)

# La columna "Wage" contiene datos sobre el salario por jugador.
# Tiene la cantidad pero también la divisa y una K que sustituye los "000" que debería
# tener la cantidad para estar completa
fifa$Wage

## FORMA 1: Utilizando str_remove para quitar definitivamente esos caracteres.
tempo <- fifa %>%
  # Remove '€' from Wage: wage_trimmed
  mutate(wage_trimmed = str_remove_all(Wage, "[€K]"),
         # Convert wage_trimmed to numeric
         wage_numeric = as.numeric(wage_trimmed) * 1000)

head(select(tempo, Wage, wage_trimmed, wage_numeric))

# FORMA 2: Vamos a probar que pasaría si tuviéramos miles y millones en la misma columna
# Utilizaremos la base de datos de fifaM.csv
fifaM <- read.csv(paste(dir, 'fifaM.csv', sep='/'), stringsAsFactors = FALSE)

tempo <- fifaM %>%
  # Remove '€' from Wage: wage_trimmed
  mutate(wage_trimmed = str_remove(Wage, "€"),
         # Convert wage_trimmed to numeric: duration_mins
         wage_chr = str_replace_all(wage_trimmed, c("K"="000", "M"="000000")),
         wage_numeric = as.numeric(wage_chr))

head(select(tempo, Wage, wage_trimmed, wage_chr, wage_numeric))
tail(select(tempo, Wage, wage_trimmed, wage_chr, wage_numeric))

# Que no los engañen sus ojos
class(tempo$wage_chr)
class(tempo$wage_numeric)

load(paste(dir, 'movies.Rdata', sep='/'))

# Definimos los cortes para nuestro histograma
breaks <- c(min(movies$imdb_rating), 0, 7, max(movies$imdb_rating))

# Histograma
ggplot(movies, aes(imdb_rating)) +
  geom_histogram(breaks = breaks)

assert_all_are_in_closed_range(movies$imdb_rating, lower = 0, upper = 7)


# Removiendo las filas con dato fuera de rango
movies %>%
  filter(imdb_rating >= 0, imdb_rating <= 7) %>%
  ggplot(aes(imdb_rating)) +
  geom_histogram(breaks = c(min(movies$imdb_rating), 0, 7, max(movies$imdb_rating)))

# Tratarlas como datos perdidos
# replace(col, condition, replacement)
tempo = movies %>%
  mutate(rating_miss =
           replace(imdb_rating, imdb_rating > 7, NA))
table(tempo$rating_miss)
# Reemplazando los valores fuera de rango con el valor límite
tempo <- movies %>%
  mutate(rating_const =
           replace(imdb_rating, imdb_rating > 7, 7))

table(tempo$rating_const)



bike_share_rides <- readRDS(paste(dir, 'bike_share_rides_ch1_1.rds', sep='/'), refhook = NULL)


bike_share_rides_future <- bike_share_rides
bike_share_rides_future$date <- as.Date(bike_share_rides_future$date)
# Simulamos la inserción de fechas en el futuro
bike_share_rides_future <- add_row(bike_share_rides_future, date = as.Date("2043-04-15"))
bike_share_rides_future <- add_row(bike_share_rides_future, date = as.Date("3045-05-14"))

# Make sure all dates are in the past
assert_all_are_in_past(bike_share_rides_future$date)

# Filter for rides that occurred before or on today's date
bike_share_rides_past <- bike_share_rides_future %>%
  filter(bike_share_rides_future$date <= today())

# Make sure all dates from bike_share_rides_past are in the past
assert_all_are_in_past(bike_share_rides_past$date)


letters <- read.csv(paste(dir, 'letters.csv', sep='/'), stringsAsFactors = FALSE)
names(letters) <- c('alumno','curso','pago')

### DUPLICADOS TOTALES
# Vamos a contar el número de duplicados totales
sum(duplicated(letters))

# Removemos duplicados totales
letters_unique <- distinct(letters)

# Volvemos a contar duplicados totales y...
sum(duplicated(letters_unique))

## DUPLICADOS PARCIALES
# Buscamos duplicados solo para las columnas en count
letters %>%
  # Cuenta el total de ocurrencias para cada columna en count
  count(alumno) %>% 
  # Filtra solo las que hayan obtenido más de una coincidencia
  filter(n > 1)

# Podemos remover las filas duplicadas tomando en cuenta ciertas columnas
letters_unique <- letters %>%
  # Remueve las filas solo tomando en cuenta valore duplicados para alumno
  distinct(alumno, .keep_all = TRUE)

# Corroboramos ausencia de duplicados
letters_unique %>%
  count(alumno) %>%
  filter(n>1)

## En lugar de solo remover, reducimos las filas sumando los pagos.
# Así no perdemos datos.
letters %>%
  # Agrupamos por alumno y curso
  group_by(alumno, curso) %>%
  # Sumamos los pagos realizados por cada alumno por cada curso que tomó
  mutate(pago_sum = sum(pago)) %>%
  # Ahora podemos remover duplicados tranquilamente
  distinct(alumno, curso, .keep_all=TRUE) %>%
  # Quitamos la columna que ahora solo contiene datos parciales
  select(-pago)




## Fechas en múltiples formatos
# Cargamos nuestra base de datos de cuentas bancarias
accounts <- readRDS(paste(dir, 'ch3_1_accounts.rds', sep='/'), refhook = NULL)
# Por defecto, as.Date() no puede convertir formatos de fecha del tipo "Month DD, YYYY".
# Veamos lo que tenemos en nuestro data frame
head(accounts)

# Vamos a definir una lista con todos los posibles formatos de fecha a cambiar
formats <- c("%Y-%m-%d", "%B %d, %Y", "%m/%d/%y")

# Con lubridate, hacemos una conversión de los formatos de fecha.
# Solo las fechas que hagan match con los formatos en la lista "formats", serán cambiados
accounts <- accounts %>%
  mutate(date_opened_clean = parse_date_time(date_opened, formats)) # lubridate

# Diferentes divisas en una columna monetaria
## Utilizaremos una nueva base de datos para determinar la procedencia de los valores de moneda
account_offices <- read.csv(paste(dir, 'account_offices.csv', sep='/'), stringsAsFactors = FALSE)
# Utilizaremos la fórmula conversión: USD = JPY / 104.
# Con una gráfica de dispersión, podemos notar la gran diferencia entre los montos
# lo que nos da una señal de que tenemos distintas divisas en el mismo conjunto de datos
accounts %>%
  ggplot(aes(x = id, y = total)) +
  geom_point()

# Hagamos un left join de la tabla "accounts" con la tabla "account_offices" por "id"
accounts %>%
  left_join(account_offices, by = "id") %>%
  # Ahora sabemos a qué países corresponden las cuentas, estandaricemos todo a USD
  mutate(total_usd = ifelse(office == "Tokyo", total / 104, total)) %>%
  # Veamos qué tan dispersos están nuestros montos ahora
  ggplot(aes(x = date_opened, y = total_usd)) +
  geom_point()




# PROBLEMA 8: DATOS PERDIDOS (missing data)
# Exploraremos nuestra base de datos
head(airquality)

# Encontrar los valores NA (missing data)
is.na(airquality)

# Contabilizar los datos perdidos
sum(is.na(airquality))

# Visualizar los datos perdidos por columna (visdat)
vis_miss(airquality)

# Visualizar estadísticas sobre las filas con datos perdidos para inferir causa
airquality %>%
  mutate(miss_ozone = is.na(Ozone)) %>%
  group_by(miss_ozone) %>%
  summarize_all(mean, na.rm = TRUE)

# Ordenar para corroborar hipótesis
airquality %>%
  arrange(Solar.R) %>%
  vis_miss()

# Desechar observaciones con datos perdidos
airquality %>%
  filter(!is.na(Ozone), !is.na(Solar.R))

# Replacing missing values
airquality_filled <- airquality %>%
  mutate(ozone_filled = ifelse(is.na(Ozone), mean(Ozone, na.rm = TRUE), Ozone))

# Ordenar para corroborar hipótesis
airquality_filled %>%
  arrange(Temp) %>%
  vis_miss()
