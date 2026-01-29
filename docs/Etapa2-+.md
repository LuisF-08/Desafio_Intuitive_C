# Etapa 2 — Transformação e Validação dos Dados

## 2.1 Tratamento de erros lógicos no CSV gerado

O arquivo `.csv` gerado passou por um processo de validação utilizando **Pandas**.

- **Arquivo tratado:** `data/dados_consolidados_final.csv`  
- **Arquivo com os scripts em Python:** `validation.ipynb`

Após a análise, foi identificado que o arquivo ainda apresentava **inconsistências lógicas**, como:
- CNPJs inválidos, Problemas de tipo de dado (caractere/tipo incorreto)  
- Campos com tamanho inadequado e Valores de despesas inválidos (especialmente negativos ou inconsistentes)

Com base nisso, defini três critérios principais de validação:
- **Tipo do dado (caractere correto)**
- **Tamanho do campo**
- **Validação do valor de despesas (principalmente se positivo)**

Durante a análise, encontrei:
- 1 registro com valor de despesa igual a 0  
- 98 registros com valores negativos  

Esses casos podem ser aceitáveis dependendo da regra de negócio, então **optei por não removê-los**.

Por outro lado, identifiquei **CNPJs inválidos**. Como esse campo exige alta confiabilidade e pode comprometer análises futuras, **decidi remover esses registros**, mesmo que alguns possuíssem valores de despesas preenchidos.

> **Observação:**  
> Mesmo sabendo que a remoção afetaria alguns registros com dados válidos em outras colunas, considerei essa decisão necessária, pois o campo de CNPJ exige extrema precisão para manter a integridade do conjunto de dados.

---

## 2.2 Enriquecimento dos dados

Nesta etapa, utilizei o conjunto de dados cadastrais disponível em:  
> https://dadosabertos.ans.gov.br/FTP/PDA/operadoras_de_plano_de_saude_ativas/

O arquivo `relatorio_cadop.csv` foi baixado manualmente e utilizado para enriquecer os dados já tratados.

Em seguida, realizei a junção dos datasets utilizando um **Left Join**, considerando que:
- A tabela da esquerda (`df_entrega`) já estava limpa  
- A tabela da direita (`cadastro`, proveniente do `relatorio_cadop.csv`) continha dados brutos  

Dessa forma, garanti que apenas os registros válidos da base principal fossem preservados, adicionando apenas as informações complementares.

---

## Agregação e consolidação dos dados

Após o enriquecimento:
- Realizei a agregação dos dados em um novo DataFrame  
- Calculei:
  - Soma das despesas  
  - Média de despesas por trimestre  
  - Desvio padrão das despesas  

O resultado foi exportado para o arquivo:  
`despesas_agregadas.csv`

Tecnicamente, utilizei:
- `groupby()` com `agg()` para agregação  
- `sort_values()` para ordenação dos dados  

Essa abordagem foi escolhida por ser:
- Eficiente para volumes moderados de dados  
- Fácil de manter  
- Clara para leitura  
- Adequada para evitar complexidade desnecessária no código
