library(ggplot2)
library(readr)
library(tidyverse)
library(treemap)


p <- ggplot(iris)

p <- p + aes(x = Petal.Length, y = Petal.Width, colour = Species)

p <- ggplot(iris, aes(x = Petal.Length, y = Petal.Width, colour = Species)) + 
  geom_point() + 
  geom_smooth() + 
  facet_grid(~ Species)


summary(p)

#p <- p 

# PREGUNTA 1: ¿cuántos desaparecidos hubo por municipio en...2011 (año más violento)?
# Esta primera  gráfica será un scatter, pero que va a cumplir la función de las barras dado que vamos 
# a graficar 2,456 municipios
# a) Preparar los datos:
data <- read_csv("Documents/CursoDataScience/datascience/rnped_limpia.csv")

str(data)
#preparar los datos  // no todas las graficas admiten datos agrupados
tempo <- data %>%
  filter(year==2011) %>%
  group_by(inegi, nom_ent, nom_mun) %>%
  summarise(total = sum(total)) %>%
  arrange(inegi) %>%
  ungroup()

#generar grafica de los datos
gr <- ggplot(tempo, aes(x=inegi, y=total)) +
  geom_point()

gr <- ggplot(tempo, aes(x=inegi, y=total)) +
  geom_point(color="#08bf02") +
  geom_text(aes(x=inegi, y=total, label=paste(nom_mun, nom_ent, total, sep=", ")), data=tempo[tempo$total>100,], hjust=0, vjust=-1) +
  labs(title="Total de desaparecidos por municipio", subtitle="2011", x="", y="Total de desaparecidos") +
  theme(axis.text.x = element_blank())

#guardar las graficas
ggsave(paste('Documents/CursoDataScience/datascience/graficas/', "1.png", sep="/"), plot = gr, width = 12, height = 12)



# PREGUNTA 4: ¿Cuál es la tasa de desaparecidos por cada uno de los sexos pero distinguiendo
# la información de cada estado?
tempo <- data %>%
  group_by(sexo, ent, nom_ent) %>%
  summarise(tdes = weighted.mean(tdes, pob)) %>%
  mutate(tdes = round(tdes, 2))
gr <- ggplot(tempo, aes(x=sexo, y=tdes)) +
  geom_bar(stat="identity", fill="#41b6c4") +
  geom_text(aes(label=tdes), vjust=-0.3, size=3) +
  facet_wrap(~nom_ent) +
  labs(title="Tasa de desaparecidos por sexo y estado \n2010 - 2015", 
       x="Sexo", y="Tasa de desaparecidos") +
  theme_bw()


ggsave(paste('Documents/CursoDataScience/datascience/graficas/', "5.png", sep="/"), plot = gr, width = 12, height = 12)


# PREGUNTA 5: queremos ver % de hombres/mujeres que desaparecieron entre los 12 a 17 años vs 26-40 años
# Vamos a utilizar barras 2D .Nos sirven cuando queremos ver dos dimensiones de una variable con varias 
# categorias.
tempo <- data %>%
  group_by(sexo, rango_edad) %>%
  summarise(total = sum(total)) %>%
  ungroup() %>%
  group_by(sexo) %>%
  mutate(totales = sum(total),
         porcentaje = round((total/totales)*100, 2))
# Quedémonos con lo que nos importa
tempo <- tempo %>%
  select(sexo, rango_edad, porcentaje) %>%
  filter(rango_edad=="12 a 17 a\u00f1os" | rango_edad=="26 a 40 a\u00f1os") %>%
  spread(rango_edad, porcentaje)
names(tempo) <- c("sexo", "des12a17", "des26a40")
gr <- ggplot(tempo, aes(x=des12a17, y=des26a40, color=sexo)) +
  geom_segment(aes(xend=des12a17), yend=0, size=2) +
  geom_segment(aes(yend=des26a40), xend=0, size=2) +
  scale_y_continuous(limits=c(0, 42)) +
  scale_x_continuous(limits=c(0, 42)) +
  labs(title="Porcentaje de desaparecidos por sexo \n 12 a 17 años vs 26 a 40 años",
       x="% de desaparecidos 12 a 17 años", y="% de desaparecidos 26 a 40 años", color="Sexo") +
  theme_bw()





