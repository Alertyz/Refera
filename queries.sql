-- Query 1: Total de Vendas e Fretes por Produto
-- Esta query calcula o total de vendas e fretes por produto.
SELECT
       fato_detalhes.ProdutoID,
       SUM(fato_detalhes.Valor) AS TotalVendas,
       SUM(fato_cabecalho.ValorFrete) AS TotalFretes
FROM
       fato_detalhes
       INNER JOIN fato_cabecalho ON fato_detalhes.CupomID = fato_cabecalho.CupomID
GROUP BY
       fato_detalhes.ProdutoID;

-- Query 2: Valor de Venda por Tipo de Produto
-- Esta query soma o valor de vendas por categoria de produto.
SELECT
       CategoriaID,
       SUM(Valor) AS ValorVendas
FROM
       fato_detalhes
       JOIN produtos ON fato_detalhes.ProdutoID = produtos.ProdutoID
GROUP BY
       CategoriaID;

-- Query 3: Quantidade e Valor das Vendas por Dia, Mes, Ano
-- Esta query conta e soma o valor das vendas por dia, mes e ano.
WITH
       DailySales AS (
              SELECT
                     strftime ('%Y-%m-%d', fato_cabecalho.Data) AS Dia,
                     COUNT(DISTINCT fato_detalhes.CupomID) AS QuantidadeVendasDia,
                     SUM(fato_detalhes.Valor) AS ValorVendasDia
              FROM
                     fato_detalhes
                     INNER JOIN fato_cabecalho ON fato_detalhes.CupomID = fato_cabecalho.CupomID
              GROUP BY
                     Dia
       ),
       MonthlySales AS (
              SELECT
                     strftime ('%Y-%m', fato_cabecalho.Data) AS Mes,
                     COUNT(DISTINCT fato_detalhes.CupomID) AS QuantidadeVendasMes,
                     SUM(fato_detalhes.Valor) AS ValorVendasMes
              FROM
                     fato_detalhes
                     INNER JOIN fato_cabecalho ON fato_detalhes.CupomID = fato_cabecalho.CupomID
              GROUP BY
                     Mes
       ),
       YearlySales AS (
              SELECT
                     strftime ('%Y', fato_cabecalho.Data) AS Ano,
                     COUNT(DISTINCT fato_detalhes.CupomID) AS QuantidadeVendasAno,
                     SUM(fato_detalhes.Valor) AS ValorVendasAno
              FROM
                     fato_detalhes
                     INNER JOIN fato_cabecalho ON fato_detalhes.CupomID = fato_cabecalho.CupomID
              GROUP BY
                     Ano
       )
SELECT
       ds.Dia,
       ds.QuantidadeVendasDia,
       ds.ValorVendasDia,
       ms.Mes,
       ms.QuantidadeVendasMes,
       ms.ValorVendasMes,
       ys.Ano,
       ys.QuantidadeVendasAno,
       ys.ValorVendasAno
FROM
       DailySales ds
       JOIN MonthlySales ms ON ds.Dia LIKE ms.Mes || '-%'
       JOIN YearlySales ys ON ds.Dia LIKE ys.Ano || '%'
ORDER BY
       ds.Dia,
       ms.Mes,
       ys.Ano;

-- Query 4: Lucro dos Meses
-- Esta query calcula o lucro por mes.
SELECT
       strftime ('%Y-%m', Data) AS Mes,
       SUM(ValorLiquido) AS Lucro
FROM
       fato_detalhes
       JOIN fato_cabecalho ON fato_detalhes.CupomID = fato_cabecalho.CupomID
GROUP BY
       Mes;

-- Query 5: Venda por Produto
-- Esta query soma a quantidade e o valor total das vendas por produto.
SELECT
       ProdutoID,
       SUM(Quantidade) AS TotalQuantidade,
       SUM(Valor) AS TotalValor
FROM
       fato_detalhes
GROUP BY
       ProdutoID;

-- Query 6: Venda por Cliente, Cidade e Estado
-- Esta query soma o valor das vendas por cliente e cidade (usando regioo como estado).
SELECT
       clientes.ClienteID,
       clientes.Cidade,
       clientes.Regiao AS Estado,
       SUM(fato_detalhes.Valor) AS ValorVendas
FROM
       fato_detalhes
       INNER JOIN fato_cabecalho ON fato_detalhes.CupomID = fato_cabecalho.CupomID
       INNER JOIN clientes ON fato_cabecalho.ClienteID = clientes.ClienteID
GROUP BY
       clientes.ClienteID,
       clientes.Cidade,
       clientes.Regiao;

-- Query 7: Media de Produtos Vendidos
-- Esta query calcula a media de quantidade de produtos vendidos.
SELECT
       AVG(Quantidade) AS MediaQuantidade
FROM
       fato_detalhes;

-- Query 8: Media de Compras que um Cliente Faz
-- Esta query calcula a media do valor das compras por cliente, incluindo o frete.
SELECT
       fato_cabecalho.ClienteID,
       AVG(fato_detalhes.Valor + fato_cabecalho.ValorFrete) AS MediaValorCompras
FROM
       fato_detalhes
       INNER JOIN fato_cabecalho ON fato_detalhes.CupomID = fato_cabecalho.CupomID
GROUP BY
       fato_cabecalho.ClienteID;