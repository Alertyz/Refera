import sqlite3
import pandas as pd

# Função para carregar dados de um arquivo CSV para um DataFrame
def carregar_csv_para_df(nome_arquivo, delimitador, decimal):
    return pd.read_csv(nome_arquivo, delimiter=delimitador, decimal=decimal)

# Função para carregar dados de um arquivo Excel para um dicionário de DataFrames
def carregar_excel_para_dfs(nome_arquivo):
    excel_file = pd.ExcelFile(nome_arquivo)
    return {sheet_name: excel_file.parse(sheet_name) for sheet_name in excel_file.sheet_names}

# Função para importar DataFrames para um banco de dados SQLite
def importar_dfs_para_sqlite(dfs, conexao):
    for nome, df in dfs.items():
        df.to_sql(nome, conexao, index=False, if_exists='replace')

# Função para executar queries de um arquivo SQL
def executar_queries_de_arquivo(nome_arquivo, conexao):
    with open(nome_arquivo, 'r') as file:
        lines = file.readlines()

    current_query = ""
    for line in lines:
        if line.strip().startswith('-- Query'):
            if current_query:
                # Executar a query anterior
                print(f"{titulo}\n{comentario}")
                query_result = pd.read_sql_query(current_query, conexao)
                print(query_result)
                print("\n" + "-"*50 + "\n")  # Linha separadora para cada resultado
                current_query = ""
            titulo = line.strip()  # Atualiza o título da query
            comentario = ""
        elif line.strip().startswith('--'):
            comentario += line
        else:
            current_query += line

    # Executar a última query se houver
    if current_query:
        print(f"{titulo}\n{comentario}")
        query_result = pd.read_sql_query(current_query, conexao)
        print(query_result)
        print("\n" + "-"*50 + "\n")  # Linha separadora para cada resultado

# Carregar os DataFrames
df_fato_detalhes = carregar_csv_para_df('dados/FatoDetalhes_DadosModelagem.csv', ';', ',')
df_fato_cabecalho = carregar_csv_para_df('dados/FatoCabecalho_DadosModelagem.txt', '\t', ',')
dfs_dimensoes = carregar_excel_para_dfs('dados/Dimensoes_DadosModelagem.xlsx')

# Converter datas para o formato correto
df_fato_cabecalho['Data'] = pd.to_datetime(df_fato_cabecalho['Data'], format='%d/%m/%Y').dt.strftime('%Y-%m-%d')

# Conectar ao banco de dados SQLite em memória
conexao = sqlite3.connect(':memory:')

# Importar os DataFrames para o banco de dados SQLite
importar_dfs_para_sqlite({'fato_detalhes': df_fato_detalhes, 'fato_cabecalho': df_fato_cabecalho}, conexao)
importar_dfs_para_sqlite(dfs_dimensoes, conexao)

# Executar as queries do arquivo SQL
executar_queries_de_arquivo('queries.sql', conexao)

# Fechar a conexão com o banco de dados
conexao.close()
