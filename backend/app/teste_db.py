# Pasta de teste de Conexão via Postgres
from sqlmodel import text
from database import get_session 

session_gen = get_session()    # Cria o gerador
session = next(session_gen)    # Extrai a sessão real

# Agora você pode usar os métodos da sessão
result = session.exec(text("SELECT 1")).first()

# Se der 1 deu conexão com o Banco 
print(result)
