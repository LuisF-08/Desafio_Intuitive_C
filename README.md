# Desafio Intuitive_Care

Sistema para análise de despesas de operadoras de saúde usando dados abertos da ANS. Basicamente, peguei os dados brutos, limpei, joguei no banco e criei uma API com interface web pra visualizar tudo.

## O que tem aqui

**Backend**: FastAPI rodando em Python, conectado num PostgreSQL 17. A API tem endpoints pra listar operadoras, ver detalhes, histórico de despesas e estatísticas. Usei SQLModel pra facilitar a vida com os modelos e queries assíncronas.

**Frontend**: Vue.js 3 com Vite. Tem três telas principais: home com lista de operadoras, detalhes de cada uma e gráficos de despesas por UF. Usei Chart.js pra visualização.

**Dados**: Python com Jupyter Notebooks pra processar os CSVs da ANS. Limpei, validei, fiz merge com dados cadastrais e exportei pro banco.

**Banco**: PostgreSQL com três tabelas principais: operadoras cadastrais, despesas consolidadas e despesas agregadas. Os scripts SQL tão na pasta `sql/`.

## Como rodar

### Backend (FastAPI)
```bash
cd backend/app
pip install -r requirements.txt
uvicorn main:app --reload
```
Roda na porta 8000 por padrão. A documentação automática fica em `http://localhost:8000/docs`.

### Frontend (Vue.js)
```bash
cd frontend/vue-project
npm install
npm run dev
```
Roda na porta 5173 (Vite padrão).

### Banco de dados
Precisa ter o PostgreSQL rodando. Os scripts de criação das tabelas tão em `sql/schema.sql` e os de importação em `sql/import_*.sql`. Configure a conexão no `backend/app/database.py`.

## Estrutura

* `backend/` → API FastAPI
* `frontend/vue-project/` → Interface Vue.js
* `jupyter/` → Notebooks de processamento (spell.ipynb e validation.ipynb)
* `data/` → CSVs brutos e processados
* `sql/` → Scripts de criação e importação
* `docs/` → Documentação detalhada de cada etapa
* `postman/` → Collection pra testar a API

## Etapas (resumo)

### Etapa 1: Coleta e Limpeza dos Dados

Baixei os CSVs trimestrais (1T, 2T, 3T) direto do portal da ANS. Quando abri no Pandas, os dados tavam tudo numa coluna só - problema de delimitador. Ajustei pra `sep=';'` e aí funcionou.

Validei cada trimestre separadamente antes de juntar tudo. Isso ajuda a pegar erros específicos de cada arquivo e evita que problema de um contamine o resto. Fiz padronização de colunas, criei campos de `Ano` e `Trimestre`, removi duplicatas e corrigi uns bugs que apareceram (tipo trimestre errado em alguns registros).

Os dados contábeis não tinham CNPJ nem Razão Social, então fiz merge com a base de operadoras ativas da ANS. Usei `REG_ANS` como chave. Três registros não deram match e preenchi com `"nao_encontrado"` pra não perder os dados.

**Resultado**: `consolidando_despesas.csv` pronto pra próxima etapa.

### Etapa 2: Validação e Agregação

Passei o arquivo consolidado por uma validação mais rigorosa no `validation.ipynb`. Encontrei CNPJs inválidos, valores negativos (98 registros) e um com valor zero. Os negativos e zero podem fazer sentido dependendo da regra de negócio, então mantive. Mas CNPJs inválidos removi - esse campo precisa ser confiável.

Depois enriqueci de novo com dados cadastrais usando Left Join, garantindo que só os registros válidos da base principal fossem preservados.

Por fim, agregei tudo calculando soma, média trimestral e desvio padrão das despesas por operadora. Exportei pra `despesas_agregadas.csv`. Usei `groupby()` e `agg()` do Pandas - simples, eficiente e fácil de manter.

### Etapa 3: Banco de Dados e Queries

Criei três tabelas no PostgreSQL 17: `operadora_cadastrais`, `despesas_consolidadas` e `despesas_agregadas`. Normalizei separando dados fixos das operadoras dos dados transacionais - reduz redundância e facilita manutenção, mesmo que algumas queries precisem de join.

Usei `DECIMAL(18,2)` pra valores monetários (precisão exata) e `DATE` pro ano (permite funções nativas do SQL). O trimestre ficou como `INT` mesmo.

Pra importação, usei estratégia ELT: criei tabelas temporárias, importei os CSVs com `COPY` (ajustando encoding UTF8), e depois limpei/transformei com SQL antes de inserir nas tabelas finais. Tratei acentos quebrados, valores com "R$" e vírgulas, datas incompletas e campos obrigatórios faltando. Usei `DISTINCT ON` e `ON CONFLICT DO NOTHING` pra lidar com duplicatas.

Criei três queries analíticas focadas em operadoras que realmente têm dados comparáveis entre trimestres. Usei DBeaver pra testar - mais confortável que o Query Tool do pgAdmin.

### Etapa 4: API e Interface Web

**Backend**: FastAPI com SQLModel. Escolhi FastAPI pela performance, tipagem forte e facilidade de escalar. Criei endpoints pra listar operadoras (com paginação por offset), detalhar por CNPJ, histórico de despesas e estatísticas agregadas. Coloquei cache no endpoint de estatísticas (TTL de 10 minutos) porque faz agregações pesadas.

**Frontend**: Vue.js 3 com Vite. Três telas principais: home com lista paginada, detalhes da operadora e gráficos de despesas por UF (Chart.js). Usei Composition API com composables pra gerenciar estado. Busca híbrida (servidor + cliente) e tratamento explícito de loading e erros.

Documentei tudo no Postman com exemplos reais de requisições e respostas.

## Resultado

Sistema completo funcionando: dados limpos e validados no banco, API REST documentada e interface web pra visualizar tudo. Os arquivos processados ficam em `data/` e os scripts SQL em `sql/`.
