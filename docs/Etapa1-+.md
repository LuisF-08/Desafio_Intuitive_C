# Desafio Intuitive_Care

## Etapa 1.1: Coleta e Estruturação dos Dados

Os dados foram obtidos no portal de Dados Abertos da ANS, a partir dos arquivos trimestrais de 2025:
- `1T2025.csv`
- `2T2025.csv`
- `3T2025.csv`
- `dicionario_demonstracoes_contabeis.ods`

Os arquivos foram baixados manualmente, descompactados e armazenados na pasta `data/`.

---


## Etapa 1.2: Limpeza e Pré-processamento

O tratamento foi realizado em Python (Pandas) no notebook `spell.ipynb`.

Ao carregar os CSVs, foi identificado que os dados estavam vindo em uma única coluna. O problema era o delimitador incorreto, resolvido ajustando para `;`.  
Após isso, os dados passaram a ter estrutura legível e foi possível iniciar as validações.

---

## Estratégia de Validação e Tratamento

Cada arquivo trimestral foi validado **separadamente (1T, 2T e 3T)** antes da consolidação. Essa escolha foi intencional, pois:

#### Facilita encontrar erros específicos de cada arquivo
#### Evita que inconsistências se propaguem para o conjunto final  
#### Torna o processo mais organizado e reaproveitável para novos períodos  

Essa abordagem reflete uma prática comum em que : **corrigimos na origem antes de integrar**.

---

## Etapa 1.3: Enriquecimento dos Dados

Os arquivos contábeis não possuíam CNPJ nem Razão Social, então presumi que estava mesclado na API fornecida pelo ANS.  
foi utilizada a base complementar de operadoras ativas da ANS:

- Fonte: `operadoras_de_plano_de_saude_ativas/`

Após limpeza dessa base, foi realizado o *merge* para incluir:
- `CNPJ`
- `RazaoSocial`

Três registros ficaram sem correspondência e foram preenchidos com `"nao_encontrado"`, evitando nulos e facilitando possíveis usos futuros (ex: machine learning).

---

## Correções Aplicadas

Durante o processo, foram identificados e corrigidos:
#### Erro na atribuição de trimestre (df2 e df3 estavam sendo tratados como 1T)
#### Duplicidades geradas por erro de lógica
#### Registros inconsistentes com valores zerados em excesso

As correções foram feitas ainda na etapa individual de cada arquivo, antes da consolidação, pois como mencionado isso facilita a detectar possíveis erros futuros e póssiveis outros processos.

---

## Resultado Final

O processo gerou o arquivo final consolidado:

**Arquivo:** `consolidando_despesas.zip`  
**Local:** `pasta dos .csv o /data`  

