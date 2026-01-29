-- query para obter  os 5 operadoras com maior crescimento percentual de despesas entre o 1 e 3 semestre
SELECT
    d1.razao_social,
    ROUND(
        ((d2.valor_despesa - d1.valor_despesa) / d1.valor_despesa) * 100,
        2
    ) AS crescimento_percentual
FROM despesas_consolidadas d1
JOIN despesas_consolidadas d2
    ON d1.cnpj = d2.cnpj
WHERE d1.trimestre = (
        SELECT MIN(trimestre)
        FROM despesas_consolidadas
        WHERE cnpj = d1.cnpj
      )
  AND d2.trimestre = (
        SELECT MAX(trimestre)
        FROM despesas_consolidadas
        WHERE cnpj = d2.cnpj
      )
  AND d1.valor_despesa > 0
ORDER BY crescimento_percentual DESC
LIMIT 5;
