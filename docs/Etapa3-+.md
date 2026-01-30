# 3.1: Criação eorganização de estruturas
## Criei a pasta sql/ e inicialmente coloque o script schema.sql que seráonde irei aplicar a criação das tabelas com base nos consolidando_despesas do 1.3 , despesas_agregadas do 2.3 e o do 2.2 que seriam os dados antes de serem agregados o dados_operadoras_cadastrais, como mencionando no Etapa3-0.md.

# 3.2: Criação de tabelas
## Criei três tabelas no schema.sql , criei operadores_cadastrais, depesas_consolidadas e despesas_agregadas. Percebi que colocar o cnpj com chave primária seria ruim , pois em despesas_agregadas não ficoiu CNPJ algum, logo colocar o id com chave primária faz mais sentido nesse contexto

---

## 1 -  Normalização 

Escolhi fazer em **tabelas separadas**:

* `operadora_cadastrais` → dados fixos da operadora
* `despesas_consolidadas` → despesas trimestrais por CNPJ
* `despesas_agregadas` → resultados agregados

#### Ou sendo mais exato escolhi a (Opção B).

> "Escolhi uma abordagem normalizada (tabelas separadas) porque o volume de dados de despesas trimestrais pode crescer bastante, e separar os dados da operadora dos dados transacionais reduz redundância e facilita manutenção.
> permite tambèm atualizar os dados cadastrais sem alterar múltiplas linhas de despesas, e mantém as consultas analíticas.
> Apesar de exigir joins em algumas queries, profissiobnalmente irá gerar muita ,menos dor de cabeça para manipulações e mantém uma escalabilidade melhor"

---

## 2 - Tipos de dados 

### Valores monetários:


> "Escolhi DECIMAL para armazenar valores monetários porque garante precisão exata podendfo escolher o tamnho exato que que pode receber, evitando erros de arredondamento. Armazenar em INTEGER seria possíve e até usado em determinados contextos, mas DECIMAL é mais legível e mantém precisão suficiente para relatórios financeiros e precisão maior nesse contexto."

---

### 3 - Datas (ano e trimestre):

escolhi usar o tipo **DATA** em ano e **INT** em trimestre:

>" Optei por armazenar a data de referência como DATE, enquanto o trimestre permanece como INT."
>"Dessa forma, mantemos precisão , permitindo funções de data nativas do SQL, sem perder a simplicidade na agregação trimestral."
>" Usar o DATE também garante integridade e consistência dos dados, e facilita futuras análises de períodos ou cruzamentos com outras tabelas temporais."

---

## Resumo de minhas escolha 

**Normalização:**
Escolhi normalizar os dados em três tabelas separadas: `operadora_cadastrais`, `despesas_consolidadas` e `despesas_agregadas`. Isso reduz redundância, facilita manutenção e melhora escalabilidade. Embora algumas queries precisem de joins, o ganho em integridade e organização supera a complexidade.

**Valores monetários:**
DECIMAL(18,2) foi escolhido por garantir precisão exata em valores financeiros, evitando erros de arredondamento. INTEGER  seria uma alternativa, mas DECIMAL é mais legível e suficiente.

**Datas (ano e trimestre):**
Ano e trimestre foram armazenados como INT para simplificar o modelo e acelerar agregações, pois não há necessidade de registrar dia ou hora. DATE ou TIMESTAMP seriam mais precisos, mas desnecessários neste contexto.

Claro! Aqui está uma versão bem direta, fácil de ler e que explica exatamente o que você fez e por que, cobrindo todos os pontos exigidos.

---

Como você mudou para o **PostgreSQL**, a lógica geral (ELT) continua a mesma, mas os **comandos técnicos** citados na documentação precisam ser ajustados.

No PostgreSQL:
1.  Não existe `LOAD DATA INFILE`, usamos **`COPY`**.
2.  Não existe `INSERT IGNORE`, usamos **`ON CONFLICT DO NOTHING`**.
3.  A conversão de data usa **`TO_DATE`**.
4.  Para deduplicar registros na seleção, o Postgres tem um comando específico muito poderoso chamado **`DISTINCT ON`**.

Aqui está a sua documentação ajustada para a realidade do PostgreSQL:

---

# 3.3: Importação e Tratamento de Dados

**Resumo da Estratégia**
Para evitar erros durante a importação, adotei o método **ELT** (Extrair, Carregar, Transformar). Criei tabelas temporárias para receber os dados "sujos" e brutos do CSV via comando `COPY`, e usei SQL para limpar e formatar esses dados antes de inseri-los nas tabelas oficiais.

**Organização dos Arquivos**
Criei um script SQL específico para cada fonte de dados na pasta `sql/`:
*   `import_operadoras.sql` (Dados Cadastrais)
*   `import_despesas.sql` (Despesas Consolidadas)
*   `import_agregadas.sql` (Dados Agregados)

**Soluções Adotadas**
Para atender às exigências do banco de dados (PostgreSQL) sem perder informações, tratei os seguintes casos:

1.  **Acentos Quebrados (Encoding):**
    Configurei o comando `COPY` com a opção `ENCODING 'UTF8'` para garantir a leitura correta dos caracteres.

2.  **Texto em lugar de Número (R$ e Vírgulas):**
    O banco exige números puros com ponto (ex: `1000.50`), mas o CSV trazia `R$ 1.000,50`.
    *   Removi o "R$", troquei a vírgula por ponto e converti para `DECIMAL` usando `CAST`.

3.  **Datas Incompletas:**
    O CSV trazia apenas o ano ("2023"), mas o banco exigia uma data completa.
    *   Padronizei convertendo "2023" para "2023-01-01" utilizando a função `TO_DATE`, permitindo que o banco aceitasse o registro.

4.  **Campos Obrigatórios Faltando (NULL):**
    O arquivo de despesas não tinha informações de UF ou Registro ANS, mas a tabela de cadastro exigia esses campos.
    *   Para não perder os dados financeiros rejeitando a linha, preenchi esses campos com valores padrão (`'XX'` e `'000000'`).

5.  **Conflito de Lógica no Schema:**
    A estrutura do banco pedia dados de despesa (valor) na tabela de cadastro, mas o cadastro (CNPJ) não podia se repetir.
    *   Utilizei o comando **`DISTINCT ON`** para garantir que apenas um registro único por CNPJ fosse selecionado para o cadastro e **`ON CONFLICT DO NOTHING`** para ignorar duplicatas, salvando o histórico completo de gastos na tabela `despesas_consolidadas`.

---

# 3.4: Queries Analíticas

Nessa etapa, até aqui eu não tinha versionadomcom Git, então msubi meu projeto pro github nesse link -> https://github.com/LuisF-08/Desafio_Intuitive_C, acredito que como um dos critérios de diferencial seja versionamento e eu já entendo um pouco não será problema ter uma segunda fonte de entrega. Recapitulando, eu estava basicamente trabalhando com base na documentação e em experiências de projetos pessoais — principalmente aqueles que envolvem análise de dados, uso de notebooks `.ipynb` e scripts SQL. Até esse ponto, o foco ainda não era subir tudo de forma definitiva, mas entender bem os dados e como eles se comportavam nas consultas.

Escolhi utilizar o **DBeaver** para executar as queries porque, na prática, ele acaba sendo mais confortável para escrever, testar e ajustar consultas do que o Query Tool do pgAdmin. Mesmo usando PostgreSQL como banco, o DBeaver facilitou bastante a visualização dos resultados e a organização das consultas.

#### Depois da normalização e da carga das tabelas finais, passei a fazer as análises diretamente no banco. As queries foram pensadas levando em conta que algumas operadoras não possuem dados em todos os trimestres, evitando comparações que poderiam gerar resultados distorcidos.

**Query 1:**  
A solução evita o uso de funções de janela desnecessárias, mantendo a consulta mais simples e fácil de entender. A performance é adequada para um volume moderado de dados e só considera operadoras que realmente permitem comparação entre períodos.

**Query 2:**  
O uso direto de `GROUP BY` deixa a query bem legível e intuitiva, sem complexidade excessiva. Além disso, facilita ajustes futuros, caso seja necessário incluir novas métricas na análise.

**Query 3:**  
Foi utilizada uma subquery simples e direta, priorizando clareza e leitura fácil. A abordagem é suficiente para o cenário analisado e evita soluções mais complexas que não trariam ganho real nesse contexto.





