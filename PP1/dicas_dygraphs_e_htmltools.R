# como plotar dygrphs lado a lado usando htmltools:
# sol: https://stackoverflow.com/questions/35950710/htmlwidgets-side-by-side-in-html

# como plotar dygrphs um abaixo do outro usando htmltools:
# sol: https://stackoverflow.com/questions/32502506/dygraph-in-r-multiple-plots-at-once


# Load energy projection data
# Load energy projection data
library(networkD3)
URL <- paste0(
  "https://cdn.rawgit.com/christophergandrud/networkD3/",
  "master/JSONdata/energy.json")
Energy <- jsonlite::fromJSON(URL)
# Plot
sn <- sankeyNetwork(Links = Energy$links, Nodes = Energy$nodes, Source = "source",
                    Target = "target", Value = "value", NodeID = "name",
                    units = "TWh", fontSize = 12, nodeWidth = 30,
                    width = "100%")
library(leaflet)
data(quakes)

# Show first 20 rows from the `quakes` dataset
leaf <- leaflet(data = quakes[1:20,]) %>% addTiles() %>%
  addMarkers(~long, ~lat, popup = ~as.character(mag))


library(htmltools)
browsable(
  tagList(list(
    tags$div(
      style = 'width:50%;display:block;float:left;',
      sn
    ),
    tags$div(
      style = 'width:50%;display:block;float:left;',
      leaf
    )
  ))
)




# create a list of dygraphs objects
# library(dygraphs)
library(htmltools)
dy_graph <- list(
  dygraphs::dygraph(open_ts, group="DJI", main="Abertura") %>% dySeries("open", strokeWidth = 0.5, color="orange"),
  dygraphs::dygraph(max_ts, group="DJI", main="Máxima") %>% dySeries("max", strokeWidth = 0.5, color="red") ,
  dygraphs::dygraph(min_ts, group="DJI", main="Mínima"),
  dygraphs::dygraph(close_ts, group="DJI", main="Fechamento"),
  dygraphs::dygraph(vol_ts, group="DJI", main="Volume")
)  # end list


htmltools::browsable(htmltools::tagList(dy_graph))


# render the dygraphs objects using htmltools
# par(mfrow=c(2,1))
p1 <- dygraphs::dygraph(open_ts, group="DJI", main="Abertura") %>% dySeries("open", strokeWidth = 0.5, color="orange")
p2 <- dygraphs::dygraph(max_ts, group="DJI", main="Máxima") %>% dySeries("max", strokeWidth = 0.5, color="red")

library(htmltools)
browsable(
  tagList(list(
    tags$div(
      style = 'width:100px;height:80%;float:left;',
      p1
    ),
    tags$div(
      style = 'width:50px;height:80%;float:right;',
      p2
    )
  ))
)