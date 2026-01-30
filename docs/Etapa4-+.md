# 4.1 estruturação da API
Como foi escolhido por mim eu usarei o PostgreSQL com as 3 tabelas.
>despesas_agregadas
>despesas_consolidadas
>operadora_cadastrais

#### Criarei a pasta app/ dentro de backend/, e dentro criarei os 
```python
__init__.py  # Usado para o python detectar como executavel o arquivo
main.py      # Arquivo de ponto de entrada
database.py  # Configuração de comunicação do Postgres
models.py    # Modelo de tabelas do Banco
teste_db.py  # Testando conexão do banco
routers/     # Endpoints(rotas da APi)
routers/__init.py
routers/usuarios.py # Crud de usuarios 
requirements.txt
```

# 4.2 Criação de Rotas 

#### Criei as rotas no Arquivo main.py, onde 

>on_startup()   #Inicia oassincronismo
>lista_operadoras()  #Lista os operadores colocando limite de exibição total de operadores
>detalhar_operadora   #Detalhas os operadores com base na coluna 'cnpj'
>listar_despesas_operadora   # lista as despesas com base no #cnpj passado
>obter_estatisticas     # obtem as estatísticas agregadas (total de despesas,média, top 5 operadoras)

## 4.2.+ (Escolhas e decisões que foram tomadas)

###  4.2.1 - Escolha do Framework:
> Escolhi o FastAPI, na hora de escolher fiquei muito pensativo , pois a facilidade de iniciar algo com flask é umponto muito forte dele, entretanto, quando falamos de escalabilidade, performance , manutenção constante e ampliação do sistemas eu tendo a ir para o FAstAPI , pois nesses aspectos que falei ele ,para mim se sairia muito superior ao flask.

### 4.2.2 -  Estratégia de Paginação:
> escolhi o offset, Considerando que a aplicação é um painel administrativo para visualização de dados cadastrais e financeiros , a paginação por Offset é a mais indicada permitindo ao usuário navegar para páginas específicas , o que é essencial para auditoria e análise de dados.

### 4.2.3 - Chache ou Querys diretas
> Escolhi por Cache, rota /api/estatisticas executa operações de agregação (Soma, Média, Ordenação) que são computacionalmente custosas para o Banco de Dados, quando pensamos em um cenário real em que multiplos usuários estão usando o Banco de dados , se tornaria lenta as querys levando até horas dependendo da complexidade da query, logo em questão de perfomance se torna melhor 

### 4.2.4 - Respostas da API

> Eu prefiro fazer de Dados+Metadados, pois é mais completa e facilita bastante o consumo da API e para exibição de dados no front-end. Além de retornar os dados, ela já entrega informações importantes(total de registros, página atual , etc....), o que simplifica a implementação da paginação no front-end e em outros consumidores da API.



# 4.3 Inicio do front-end

### Nessa parte como dito antes, criei um pasta chamada frontend/ que irá ficar responsável pla parte do Vue, dentro baixei o vue como vue-project.

#### dentro do vue-project está todas as ferramentas nescessárias para subir a página, crie dentro de src as pastas:

>router\ #3 Caminho das rotas
>services\ #Comunicação com a api desenvolvida no backend
>views\ 3 local onde fica a visualização das requisições
>App.vue # padrão do Vue para encontrar um template 
>main.js # inicializa o vue, junto com as demais depencias e prepara as rotas 