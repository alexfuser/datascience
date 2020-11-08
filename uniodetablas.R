library(nycflights13)
library(dplyr)

flights
airlines

flights2 <- flights %>% select(year:day, hour, origin, dest, tailnum, carrier)

flights2 %>%
  left_join(airlines)

weather
df = flights2 %>% left_join(weather)

planes
flights2 %>% left_join(planes, by = "tailnum")

df1 <- tibble(x = c(1,2), y = 2:1)
df2 <- tibble(x = c(3,1), a = 10, b = "a")

df1 %>% inner_join(df2)
df1 %>% right_join(df2)
df2 %>% left_join(df1)

df1 %>% full_join(df2)

df3 <- tibble(x = c(1, 1, 2), y = 1:3)

df4 <- tibble(x = c(1, 1, 2), z  = c("a", "b", "a"))


df3 %>% left_join(df4)

flights
flights %>%
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = TRUE)



(df1 <- tibble(x = c(1, 1, 3, 4), y = 1:4))
(df2 <- tibble(x = c(1, 1, 2), z = c("a", "b", "a")))

  
nrow(df1)

df1 %>% semi_join(df2, by = "x") %>% nrow()

(df1 <- tibble(x = 1:2, y = c(1L, 1L)))
(df2 <- tibble(x = 1:2, y = 1:2))

intersect(df1, df2)
union(df1, df2)
setdiff(df1, df2)
setdiff(df2, df1)
