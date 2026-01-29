# Desafio Intuitive_Care

## Estrutura

* `data/` → arquivos brutos (1T, 2T, 3T)
* `spell.ipynb` → limpeza, validação, merge e consolidação
* `consolidando_despesas.zip` → saída final

## Etapas (resumo)

1. **Coleta**: Download dos CSVs em [https://dadosabertos.ans.gov.br/FTP/PDA/demonstracoes_contabeis/2025/](https://dadosabertos.ans.gov.br/FTP/PDA/demonstracoes_contabeis/2025/)
2. **Limpeza/Validação (spell.ipynb)**:

   * Correção de delimitador (`sep=';'`)
   * Padronização de colunas e tipos
   * Criação de `Ano` e `Trimestre`
   * Remoção de duplicatas e validações básicas
3. **Enriquecimento**:

   * Merge com base de operadoras (ativas) para obter `CNPJ` e `RazaoSocial`
   * Chaves: `REG_ANS` ↔ `REGISTRO_OPERADORA`
   * Ausentes preenchidos com `nao_encontrado`

## Resultado

Arquivo final consistente, sem duplicatas lógicas e pronto para análise:

* `consolidando_despesas.zip`

## Execução

Abrir `spell.ipynb` e executar todas as células.
