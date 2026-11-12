-- Q01: vendas sem cliente
SELECT COUNT(*) AS vendas_sem_cliente
FROM fato_vendas
WHERE id_cliente IS NULL;

-- Q02: clientes diferentes (DISTINCT dentro do COUNT; o NULL não entra na contagem)
SELECT COUNT(DISTINCT id_cliente) AS clientes_distintos
FROM fato_vendas;

-- Q03: faturamento de 2025
SELECT SUM(valor_total) AS faturamento_2025
FROM fato_vendas
WHERE data_venda BETWEEN '2025-01-01' AND '2025-12-31';

-- Q04: marcas de Higiene, sem repetição, A–Z
SELECT DISTINCT marca
FROM dim_produto
WHERE categoria = 'Higiene'
ORDER BY marca;

-- Q05: valor médio das vendas do canal Aplicativo
SELECT AVG(valor_total) AS valor_medio
FROM fato_vendas
WHERE canal = 'Aplicativo';

-- Q06: produtos de Bebidas acima de R$ 10,00
SELECT COUNT(*) AS qtd_produtos
FROM dim_produto
WHERE categoria = 'Bebidas'
  AND preco_tabela > 10.00;

-- Q07: produto mais caro (desempate pelo nome A–Z)
SELECT nome_produto, marca, preco_tabela
FROM dim_produto
ORDER BY preco_tabela DESC, nome_produto ASC
LIMIT 1;

-- Q08: produtos por categoria
SELECT categoria, COUNT(*) AS qtd_produtos
FROM dim_produto
GROUP BY categoria
ORDER BY qtd_produtos DESC, categoria ASC;

-- Q09: preço médio de tabela por categoria
SELECT categoria, AVG(preco_tabela) AS preco_medio
FROM dim_produto
GROUP BY categoria
ORDER BY preco_medio DESC;

-- Q10: clientes por cidade (só cidades com 60 ou mais)
SELECT cidade, COUNT(*) AS qtd_clientes
FROM dim_cliente
GROUP BY cidade
HAVING COUNT(*) >= 60
ORDER BY qtd_clientes DESC, cidade ASC;

-- Q11: clientes sem e-mail
SELECT COUNT(*) AS clientes_sem_email
FROM dim_cliente
WHERE email IS NULL;

-- Q12: mulheres nascidas entre 01/01/1990 e 31/12/1999
SELECT COUNT(*) AS qtd_clientes
FROM dim_cliente
WHERE sexo = 'F'
  AND data_nascimento BETWEEN '1990-01-01' AND '1999-12-31';

-- Q13: clientes cujo primeiro nome é exatamente "Ana"
-- (o espaço depois de Ana exclui Analu, Anabela etc.)
SELECT COUNT(*) AS qtd_anas
FROM dim_cliente
WHERE nome LIKE 'Ana %';

-- Q14: lojas por UF (só UFs com mais de 3 lojas)
SELECT uf, COUNT(*) AS qtd_lojas
FROM dim_loja
GROUP BY uf
HAVING COUNT(*) > 3
ORDER BY qtd_lojas DESC;

-- Q15: lojas inauguradas antes de 01/01/2007
SELECT nome_loja, cidade, data_inauguracao
FROM dim_loja
WHERE data_inauguracao < '2007-01-01'
ORDER BY data_inauguracao ASC;

-- Q16: faturamento por canal em 2025
SELECT canal, SUM(valor_total) AS faturamento
FROM fato_vendas
WHERE data_venda BETWEEN '2025-01-01' AND '2025-12-31'
GROUP BY canal
ORDER BY faturamento DESC;

-- Q17: Loja física, por forma de pagamento
SELECT forma_pagamento,
       COUNT(*)         AS qtd_linhas,
       SUM(valor_total) AS faturamento
FROM fato_vendas
WHERE canal = 'Loja física'
GROUP BY forma_pagamento
ORDER BY faturamento DESC;

-- Q18: 10 produtos com mais unidades vendidas
SELECT id_produto, SUM(quantidade) AS unidades_vendidas
FROM fato_vendas
GROUP BY id_produto
ORDER BY unidades_vendidas DESC, id_produto ASC
LIMIT 10;

-- Q19: 5 lojas com maior faturamento em 2024
SELECT id_loja, SUM(valor_total) AS faturamento
FROM fato_vendas
WHERE data_venda BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY id_loja
ORDER BY faturamento DESC
LIMIT 5;

-- Q20: lojas com mais de 300 linhas de venda
SELECT id_loja, COUNT(*) AS qtd_linhas
FROM fato_vendas
GROUP BY id_loja
HAVING COUNT(*) > 300
ORDER BY qtd_linhas DESC;

-- Q21: clientes com 70 ou mais linhas (ignorando vendas sem cliente)
SELECT id_cliente, COUNT(*) AS qtd_linhas
FROM fato_vendas
WHERE id_cliente IS NOT NULL
GROUP BY id_cliente
HAVING COUNT(*) >= 70
ORDER BY qtd_linhas DESC, id_cliente ASC;

-- Q22: linhas com desconto > 0 e desconto médio (2 casas)
SELECT COUNT(*)                  AS qtd_linhas_com_desconto,
       ROUND(AVG(desconto), 2)   AS desconto_medio
FROM fato_vendas
WHERE desconto > 0;

-- Q23: menor e maior valor_total em dezembro de 2025
SELECT MIN(valor_total) AS menor_valor,
       MAX(valor_total) AS maior_valor
FROM fato_vendas
WHERE data_venda BETWEEN '2025-12-01' AND '2025-12-31';

-- Q24: linhas e faturamento do dia 24/12/2025
SELECT COUNT(*)         AS qtd_linhas,
       SUM(valor_total) AS faturamento
FROM fato_vendas
WHERE data_venda = '2025-12-24';

-- Q25: canal Site, 2025, com desconto; top 10 por % de desconto
SELECT id_venda,
       quantidade * preco_unitario AS valor_bruto,
       desconto,
       valor_total,
       ROUND(desconto / (quantidade * preco_unitario) * 100, 2) AS percentual_desconto
FROM fato_vendas
WHERE canal = 'Site'
  AND data_venda BETWEEN '2025-01-01' AND '2025-12-31'
  AND desconto > 0
ORDER BY percentual_desconto DESC, id_venda ASC
LIMIT 10;
