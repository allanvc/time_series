
# exercicios Series Temporais
# Aula3

# exercicio 5.2 -------------------------------------------
# carregamento
install.packages("tibbletime")
install.packages("tidyfinance")

library(tibbletime)
library(dplyr)
library(ggplot2)
library(readr)
library(reshape2)

# data(FB)
# str(FB)

# leitura
ph1.loc <- file.choose()
ph2.loc <- file.choose()
ph3.loc <- file.choose()

ph1 <- read_csv(ph1.loc)
ph2 <- read_csv(ph2.loc)
ph3 <- read_csv(ph3.loc)

head(list(ph1,ph2,ph3))

# i)

# juntando
ph <- bind_rows(ph1, ph2, ph3)

head(ph)

# convertendo para tibble time
library(lubridate)
ph <- ph %>%
  mutate(Date = mdy_hm(Date)) %>% # usando mdy_hm do lubridate
  as_tbl_time(index = Date)



# filtrando
# nao precisa - ele quer toda a serie
ph2 <- ph %>%
  filter_time('start' ~ 'end')

# visualizando os dados:
# minutos
# Yikes: *Hourly* is a bit too much data for the chart
# ggplot(ph, aes(x = Date, y = Point, colour=as.factor(as.character(Qual)))) +
ph2 %>%
ggplot(aes(x = Date, y = Point)) +
  geom_line(colour="navy") +
  theme_minimal()
# nao parece haver comportamento cíclico, mas utilizar um periodo de horas/minutos para a serie,
#... parece tornar o gráfico muito denso, dificultando a "leitura" do grafico. 
# Entao, vamos transformar para uma periodicidade diaria:

# Time floor: Shift timestamps to a time-based floor
# ph3 <- time_floor(ph2, "1 h") # nao existe mais essa funcao


# horario
ph2 %>%
  as_period("1 h") %>% # haverah uma linha para cada hora
  ggplot(aes(x = Date, y = Point)) +
  geom_line(colour="orange") + 
  theme_minimal()


# diario:
# Convert to daily makes the plot much more readable
help("as_period")

ph2 %>%
  as_period("1 day") %>%
  ggplot(aes(x = Date, y = Point)) +
  geom_line(colour="red") + 
  theme_minimal()

# 2 dias
# as_period("2 days") %>%

# 15 dias
# as_period("15 days") %>%

# semanal
ph2 %>%
  as_period("1 w") %>% # ou #("1 week")
  ggplot(aes(x = Date, y = Point)) +
  geom_line(colour="green") + 
  theme_minimal()

# realmente, em nenhum dos graficos parece haver uma componente ciclica

# ii)

# agrupando os dados mes - obtendo estatisticas mensais  - comparando o comportamento mensal

# Weather average by 1 month (monthly)
# sol em: https://stackoverflow.com/questions/47867310/r-decrease-frequency-of-time-series-data-by-aggregating-values-in-ohlc-series?noredirect=1&lq=1
ph2_m_summ <- ph2 %>%
  mutate(Date = collapse_index(Date, "1 month")) %>% # acrescentei ym() de lubridate para deixar o resto da data
  group_by(Date) %>%
  summarise(min = min(Point),
            avg = mean(Point),
            max = max(Point)
  )
  
# nao existe mais time_summarise()
ph2_m_summ


# ph2_m_summ <- ph2 %>%
#   mutate(Date = collapse_index(Date, "1 month")) %>% # acrescentei ym() de lubridate para deixar o resto da data
#   group_by(Date) %>%
#   summarise(min = min(Point),
#             avg = mean(Point),
#             max = max(Point)) %>%
#   mutate(Date = paste(year(Date), month(Date), sep="-")) %>% # usando mdy_hm do lubridate
#   as_tbl_time(index = Date) # nao funciona


# plot das series de min, avg e max
library(reshape2)
help(melt)

ph2_m_summ_long <- ph2_m_summ %>%
  melt(id.vars = c("Date")) # Date continua nas linhas idenificando cada obs

ph2_m_summ_long %>%
  ggplot() +
  geom_line(aes(x = Date, y = value, colour=variable)) + 
  theme_minimal()

# parece haver uma componente ciclica de queda dos valores nos meses de janeiro dos anos da serie
# -------------------------------------------


# exercicio 5.3 -------------------------------------------

