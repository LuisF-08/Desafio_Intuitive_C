-- Tabelas Temporária
CREATE TEMP TABLE stg_despesas (
    cnpj TEXT,
    razao_social TEXT,
    ano TEXT,
    trimestre TEXT,
    valor_despesa TEXT
);

-- Cargando arquivos 
COPY stg_despesas FROM 'E:\P_Intuitive_Care\data\consolidando_despesas.csv' 
WITH (FORMAT CSV, HEADER, DELIMITER ',', ENCODING 'UTF8');

-- Insere Operadoras Faltantes 
INSERT INTO operadora_cadastrais (cnpj, razao_social, cnpj_valido, registro_ans, modalidade, uf)
SELECT DISTINCT ON (cnpj_limpo)
    REGEXP_REPLACE(cnpj, '[^0-9]', '', 'g') AS cnpj_limpo,
    TRIM(razao_social),
    TRUE,
    '000000',
    'DESCONHECIDA',
    'XX'
FROM stg_despesas
WHERE cnpj IS NOT NULL AND cnpj <> ''
ON CONFLICT (cnpj) DO NOTHING;

-- Insere Despesas
INSERT INTO despesas_consolidadas (cnpj, razao_social, ano, trimestre, valor_despesa)
SELECT 
    REGEXP_REPLACE(cnpj, '[^0-9]', '', 'g'),
    TRIM(razao_social),
    TO_DATE(TRIM(ano) || '-01-01', 'YYYY-MM-DD'),
    CAST(TRIM(trimestre) AS INTEGER),
    CAST(REPLACE(REPLACE(TRIM(valor_despesa), ',', '.'), 'R$', '') AS DECIMAL(18,2))
FROM stg_despesas
WHERE cnpj IS NOT NULL AND cnpj <> '';

-- Limpando
DROP TABLE stg_despesas;