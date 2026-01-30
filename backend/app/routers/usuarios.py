from fastapi import APIRouter, Depends, Query
from sqlmodel import select, func
from sqlmodel.ext.asyncio.session import AsyncSession

from ..database import get_session
from ..models import OperadoraCadastral

router = APIRouter(
    prefix="/api/usuarios",
    tags=["Usuários"]
)

@router.get("/")
async def listar_usuarios(
    page: int = Query(1, ge=1),
    limit: int = Query(10, le=100),
    session: AsyncSession = Depends(get_session)
):
    offset = (page - 1) * limit

    statement = (
        select(OperadoraCadastral)
        .offset(offset)
        .limit(limit)
    )

    total_statement = select(func.count()).select_from(OperadoraCadastral)

    result = await session.exec(statement)
    total_result = await session.exec(total_statement)

    usuarios = result.all()
    total = total_result.one()

    return {
        "data": usuarios,
        "total": total,
        "page": page,
        "limit": limit
    }