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

db <- read_csv('data/dados_regressao.csv')

updateModel <- function() {
  model <<- lm(y ~ x * grupo, db)
}

insertData <- function(x, grupo, y) {
  #Retonar o ID
  }

modifyData <- function(id, x = NULL, grupo = NULL, y = NULL) {}

deleteData <- function(id) {}



#* @apiTitle API RegLinF
#* 
# API inserir dado no banco
#* @param x
#* @param grupo
#* @param y
#* @post /data/insert
function(x, grupo, y) {
  id <- insertData(x, grupo, y)
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
  #as.data.frame(summary(model)$coefficients[, 4])
  
}





