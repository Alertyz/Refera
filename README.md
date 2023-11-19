# Desafio de Análise de Vendas

Este repositório contém um projeto de análise de vendas que utiliza SQL para extrair insights valiosos a partir de dados de vendas fornecidos por uma empresa. O projeto inclui um conjunto de queries SQL que respondem a perguntas específicas sobre os dados de vendas.

## Estrutura do Repositório

- `/dados`: Esta pasta contém os arquivos de dados utilizados nas queries SQL.
- `queries.sql`: Este arquivo contém todas as queries SQL desenvolvidas para o desafio.
- `README.md`: Documento atual que fornece uma visão geral do projeto e instruções de uso.

## Dados

Os dados estão divididos em três arquivos principais:

1. `FatoDetalhes_DadosModelagem.csv`: Contém detalhes das vendas como produto, quantidade, valor, etc.
2. `FatoCabecalho_DadosModelagem.txt`: Inclui informações sobre o cabeçalho de cada venda, como data, cliente, valor do frete, etc.
3. `Dimensoes_DadosModelagem.xlsx`: Arquivo Excel com várias abas, contendo informações sobre clientes, funcionários, escritórios, categorias de produtos, produtos e fornecedores.

## Queries SQL

As queries SQL foram desenvolvidas para responder às seguintes perguntas:

1. Total de vendas e fretes por produto.
2. Valor de venda por tipo de produto.
3. Quantidade e valor das vendas por dia, mês, ano.
4. Lucro dos meses.
5. Venda por produto.
6. Venda por cliente, cidade do cliente e estado (região).
7. Média de produtos vendidos.
8. Média de compras que um cliente faz.

## Como Usar

Para executar as queries SQL, você precisará de um ambiente que suporte SQLite, como um software de gerenciamento de banco de dados (por exemplo, DB Browser for SQLite) ou uma linguagem de programação com suporte para SQLite (por exemplo, Python).

1. Clone ou faça o download deste repositório.
2. Abra os arquivos de dados na pasta `/dados` para revisar os dados disponíveis.
3. Execute as queries SQL contidas no arquivo `queries.sql` no seu ambiente SQLite.
