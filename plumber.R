#
# This is a Plumber API. In RStudio 1.2 or newer you can run the API by
# clicking the 'Run API' button above.
#
# In RStudio 1.1 or older, see the Plumber documentation for details
# on running the API.
#
# Find out more about building APIs with Plumber here:
#
#    https://www.rplumber.io/
#

library(plumber)
library(tidyverse)
library(jsonlite)

db <- read_csv('data/dados_regressao.csv')

updateModel <- function() {
  model <<- lm(y ~ x * grupo, db)
}

updateModel()

insertData <- function(x, grupo, y) {
  #Retonar o ID
  id <-  max(db$id) + 1
  db <<- db %>% add_row(data.frame(id = id, x = x, grupo = grupo, y = y, momento_registro = lubridate::now()))
  
  updateModel()
  return(id)
}

modifyData <- function(id, x = NULL, grupo = NULL, y = NULL) {
  indice <- which(db$id == id)
  db$x[indice] <<- ifelse(is.null(x), db$x[indice], x)
  db$grupo[indice] <<- ifelse(is.null(grupo), db$grupo[indice], grupo)
  db$y[indice] <<- ifelse(is.null(y), db$y[indice], y)
  db$momento_registro[indice] <<- lubridate::now()
  updateModel()
}

deleteData <- function(id) {
  if(!(id %in% db$id)) stop('Erro: ID não existente')
  indice <- which(db$id == id)
  db <<- db[-indice, ]
  
  updateModel()
}



#* @apiTitle API RegLinF
#* 
# API inserir dado no banco
#* @param x
#* @param grupo
#* @param y
#* @post /data/insert
function(x, grupo, y) {
  id <- insertData(as.numeric(x), grupo, as.numeric(y))
  print(id)
}

# API modificar dado
#* @param id
#* @param x
#* @param grupo
#* @param y
#* @put /data/modify
function(id, x = NULL, grupo = NULL, y = NULL) {
  modifyData(id, x, grupo, y)
  print("Alteração feita com sucesso!")
}

# API deletar dado
#* @param id
#* @delete /data/delete
function(id) {
  deleteData(id)
  print("Dado deletado com sucesso!")
}

#* @serializer png
#* @get /lm/plot/data
function() {
  plot <- ggplot(db, aes(x = x, y = y, color = grupo)) +
    geom_point() +
    geom_smooth(formula = y ~ x, method = 'lm', se = FALSE) +
    theme_bw()
  
  print(plot)
}

#* @get /lm/parameters
function() {
  as.matrix(c(model$coefficients, 'sigma' = summary(model)$sigma)) |>
    t() |>
    as.data.frame()
}


#* @serializer png
#* @get /lm/plot/residuals
function(){
  plot <- ggplot(NULL, aes(x = model$fitted, y = model$residuals)) +
    geom_point() +
    labs(x = 'Ajustados',
         y = 'Resíduos') +
    theme_bw()
  
  print(plot)
}

#* @get /lm/residuals
function() {
  data.frame(id = db$id, residuo = model$residuals)
}

#* @get /lm/parameters/siglevel
function() {
  as.matrix(summary(model)$coefficients[, 4]) |>
    t() |>
    as.data.frame()
  
}

#* @post /lm/predictions
function(req) {
  # curl -X "POST" "http://localhost:7572/lm/predictions" -H "accept: */*" -H "content-type:application/json" --data "{{\"x\": 1, \"grupo\": \"A\"}, {\"x\": 5, \"grupo\": \"B\"}}"

  
  # preditores <- do.call(rbind, lapply(body, as.data.frame))
  predict(model, req$body)
}





