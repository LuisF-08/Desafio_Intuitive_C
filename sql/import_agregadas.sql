-- Tabela temporária
CREATE TEMP TABLE stg_agregadas (
    razao_social TEXT,
    uf TEXT,
    total_despesas TEXT,
    media_trimestral TEXT, 
    desvio_padrao TEXT
);

-- Cargando 
COPY stg_agregadas FROM 'E:\P_Intuitive_Care\data\despesas_agregadas.csv' 
WITH (FORMAT CSV, HEADER, DELIMITER ',', ENCODING 'UTF8');

-- Inseirindo a tabela temporaria na oficial e corrigindo erros
INSERT INTO despesas_agregadas (razao_social, uf, total_despesas, media_trimestral, desvio_padrao)
SELECT 
    TRIM(razao_social),
    TRIM(uf),
    CAST(REPLACE(REPLACE(total_despesas, 'R$', ''), ',', '.') AS DECIMAL(18,2)),
    CAST(REPLACE(REPLACE(media_trimestral, 'R$', ''), ',', '.') AS DECIMAL(18,2)),
    CAST(REPLACE(REPLACE(desvio_padrao, 'R$', ''), ',', '.') AS DECIMAL(18,2))
FROM stg_agregadas;

-- Limpeza
DROP TABLE stg_agregadas;