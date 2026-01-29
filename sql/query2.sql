-- 5 UFs com maiores despesas + média por operadora
SELECT
    oc.uf,
    SUM(dc.valor_despesa) AS total_despesas,
    ROUND(AVG(dc.valor_despesa), 2) AS media_por_operadora
FROM despesas_consolidadas dc
JOIN operadora_cadastrais oc
    ON dc.cnpj = oc.cnpj
GROUP BY oc.uf
ORDER BY total_despesas DESC
LIMIT 5;
