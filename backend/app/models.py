from typing import Optional
from decimal import Decimal
from sqlmodel import SQLModel, Field
from pydantic import BaseModel
from typing import List

# Tabela 1: despesas_agregadas
class DespesasAgregadas(SQLModel, table=True):
    __tablename__ = "despesas_agregadas"

    id: Optional[int] = Field(default=None, primary_key=True)
    razao_social: str = Field(index=True) # Indexado para busca rápida por nome
    uf: str = Field(max_length=2)
    total_despesas: Decimal = Field(default=0, max_digits=20, decimal_places=2)
    media_trimestral: Decimal = Field(default=0, max_digits=20, decimal_places=2)
    desvio_padrao: Decimal = Field(default=0, max_digits=20, decimal_places=4)

# Tabela 2: despesas_consolidadas
class DespesasConsolidadas(SQLModel, table=True):
    __tablename__ = "despesas_consolidadas"

    id: Optional[int] = Field(default=None, primary_key=True)  # chave primária
    cnpj: str = Field(index=True)
    razao_social: str
    ano: int
    trimestre: int
    valor_despesa: Decimal = Field(max_digits=20, decimal_places=2)

# Tabela 3: operadora_cadastrais
class OperadoraCadastral(SQLModel, table=True):
    __tablename__ = "operadora_cadastrais"

    id: Optional[int] = Field(default=None, primary_key=True)
    cnpj: str = Field(index=True, unique=True) # CNPJ único nesta tabela
    razao_social: str
    ano: int
    trimestre: int
    cnpj_valido: bool = False
    registro_ans: str
    modalidade: str
    uf: str
    

class EstatisticasResponse(BaseModel):
    top_5_operadoras: List[DespesasAgregadas]
    custo_total_sistema: float
    mensagem: str
