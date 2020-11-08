# PREGUNTA 2: Entre hombres y mujeres, ¿cuál fue el grupo más vulnerable en el 2011?
## Preparación:
# 1) Filtrar a únicamente los registros del año 2011
# 2) Agrupar por la columna sexo
# 3) Agrega una nueva columna calculando el promedio ponderado de las tasas por cada grupo.
# Pro Tip: weighted.mean() calcula el promedio ponderado con las tasas y ponderando la población

tempo <- data %>%
  filter(____) %>%
  group_by(____) %>%
  summarise(____ = weighted.mean(____, pob))

## Gráfica: completa el código faltante
# Genera una barra para cada sexo, graficando su tasa.
# Agrega el título: Tasa de desaparecidos 2011
# El subtítulo: por sexo
# Añade las tasas en la cima de cada barra redondeando a 2 decimales y ajusta el texto verticalmente
# Agrega un texto descriptivo para el eje X y para el eje Y.
gr <- ggplot(tempo, aes(x=____, y=____)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label=round(____, _), _____=_)) +
  ____(title="_______________", ____="______", x="____", y="___________")

ggsave(paste(dir2, "2.png", sep="/"), plot=gr, width=12, height=12)

# PREGUNTA 3: Imaginen que queremos ver el porcentaje de desaparecidos que hay por sexo y edad.
# Por ejemplo: ¿Qué porcentaje de mujeres desaparecidas tienen entre 0 y 11 años?
## Preparación:
# 1) Agrupar por la columna sexo y rango de edad. Recuerda que el orden en el que pongas las columnas dentro
# de group_by importa.
# 2) Colapsa los datos para obtener el total de cada grupo y reemplaza los valores de la columa total
# 3) Agrega una nueva columna "totales" que sea igual a la sumatoria de los valores de la columna total
# por cada grupo.
# 4) Ayudándote de las columnas total y totales, calcula el porcentaje que representa cada rango de edad
# del total de personas desaparecidas por cada grupo.
tempo <- data %>%
  group_by(____, ____) %>%
  summarise(total = ____) %>%
  mutate(totales = ____,
         porcentaje = round((____/____)*100, 2))

## Gráfica
# 1) Grafica los valores de la columna sexo en el eje X y los de porcentaje en eje Y
# 2) Utiliza los valores de la columa "rango_edad" para colorear cada porcentaje
# 3) Establece un valor para el ángulo
gr <- ggplot(tempo, aes(x=____, y=____, fill=rango_edad)) +
  geom_bar(stat="identity") + # Especificando y explícitamente
  geom_text(aes(label=paste0(porcentaje,"%")), position=position_stack(vjust=0.5), angle=____) +
  scale_fill_manual(values=c("#ffffcc","#c7e9b4","#7fcdbb","#41b6c4","#2c7fb8","#253494")) +
  labs(title="Porcentaje de desaparecidos entre 2010 y 2015 \npor sexo y edad", 
       x="____", y="____", fill="____") +
  coord_flip() +
  theme_bw()
ggsave(paste(dir2, "3.png", sep="/"), plot=gr, width=12, height=12)

# PREGUNTA 4.1: Para la pregunta 4, existe otra alternativa
## Recordemos que nuestros datos son los siguientes:
tempo <- data %>%
  group_by(sexo, ent, nom_ent) %>%
  summarise(tdes = weighted.mean(tdes, pob)) %>%
  mutate(tdes = round(tdes, 2))
# Encontrar la función faltante que permita visualizar las tasas para cada sexo por separado, pero sin perder
# la división existente entre estados.
# Pro Tip: Consulta la sección "faceting" del cheat sheet.
gr <- ggplot(tempo, aes(x=sexo, y=tdes)) +
  geom_bar(stat="identity", fill="#41b6c4") +
  geom_text(aes(label=tdes), vjust=-0.3, size=3) +
  ____(____) +
  labs(title="Tasa de desaparecidos por sexo y estado \n2010 - 2015", 
       x="Sexo", y="Tasa de desaparecidos") +
  theme_bw() +
  theme(axis.text.x = element_text(angle=__)) # Elige un ángulo que permita visualizar correctamente el texto

ggsave(paste(dir2, "6.png", sep="/"), plot=gr, width=20, height=12)

# Ejercicios Klustera:

# ¿Que día de la semana contamos con mayor número de visitantes?
# Filtrar la variable visitor
# Agrupar por día de semana
# Colapsar contando número de registros por día de semana

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
