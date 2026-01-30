from fastapi import FastAPI, Depends, HTTPException, Query
from sqlmodel import SQLModel, select, func, col
from sqlmodel.ext.asyncio.session import AsyncSession
from typing import List
from aiocache import cached
from .routers import usuarios
# Importando do  projeto
from .models import OperadoraCadastral, DespesasConsolidadas, DespesasAgregadas
from .database import engine, get_session

app = FastAPI()

# rotas incluidas
app.include_router(usuarios.router)

@app.get("/")
async def root():
    return {
        "message": "SERVER ESTÁ FUNCIONANDO 🚀!!!"
        }


#  Listagem 
@app.get("/api/operadoras", response_model=List[OperadoraCadastral])

async def lista_operadoras(
    page: int = Query(1, ge=1),  
    limit: int = Query(10, le=100), # Limitando o númnero exibido , poís isso sobrecarregaria a API
    session: AsyncSession = Depends(get_session)
):
    offset = (page - 1) * limit
    statement = select(OperadoraCadastral).offset(offset).limit(limit)
    
    result = await session.exec(statement)
    operadoras = result.all()
    return operadoras

# Detalhes
@app.get("/api/operadoras/{cnpj}", response_model=OperadoraCadastral)
async def detalhar_operadora(
    cnpj: str,
    session: AsyncSession = Depends(get_session)
):
    statement = select(OperadoraCadastral).where(OperadoraCadastral.cnpj == cnpj)
    result = await session.exec(statement)
    operadora = result.first()
    
    if not operadora:
        raise HTTPException(status_code=404, detail="Operadora não encontrada!")
    
    return operadora

#   Histórico 
@app.get("/api/operadoras/{cnpj}/despesas", response_model=List[DespesasConsolidadas])
async def listar_despesas_operadora(
    cnpj: str,
    session: AsyncSession = Depends(get_session)
):
    # Dica: Validar se a operadora existe antes é uma boa prática
    statement = select(DespesasConsolidadas).where(DespesasConsolidadas.cnpj == cnpj)
    
    # AQUI O ERRO: Era Session (classe), virou session (variável injetada)
    result = await session.exec(statement) 
    
    return result.all()

# Estatísticas 

@app.get("/api/estatisticas")
async def obter_estatisticas(session: AsyncSession = Depends(get_session)):
    return await _estatisticas_cached(session)

# Cacheia para melhor perfomance de usuário
@cached(ttl=600)
async def _estatisticas_cached(session: AsyncSession):
    statement_top = (
        select(DespesasAgregadas)
        .order_by(col(DespesasAgregadas.total_despesas).desc())
        .limit(5)
    )

    statement_total = select(func.sum(DespesasAgregadas.total_despesas))

    top_5_result = await session.exec(statement_top)
    total_result = await session.exec(statement_total)

    return {
        "top_5_operadoras": top_5_result.all(),
        "custo_total_sistema": total_result.first() or 0,
        "mensagem": "Dados calculados com sucesso"
    }
