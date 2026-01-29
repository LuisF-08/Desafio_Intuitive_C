-- Operadoras acima da média geral em pelo menos 2 trimestres
SELECT COUNT(*) AS total_operadoras
FROM (
    SELECT
        cnpj,
        COUNT(*) AS qtd_trimestres
    FROM despesas_consolidadas
    WHERE valor_despesa > (
        SELECT AVG(valor_despesa)
        FROM despesas_consolidadas
    )
    GROUP BY cnpj
) t
WHERE qtd_trimestres >= 2;
