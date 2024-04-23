library(plotly)
library(processx)
library(reticulate)


install.packages('reticulate')
reticulate::install_miniconda()
reticulate::conda_install('r-reticulate', 'python-kaleido')
reticulate::conda_install('r-reticulate', 'plotly', channel = 'plotly')
reticulate::use_miniconda('r-reticulate')

df24 = read.csv("https://raw.githubusercontent.com/waitasecant/Air-Pollution-Dashboard/main/myApp/data/realTimeDelhi.csv")
df24$Date =as.POSIXct(df24$Date, format = "%Y-%m-%d %H:%M:%S")

col = list("darkredp"=rgb(0.78, 0.063, 0.063), "redp"=rgb(1, 0.165, 0), "orangep"=rgb(1, 0.702, 0),
      "yellowp"=rgb(1, 0.918, 0.118), "greenp"=rgb(0.349,0.8,0.133), "darkgreenp"=rgb(0.204, 0.639, 0))

st_list = c("Alipur",
"Anand Vihar",
"Ashok Vihar",
"Bawana",
"Dr. Karni Singh Shooting Range",
"Dwarka Sector-8",
"Jahangirpuri",
# "Jawaharlal Nehru Stadium",
"Major Dhyan Chand National Stadium",
"Mandir Marg",
"Mundka",
"Najafgarh",
"Narela",
"Nehru Nagar",
"Okhla Phase-2",
"Patparganj",
"Punjabi Bagh",
"Pusa",
"R K Puram",
"Rohini",
"Sonia Vihar",
"Sri Aurobindo Marg",
"Vivek Vihar",
"Wazirpur")


getRangeDataTS24 = function(df, par, site){
  df = subset(df,Site==site,select=c("Date", par))
  df = df[df[,par]!=-1,]
  return(getPartitions(df, par))
}

getPartitions = function(df, par){
  y0 = df[,par]
  if (length(y0)>0){
  y0 = y0[1:(length(y0)-1)]


  if (par=="AQI"){
    colourCode = ifelse(y0>401, "darkred", ifelse(301<y0, "red", ifelse(201<y0, "orange",
                    ifelse(61<y0, "yellow2", ifelse(31<y0, "green3", "darkgreen")))))
  }

  if (par=="PM2.5"){
    colourCode = ifelse(y0>250, "darkred", ifelse(121<y0, "red", ifelse(91<y0, "orange",
                    ifelse(61<y0, "yellow2", ifelse(31<y0, "green3", "darkgreen")))))
  }

  if (par=="PM10"){
    colourCode = ifelse(y0>430, "darkred", ifelse(351<y0, "red", ifelse(251<y0, "orange",
                   ifelse(101<y0, "yellow2", ifelse(51<y0, "green3", "darkgreen")))))
  }
  if (par=="NH3"){
    colourCode = ifelse(y0>1800, "darkred", ifelse(1200<y0, "red", ifelse(801<y0, "orange",
                   ifelse(401<y0, "yellow2", ifelse(201<y0, "green3", "darkgreen")))))
  }
  if (par=="SO2"){
    colourCode = ifelse(y0>1600, "darkred", ifelse(801<y0, "red", ifelse(381<y0, "orange",
                   ifelse(81<y0, "yellow2", ifelse(41<y0, "green3", "darkgreen")))))
  }

  darkredx0 = c()
  darkredx1 = c()
  darkredy0 = c()
  darkredy1 = c()

  redx0 = c()
  redx1 = c()
  redy0 = c()
  redy1 = c()

  orangex0 = c()
  orangex1 = c()
  orangey0 = c()
  orangey1 = c()

  yellowx0 = c()
  yellowx1 = c()
  yellowy0 = c()
  yellowy1 = c()

  greenx0 = c()
  greenx1 = c()
  greeny0 = c()
  greeny1 = c()

  darkgreenx0 = c()
  darkgreenx1 = c()
  darkgreeny0 = c()
  darkgreeny1 = c()

  for (i in 1:length(colourCode)){
    if (colourCode[i]=="darkred"){
      darkredx0 = append(darkredx0,df$Date[i])
      darkredx1 = append(darkredx1,df$Date[i+1])
      darkredy0 = append(darkredy0,df[,par][i])
      darkredy1 = append(darkredy1,df[,par][i+1])
    }
    else if (colourCode[i]=="red"){
      redx0 = append(redx0,df$Date[i])
      redx1 = append(redx1,df$Date[i+1])
      redy0 = append(redy0,df[,par][i])
      redy1 = append(redy1,df[,par][i+1])
    }
    else if (colourCode[i]=="orange"){
      orangex0 = append(orangex0,df$Date[i])
      orangex1 = append(orangex1,df$Date[i+1])
      orangey0 = append(orangey0,df[,par][i])
      orangey1 = append(orangey1,df[,par][i+1])
    }
    else if (colourCode[i]=="yellow2"){
      yellowx0 = append(yellowx0,df$Date[i])
      yellowx1 = append(yellowx1,df$Date[i+1])
      yellowy0 = append(yellowy0,df[,par][i])
      yellowy1 = append(yellowy1,df[,par][i+1])
    }
    else if (colourCode[i]=="green3"){
      greenx0 = append(greenx0,df$Date[i])
      greenx1 = append(greenx1,df$Date[i+1])
      greeny0 = append(greeny0,df[,par][i])
      greeny1 = append(greeny1,df[,par][i+1])
    }
    else if (colourCode[i]=="darkgreen"){
      darkgreenx0 = append(darkgreenx0,df$Date[i])
      darkgreenx1 = append(darkgreenx1,df$Date[i+1])
      darkgreeny0 = append(darkgreeny0,df[,par][i])
      darkgreeny1 = append(darkgreeny1,df[,par][i+1])
    }
  }

  darkredPartitions = list("x" = darkredx0, "xend"= darkredx1, "y"= darkredy0, "yend"= darkredy1)
  redPartitions = list("x" = redx0, "xend"= redx1, "y"= redy0, "yend"= redy1)
  orangePartitions = list("x" = orangex0, "xend"= orangex1, "y"= orangey0, "yend"= orangey1)
  yellowPartitions = list("x" = yellowx0, "xend"= yellowx1, "y"= yellowy0, "yend"= yellowy1)
  greenPartitions = list("x" = greenx0, "xend"= greenx1, "y"= greeny0, "yend"= greeny1)
  darkgreenPartitions = list("x" = darkgreenx0, "xend"= darkgreenx1, "y"= darkgreeny0, "yend"= darkgreeny1)
  partitions = list("darkredp" = darkredPartitions, "redp" = redPartitions,"orangep" = orangePartitions,
                    "yellowp" = yellowPartitions,"greenp" = greenPartitions,"darkgreenp" = darkgreenPartitions)
  return(partitions)
  }
  else{
    return(0)
  }
}


for (par in c("PM2.5", "PM10", "NH3", "SO2", "AQI")){
  for (st in st_list){
rangeDataTS24 = getRangeDataTS24(df24, par, st)
if (typeof(rangeDataTS24)== "list"){

emptyCol = c()
emptyCol1 = list("darkredp"="Severe","redp"="Very Poor", "orangep"="Poor",
                 "yellowp"="Moderate","greenp"="Satisfactory","darkgreenp"="Good")

for (i in names(emptyCol1)){
    if(length(rangeDataTS24[[i]]$x)!=0){
    emptyCol = append(emptyCol, emptyCol1[i])
    }
}

fig = plot_ly(type="scatter", mode = "markers")
for (j in names(emptyCol)){
    fig = add_segments(fig, x = rangeDataTS24[[j]]$x, y = rangeDataTS24[[j]]$y,
          xend = rangeDataTS24[[j]]$xend, yend = rangeDataTS24[[j]]$yend,
          line = list(color = col[[j]]), name = emptyCol[[j]])
}

layout(fig, automargin=TRUE, yaxis = list(rangemode = "tozero"))
save_image(p = fig, file = paste("data/", par, "/", st, ".png", sep=""), width=1500, height=750)
}
}
}
