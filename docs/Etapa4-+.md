# 4.1 Estruturação da API

Como foi escolhido por mim, utilizarei o **PostgreSQL** com **3 tabelas principais**:

* `despesas_agregadas`
* `despesas_consolidadas`
* `operadora_cadastrais`

Foi criada a pasta `app/` dentro de `backend/`, contendo a seguinte estrutura:

```python
__init__.py        # Usado para o Python detectar o diretório como pacote
main.py            # Arquivo de ponto de entrada da aplicação
database.py        # Configuração de comunicação com o PostgreSQL
models.py          # Modelos das tabelas do banco
teste_db.py        # Testes de conexão com o banco
routers/           # Endpoints (rotas da API)
routers/__init__.py
routers/usuarios.py  # CRUD de usuários
requirements.txt
```

---

# 4.2 Criação de Rotas

As rotas foram implementadas no arquivo `main.py`, sendo elas:

* `lista_operadoras()`
  Lista as operadoras com paginação e limite de registros.

* `detalhar_operadora()`
  Detalha uma operadora com base no campo `cnpj`.

* `listar_despesas_operadora()`
  Lista as despesas associadas ao CNPJ informado.

* `obter_estatisticas()`
  Retorna estatísticas agregadas (total de despesas, top 5 operadoras).

---

## 4.2.+ Escolhas e decisões tomadas

### 4.2.1 Escolha do Framework

Optei pelo **FastAPI** após considerar o Flask pela simplicidade inicial.
No entanto, pensando em **performance**, **escalabilidade**, **manutenção contínua** e **crescimento do sistema**, o FastAPI se mostrou mais adequado para esse cenário.

---

### 4.2.2 Estratégia de Paginação

Foi escolhida a paginação por **offset**, considerando que a aplicação é um **painel administrativo** voltado para análise e auditoria de dados, onde navegar para páginas específicas é essencial.

---

### 4.2.3 Cache vs Queries Diretas

Foi adotado **cache** no endpoint `/api/estatisticas`, pois ele executa operações de agregação que podem se tornar custosas em cenários com múltiplos usuários concorrentes, impactando diretamente a performance do banco.

---

### 4.2.4 Respostas da API

Foi adotado o padrão **Dados + Metadados**, pois ele facilita o consumo da API no frontend, entregando não apenas os dados, mas também informações úteis como paginação, totais e contexto da resposta.

---

# 4.3 Início do Frontend

Foi criada a pasta `frontend/`, responsável pela aplicação em **Vue 3**.
Dentro dela, o projeto foi iniciado como `vue-project`.

Estrutura principal dentro de `src/`:

* `router/` — Definição das rotas
* `services/` — Comunicação com a API do backend
* `views/` — Telas e templates da aplicação
* `App.vue` — Componente raiz
* `main.js` — Inicialização do Vue e configuração global

---

## 4.3.1 Estratégia de Busca

Foi adotada a estratégia **híbrida (servidor + cliente)**.
A busca principal ocorre no servidor via parâmetros de query, evitando o envio de grandes volumes de dados ao frontend.

---

## 4.3.2 Gerenciamento de Estado

Foi escolhida a **Opção C — Composables (Vue 3)**, aproveitando a Composition API por oferecer melhor reutilização de lógica, menor acoplamento e maior escalabilidade.

---

## 4.3.3 Performance da Tabela

Para lidar com grande volume de dados:

* Paginação no backend
* Renderização apenas dos dados necessários no frontend

Essa abordagem evita sobrecarga no navegador.

---

## 4.3.4 Tratamento de Erros e Loading

A aplicação trata explicitamente:

* **Loading** durante requisições
* **Erros de rede/API** com mensagens claras
* **Dados vazios**, exibindo feedback ao usuário

Mensagens específicas foram priorizadas para melhorar a experiência do usuário.

---

## 4.4 Documentação no Postman

Todas as rotas da API estão documentadas em uma coleção do **Postman**, contendo exemplos completos de requisições e respostas esperadas, facilitando testes, validações e uso por terceiros.

>Dentro da pasta postman\ ficou a coleção que eu criei

abaixo está como ficou as rotas criadas na coleção do Postman
```json
{
  "openapi": "3.1.0",
  "info": {
    "title": "API de Operadoras e Despesas",
    "version": "1.0.0",
    "description": "API para consulta de operadoras, despesas e estatísticas agregadas"
  },
  "paths": {
    "/": {
      "get": {
        "summary": "Health Check",
        "description": "Verifica se o servidor está ativo",
        "responses": {
          "200": {
            "description": "Servidor em funcionamento"
          }
        }
      }
    },

    "/api/operadoras": {
      "get": {
        "summary": "Listar Operadoras",
        "description": "Lista operadoras cadastradas com paginação",
        "parameters": [
          {
            "name": "page",
            "in": "query",
            "schema": { "type": "integer", "minimum": 1, "default": 1 }
          },
          {
            "name": "limit",
            "in": "query",
            "schema": { "type": "integer", "default": 10 }
          }
        ],
        "responses": {
          "200": {
            "description": "Lista de operadoras",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": { "$ref": "#/components/schemas/OperadoraCadastral" }
                }
              }
            }
          }
        }
      }
    },

    "/api/operadoras/{cnpj}": {
      "get": {
        "summary": "Detalhar Operadora",
        "description": "Retorna os dados de uma operadora pelo CNPJ",
        "parameters": [
          {
            "name": "cnpj",
            "in": "path",
            "required": true,
            "schema": { "type": "string" }
          }
        ],
        "responses": {
          "200": {
            "description": "Operadora encontrada",
            "content": {
              "application/json": {
                "schema": { "$ref": "#/components/schemas/OperadoraCadastral" }
              }
            }
          },
          "404": {
            "description": "Operadora não encontrada"
          }
        }
      }
    },

    "/api/operadoras/{cnpj}/despesas": {
      "get": {
        "summary": "Listar Despesas da Operadora",
        "description": "Retorna o histórico de despesas de uma operadora",
        "parameters": [
          {
            "name": "cnpj",
            "in": "path",
            "required": true,
            "schema": { "type": "string" }
          }
        ],
        "responses": {
          "200": {
            "description": "Lista de despesas",
            "content": {
              "application/json": {
                "schema": {
                  "type": "array",
                  "items": { "$ref": "#/components/schemas/DespesasConsolidadas" }
                }
              }
            }
          }
        }
      }
    },

    "/api/estatisticas": {
      "get": {
        "summary":

```

---

##  Principais Decisões 

* **FastAPI** foi escolhido pela performance, tipagem forte e facilidade de escalar.
* **PostgreSQL** como banco relacional, adequado para consultas analíticas e agregações.
* **Paginação por offset** para facilitar auditoria e navegação entre páginas.
* **Cache** em endpoints custosos para reduzir carga no banco.
* **Agregações no banco de dados**, evitando processamento desnecessário no backend.
* **Frontend desacoplado**, consumindo a API via serviços dedicados.
* **Documentação completa via Postman**, com exemplos reais de uso.

---

>  Este documento é confidencial e não deve ser divulgado ou copiado sem autorização expressa do remetente.

---

##  Trade-offs Técnicos Considerados

###  Paginação

A paginação foi aplicada no backend para evitar retorno de grandes volumes de dados, melhorando a performance e reduzindo o consumo de memória tanto no servidor quanto no frontend.

---

###  Cache de estatísticas

O endpoint de estatísticas executa queries de agregação (SUM, ORDER BY, LIMIT).
Para evitar consultas repetidas e custosas, foi aplicado cache com TTL de 10 minutos, equilibrando **performance** e **atualização dos dados**.

---

###  Agregações no banco

Optei por realizar cálculos diretamente no banco de dados, aproveitando suas otimizações internas e reduzindo o tráfego de dados entre banco e aplicação.

---

###  CORS restrito ao ambiente de desenvolvimento

As origens permitidas foram limitadas a `localhost`, evitando exposição indevida da API durante o desenvolvimento.


---

