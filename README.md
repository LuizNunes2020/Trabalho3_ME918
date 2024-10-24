
<!-- README.md is generated from README.Rmd. Please edit that file -->

# API RegLinF - Regressão Linear com Plumber

Este repositório contém a implementação de uma API que permite ao
usuário interagir com um modelo de regressão linear e realizar a
manipulação do banco de dados utilizado para gerar o modelo através do
pacote **plumber** no R. A API permite a obter as estimas dos
coeficientes com seus respectivos níveis de significância, os resíduos,
predição e diversos gráficos de diagnósticos; também, é possível
realizar a inserção, modificação e exclusão de dados. O modelo de
regressão é atualizado toda vez em que o conjunto de dados é alterado.

## Estrutura do banco de dados

O conjunto de dados contém três colunas principais:

- **id**: número de identificação da observação

- **x**: variável numérica preditora.

- **grupo**: variável categórica com três possíveis categorias: A, B e
  C.

- **y**: variável resposta numérica contínua.

Além disso, uma coluna chamada `momento_registro` é adicionada
automaticamente com a data e o horário da inserção de cada registro.

## Inserir novo dado (POST /data/insert)

Para adicionar um novo registro, envie uma requisição para a rota
`/data/insert`, especificando `x`, `grupo` e `y` com os valores
apropriados. A API não suporta a inserção de mais do que uma observação
por vez.

A API retornará o `id` da observação inserida em formato `json`.

Exemplo: curl -X ‘POST’ \\
‘<http://127.0.0.1:4627/data/insert?x=4&grupo=B&y=3.2>’ \\ -H ‘accept:
\*/\*’ \\ -d ’’

## Modificar um dado existente (PUT /data/modify)

Para modificar um dado existente, basta fornecer o `id` do dado que será
modificado, juntamente com os novos valores para `x`, `grupo` e/ou `y`.
Se um dos valores não for fornecido, ele permanecerá inalterado.

Após a modificação, a API retornará `1` em formato `json` em caso de
sucesso.

Exemplo: curl -X ‘PUT’ \\
‘<http://127.0.0.1:4627/data/modify?id=26&grupo=C&y=2.6>’ \\ -H ‘accept:
\*/\*’

## Excluir um dado (DELETE /data/delete)

Para remover um dado, você deve fornecer o `id` da observação que se
deseja apagar do banco de dados para a rota `/data/delete`. Apenas uma
observação pode ser excluída por vez.

Caso a exclusão seja bem-sucedida, a API retornará `1` em formato
`json`.

Exemplo: curl -X ‘DELETE’ \\ ‘<http://127.0.0.1:4627/data/delete?id=26>’
\\ -H ‘accept: \*/\*’

## Gráfico da regressão linear (GET /lm/plot/data)

Utilize a rota `/lm/plot/data` para obter o gráfico em formato `png` com
a reta de regressão sobreposta aos dados.

Exemplo: curl -X ‘GET’ \\ ‘<http://127.0.0.1:4627/lm/plot/data>’ \\ -H
‘accept: image/png’

## Obter os parâmetros do modelo (GET /lm/parameters)

Para obter as estimativas dos coeficientes do modelo, basta enviar uma
requisição `GET` para a rota `/lm/parameters`.

A resposta da API será em `json`.

Exemplo: curl -X ‘GET’ \\ ‘<http://127.0.0.1:4627/lm/parameters>’ \\ -H
‘accept: \*/\*’

## Gráfico de resíduos (GET /lm/plot/residuals)

A rota `/lm/plot/residuals` permite analisar os resíduos do modelo de
regressão ajustado, ou seja, as diferenças entre os valores observados e
os valores preditos. A API retornará um gráfico em formato PNG mostrando
os resíduos, o que pode ajudar a avaliar a qualidade do ajuste do
modelo.

Exemplo: curl -X ‘GET’ \\ ‘<http://127.0.0.1:4627/lm/plot/residuals>’ \\
-H ‘accept: image/png’

## Resíduos do modelo (GET /lm/residuals)

A rota `/lm/residuals` retorna os resíduos do modelo de regressão
ajustado para todas as observações do conjunto de dados.

A resposta da API será em `json`.

Exemplo: curl -X ‘GET’ \\ ‘<http://127.0.0.1:4627/lm/residuals>’ \\ -H
‘accept: \*/\*’

## Significância dos parâmetros (GET /lm/parameters/siglevel)

Se você deseja obter os valores de significância estatística (p-values)
dos coeficientes do modelo, acesse a rota `/lm/parameters/siglevel`.

A resposta da API será em `json`.

Exemplo: curl -X ‘GET’ \\
‘<http://127.0.0.1:4627/lm/parameters/siglevel>’ \\ -H ‘accept: \*/\*’

## Predição para novos dados (POST /lm/predictions)

A API também permite realizar predições com base no modelo ajustado.
Essa rota aceita vários valores de preditores numa mesma requisição.
Para isso, basta fornecer um `json` no formato
`[{"x": 1, "grupo": "A"}, {"x": 4, "grupo": "C"}]`, por exemplo para
duas predições, para a rota `/lm/predictions`.

A API retornará os valores preditos em formato `json`.

Exemplo: curl -X “POST” “<http://localhost:4627/lm/predictions>” -H
“accept: \*/\*” -H “content-type:application/json” –data “{{"x": 1,
"grupo": "A"}, {"x": 5, "grupo": "B"}}”