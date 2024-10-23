
<!-- README.md is generated from README.Rmd. Please edit that file -->

# API RegLinF - Regressão Linear com Plumber

Este repositório contém a implementação de uma API para manipulação de
um banco de dados utilizando o pacote **plumber** no R. A API permite a
inserção, modificação, exclusão de dados e também análise de regressão
linear múltipla com covariáveis. O objetivo principal desta API é
realizar inferências com base em um modelo de regressão linear ajustado
e gerar predições a partir de novos dados.

## Estrutura do Banco de Dados

O conjunto de dados contém três colunas principais: - **x**: variável
numérica preditora. - **grupo**: variável categórica com três possíveis
categorias: A, B e C. - **y**: variável resposta numérica contínua. Além
disso, uma coluna chamada `momento_registro` é adicionada
automaticamente com a data e o horário da inserção de cada registro.

## Inserir Novo Dado

Para adicionar um novo registro, acesse a rota `/data/insert`, clique em
“Try it out” e preencha os campos correspondentes às variáveis
preditoras (x), resposta (y) e categórica (grupo) com os valores
apropriados. As variáveis x e y devem ser numéricas, enquanto a variável
grupo deve ser inserida como uma string. Após clicar em “Execute”, a API
atualizará o banco de dados com o novo registro e retornará a observação
inserida, incluindo a data e o horário de sua inserção.

Por exemplo, se os espaços fossem preenchidos com `x = 4`, `grupo = A`,
e `y = 7`, a API retornará:

## Modificar um Dado Existente

Para modificar um dado existente, basta fornecer o **id** do dado que
será modificado, juntamente com os novos valores para **x**, **grupo**
e/ou **y**. Se um dos valores não for fornecido, ele permanecerá
inalterado.

Exemplo: Se você quiser modificar o dado de ID 2, alterando `x` para 5 e
`y` para 8, basta utilizar a rota `/data/modify`. Portanto, a API
retornará:

Após a modificação, a API retornará uma mensagem confirmando o sucesso
da operação.

## Excluir um Dado

Para remover um dado, você deve acessar a rota `/data/delete` ,
selecionar “Try it out” e fornecer o id correspondente à linha que
deseja excluir. O id refere-se à identificação única do registro, não
necessariamente corresponde ao número da linha no conjunto de dados.
Após a exclusão, a API atualizará o banco de dados e exibirá uma
mensagem de sucesso. Apenas uma observação pode ser excluída por vez.

## Inferências sobre o Modelo de Regressão

### Obter os Parâmetros do Modelo

Para obter os coeficientes do modelo de regressão linear ajustado e o
desvio padrão residual (**sigma**), você pode utilizar a rota
`/lm/parameters`. Esses parâmetros são calculados a partir do banco de
dados atual, que já reflete qualquer nova inserção de dados. A resposta
da API será um JSON com os valores ajustados dos coeficientes.

Por exemplo, ao calcular os parâmetros do banco de dados contido neste
repositório, a API retornará:

### Significância dos Parâmetros

Se você deseja obter os valores de significância estatística (p-values)
dos coeficientes do modelo, basta acessar a rota
`/lm/parameters/siglevel`. A API retornará um JSON com os valores de p
para os coeficientes do modelo.

### Gráfico da Regressão Linear

Você pode visualizar um gráfico da regressão linear ajustada para os
dados presentes no banco de dados, incluindo os pontos de dados e as
retas ajustadas para cada grupo categórico. Para isso, utilize a rota
`/lm/plot/data`, que retornará um gráfico no formato PNG com a reta de
regressão sobreposta aos dados.

Por exemplo, ao gerar um gráfico a partir do banco de dados contido
neste respositório e seus parâmetros, a API retornará a seguinte imagem:

### Gráfico de Resíduos

A rota `/lm/plot/residuals` permite analisar os resíduos do modelo de
regressão ajustado, ou seja, as diferenças entre os valores observados e
os valores preditos. A API retornará um gráfico em formato PNG mostrando
os resíduos, o que pode ajudar a avaliar a qualidade do ajuste do
modelo.

Por exemplo, ao gerar os gráficos de resíduos a partir do banco de dados
contido neste respositório, a API retornará a seguinte imagem:

## Predição para Novos Dados

A API também permite realizar predições com base no modelo ajustado.
Para isso, basta fornecer os valores de **x** e **grupo** de um novo
dado na rota `/lm/predictions`. A API retornará o valor predito com base
nos parâmetros do modelo atual.

Por exemplo, se você quiser prever o valor de y para uma nova observação
com `x` = 5 e `grupo = A`, a requisição enviará esses dados para a API,
que retornará o seguinte valor predito: