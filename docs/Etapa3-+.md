# Etapa 3.0

# 3.1: Criação eorganização de estruturas
## Criei a pasta sql/ e inicialmente coloque o script schema.sql que seráonde irei aplicar a criação das tabelas com base nos consolidando_despesas do 1.3 , despesas_agregadas do 2.3 e o do 2.2 que seriam os dados antes de serem agregados o dados_operadoras_cadastrais, como mencionando no Etapa3-0.md.

# 3.2: Criação de tabelas
## Criei três tabelas no schema.sql , criei operadores_cadastrais, depesas_consolidadas e despesas_agregadas. Percebi que colocar o cnpj com chave primária seria ruim , pois em despesas_agregadas não ficoiu CNPJ algum, logo colocar o id com chave primária faz mais sentido nesse contexto