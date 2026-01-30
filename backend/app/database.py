from sqlalchemy.ext.asyncio import create_async_engine
from sqlmodel.ext.asyncio.session import AsyncSession
from sqlalchemy.orm import sessionmaker

# o "+asyncpg" na URL. 
DATABASE_URL = "postgresql+asyncpg://postgres:130706@localhost:5432/postgres"

# motor ASSÍNCRONO
engine = create_async_engine(DATABASE_URL, echo=True, future=True)

# função que cria sessões assíncronas
async def get_session():
    async_session = sessionmaker(
        engine,
        class_=AsyncSession,
        expire_on_commit=False
    )
    async with async_session() as session:
        yield session