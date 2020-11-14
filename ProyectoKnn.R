rm(list=ls())

require(class)
require(gmodels)
require(dplyr)
require(readr)

dir1 <- 'Documents/CursoDataScience/datascience/klustera/'
dfe <- read.csv(paste(dir1, "e.csv", sep="/"), stringsAsFactors = TRUE, encoding = "UTF-8")
dfv <- read.csv(paste(dir1, "v.csv", sep="/"), stringsAsFactors = TRUE, encoding = "UTF-8")

e <- dfe
v <- dfv

str(e)
e <- e[-1]
str(e)

table(e$visitor)

e$visitor <- factor(e$visitor, levels = c("true", "false"),
             labels = c("visitante", "No Visitante"))

round(prop.table(table(e$visitor)) * 100, digits = 1)

summary(e[c("tiempodeses", "day_tz", "hour_tz")])

normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
  }

e_n <- as.data.frame(lapply(e[c(4,6,8)], normalize)) #list apply

head(e_n)

nfilas <- floor(nrow(e_n) * .80)
set.seed(123)
index <- sample(1:nrow(e_n), nfilas) # 80%
e_train <- e_n[index, ] # Obtener solo las muestras
e_test <- e_n[-index, ] # Todo menos 

e_train_labels <- e[1:81000, 7]
e_test_labels <- e[81001:90000, 7]
str(e_train_labels)

e_test_pred <- knn(train = e_train, test = e_test, cl = e_train_labels, k = 200)

## ----------- Evaluamos los resultados del modelo 
# Creamos una tabla para compara predicciones vs real
CrossTable(x = e_test_labels, y = e_test_pred, prop.r=FALSE, prop.chisq = FALSE)





#agregando la columna de visitors en V

str(v)
v <- v[-1]
str(v)

sum(is.na(e))
vis_miss(e, warn_large_data = FALSE)



summary(v[c("tiempodeses", "day_tz", "hour_tz")])

normalize <- function(x) {
  return ((x - min(x)) / (max(x) - min(x)))
}

v_n <- as.data.frame(lapply(v[c(4,6,7)], normalize)) #list apply

head(v_n)

nfilas <- floor(nrow(v_n) * .80)
set.seed(123)
index <- sample(1:nrow(v_n), nfilas) # 80%
v_train <- v_n[1:81000, ] # Obtener solo las muestras
v_test <- v_n[81001:90000, ] # Todo menos 


v_test_pred <- knn(train = v_train, test = v_test, cl = e_train_labels, k = 200)

CrossTable(x = e_test_labels, y = v_test_pred, prop.r=FALSE, prop.chisq = FALSE)


v$visitor <- v_test_pred

write.csv(v,paste(dir1, "new_v.csv", sep = "/"), fileEncoding = "UFT-8")




