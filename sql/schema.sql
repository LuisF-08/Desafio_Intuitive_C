-- =====================
-- TABELAS SENDO CRIADAS
-- =====================

CREATE TABLE operadora_cadastrais (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cnpj VARCHAR(14) NOT NULL UNIQUE,
    razao_social VARCHAR(255) NOT NULL,
    cnpj_valido BOOLEAN NOT NULL,
    registro_ans VARCHAR(6) NOT NULL,
    modalidade VARCHAR(255) NOT NULL,
    uf CHAR(2) NOT NULL
);

CREATE TABLE despesas_consolidadas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cnpj VARCHAR(14) NOT NULL,
    ano INT NOT NULL,
    trimestre INT NOT NULL,
    valor_despesa DECIMAL(18,2) NOT NULL,
    FOREIGN KEY (cnpj) REFERENCES operadora_cadastrais(cnpj)
);

CREATE TABLE despesas_agregadas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(255) NOT NULL,
    uf CHAR(2) NOT NULL,
    total_despesas DECIMAL(18,2) NOT NULL,
    media_trimestral DECIMAL(18,2) NOT NULL,
    desvio_padrao DECIMAL(18,2) NOT NULL
);


CREATE INDEX idx_despesas_cnpj ON despesas_consolidadas(cnpj);
CREATE INDEX idx_agregadas_uf ON despesas_agregadas(uf);
