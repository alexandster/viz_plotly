

library(plotly)
library(gapminder)


p <- ggplot(gapminder, aes(gdpPercap, lifeExp, color = continent)) +
  geom_point(aes(size = pop, frame = year, ids = country)) +
  scale_x_log10()

p <- ggplotly(p)


Sys.setenv("plotly_username"="ahohl")
Sys.setenv("plotly_api_key"="IQUODNX1cMb3Af9rPHmV")


chart_link = api_create(p, filename="mulitple-trace")
chart_link