

dir <- 'Documents/CursoDataScience/datascience/klustera/'

dt <- read.csv(paste(dir, 'e.csv', sep='/'))


# Ejercicios Klustera:

# ¿Que día de la semana contamos con mayor número de visitantes?
# Filtrar la variable visitor
# Agrupar por día de semana
# Colapsar contando número de registros por día de semana

tempo <- dt %>%
  filter(visitor == 'true' ) %>%
  group_by(day_of_week_tz) %>%
  summarise(dat_tz_total = sum(day_tz)) 

max_visitor_day <-  max(tempo$dat_tz_total) %>%
  max(tempo$day_of_week_tz)
  


# ¿Meses con mayor número de visitantes?
# Filtrar: Registros de forma mensual
# Agrupar: visitantes y no visitantes
# Colapsar: Contar número de registros por grupo







# ¿Cuál oficina recibe más visitantes?
# Filtrar: obtener los registros solo de visitantes (visitor).
# Agrupar: por día de la semana.
# Colapsar: contar los registros por oficina.

# ¿Cuál oficina recibe más visitantes?
# Filtrar: obtener los registros solo de visitantes (visitor).
# Agrupar: por día de la semana.
# Colapsar: contar los registros por oficina.
