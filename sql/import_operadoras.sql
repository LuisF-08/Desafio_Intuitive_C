-- Tabela temporária
CREATE TEMP TABLE stg_operadora (
    cnpj TEXT,
    razao_social TEXT,
    ano TEXT,
    trimestre TEXT,
    valor_despesa TEXT,
    cnpj_valido TEXT,
    registro_ans TEXT,
    modalidade TEXT,
    uf TEXT
);

--  Cargando
COPY stg_operadora FROM 'E:\P_Intuitive_Care\data\dados_operadoras_cadastrais.csv' 
WITH (FORMAT CSV, HEADER, DELIMITER ',', ENCODING 'UTF8');

--  Insere Operadoras 
INSERT INTO operadora_cadastrais (cnpj, razao_social, cnpj_valido, registro_ans, modalidade, uf)
SELECT DISTINCT ON (cnpj_limpo) 
    REGEXP_REPLACE(cnpj, '[^0-9]', '', 'g') AS cnpj_limpo,
    TRIM(razao_social),
    CASE WHEN UPPER(TRIM(cnpj_valido)) = 'TRUE' THEN TRUE ELSE FALSE END,
    TRIM(registro_ans),
    TRIM(modalidade),
    TRIM(uf)
FROM stg_operadora
WHERE cnpj IS NOT NULL AND cnpj <> ''
ON CONFLICT (cnpj) DO NOTHING; 

--  Inserindo Despesas
INSERT INTO despesas_consolidadas (cnpj, razao_social, ano, trimestre, valor_despesa)
SELECT 
    REGEXP_REPLACE(cnpj, '[^0-9]', '', 'g'),
    TRIM(razao_social),
    TO_DATE(TRIM(ano) || '-01-01', 'YYYY-MM-DD'), 
    CAST(TRIM(trimestre) AS INTEGER),
    CAST(TRIM(valor_despesa) AS DECIMAL(18,2))
FROM stg_operadora
WHERE cnpj IS NOT NULL AND cnpj <> '';

-- Limpeza
DROP TABLE stg_operadora;