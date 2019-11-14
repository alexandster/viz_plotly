library(stpp)
library(maptools)
library(plotly)
library(scatterplot3d)
library(rgl)

#----------------------------------------------------------------------------------------------------------------------
#simulate a clustered dataset
#----------------------------------------------------------------------------------------------------------------------

#define coordinate system
crs1=CRS("+proj=utm +zone=18 +ellps=intl +towgs84=307,304,-318,0,0,0,0 +units=m +no_defs " )

#read city boundary
cali=readShapePoly("cali_boundary.shp", proj4string=crs1)
cali_vec <- cali@polygons[[1]]@Polygons[[1]]@coords
cali_matrix <- as.matrix(cali_vec)
cali_matrix_simple <- cali_matrix[seq(1,nrow(cali_matrix),500),]

#create points
sim <- sim.stpp(class="cluster", s.region=cali_matrix_simple, t.region=c(3,729),nparents=5, mc=250,dispersion = 1000)

plot(sim$xyt)

#plot(cali)
#points(sim$xyt[,1:2])

#plot3d(sim$xyt[,1:3])

#----------------------------------------------------------------------------------------------------------------------
#run the space-time Ripley's k
#----------------------------------------------------------------------------------------------------------------------

#spatial and temporal bins
hs <- c(1000, 2000, 3000, 4000, 5000, 6000)
ht <- c(1,3,5,7,9)

#stikhat function
k <- STIKhat(sim$xyt,s.region=cali_matrix_simple, t.region=c(3,729), dist=hs, times=ht)

# difference between observed and theoretical k function
diff <- k$Khat-k$Ktheo


# plotly
#----------------------------------------------------------------------------------------------------------------------
#----------------------------------------------------------------------------------------------------------------------

#set environment
Sys.setenv("plotly_username"="")
Sys.setenv("plotly_api_key"="")

#axes object
a <- list(
  autotick = TRUE,
  showline = TRUE,
  ticks = "outside",
  tick0 = 0,
  dtick = 0.25,
  ticklen = 5,
  tickwidth = 2,
  tickcolor = toRGB("black")
)

#plot object
p <- plot_ly(
  x = hs,
  y = ht,
  z = diff,
  type = "contour") %>%
  layout(xaxis = a, yaxis = a)

#open in browser
chart_link = api_create(p, filename="mulitple-trace")
chart_link
