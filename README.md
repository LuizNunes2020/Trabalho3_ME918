
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

![](README_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

## Obter os parâmetros do modelo (GET /lm/parameters)

Para obter as estimativas dos coeficientes do modelo, basta enviar uma
requisição `GET` para a rota `/lm/parameters`.

A resposta da API será em `json`.

Exemplo: curl -X ‘GET’ \\ ‘<http://127.0.0.1:4627/lm/parameters>’ \\ -H
‘accept: \*/\*’

    #> [{"(Intercept)":1.3198,"x":-1.6864,"grupoB":-1.0356,"grupoC":5.2414,"x:grupoB":0.5487,"x:grupoC":-0.5252,"sigma":2.8471}]

## Gráfico de resíduos (GET /lm/plot/residuals)

A rota `/lm/plot/residuals` permite analisar os resíduos do modelo de
regressão ajustado, ou seja, as diferenças entre os valores observados e
os valores preditos. A API retornará um gráfico em formato PNG mostrando
os resíduos, o que pode ajudar a avaliar a qualidade do ajuste do
modelo.

Exemplo: curl -X ‘GET’ \\ ‘<http://127.0.0.1:4627/lm/plot/residuals>’ \\
-H ‘accept: image/png’

![](README_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

## Resíduos do modelo (GET /lm/residuals)

A rota `/lm/residuals` retorna os resíduos do modelo de regressão
ajustado para todas as observações do conjunto de dados.

A resposta da API será em `json`.

Exemplo: curl -X ‘GET’ \\ ‘<http://127.0.0.1:4627/lm/residuals>’ \\ -H
‘accept: \*/\*’

    #> [{"id":1,"residuo":-1.2116},{"id":2,"residuo":-0.9007},{"id":3,"residuo":-2.7461},{"id":4,"residuo":1.1013},{"id":5,"residuo":-1.6361},{"id":6,"residuo":1.3871},{"id":7,"residuo":0.2716},{"id":8,"residuo":-0.095},{"id":9,"residuo":-0.3865},{"id":10,"residuo":0.3743},{"id":11,"residuo":0.4412},{"id":12,"residuo":3.0359},{"id":13,"residuo":-4.5985},{"id":14,"residuo":0.4264},{"id":15,"residuo":-2.5699},{"id":16,"residuo":-1.1104},{"id":17,"residuo":-0.2519},{"id":18,"residuo":-1.6037},{"id":19,"residuo":-0.9334},{"id":20,"residuo":-0.3582},{"id":21,"residuo":-0.8702},{"id":22,"residuo":-1.4609},{"id":23,"residuo":0.1865},{"id":24,"residuo":-2.3184},{"id":25,"residuo":0.4705},{"id":26,"residuo":3.7098},{"id":27,"residuo":-0.2908},{"id":28,"residuo":-0.3725},{"id":29,"residuo":10.517},{"id":30,"residuo":1.7933}]

## Significância dos parâmetros (GET /lm/parameters/siglevel)

Se você deseja obter os valores de significância estatística (p-values)
dos coeficientes do modelo, acesse a rota `/lm/parameters/siglevel`.

A resposta da API será em `json`.

Exemplo: curl -X ‘GET’ \\
‘<http://127.0.0.1:4627/lm/parameters/siglevel>’ \\ -H ‘accept: \*/\*’

    #> [{"(Intercept)":0.5419,"x":0.0123,"grupoB":0.7638,"grupoC":0.0947,"x:grupoB":0.5261,"x:grupoC":0.49}]

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
