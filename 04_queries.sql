-- =====================================================================
-- Consultas SQL - Oficina Mecânica
-- Cada consulta é precedida pela pergunta de negócio que ela responde.
-- =====================================================================
USE oficina_mecanica;

-- =====================================================================
-- 1. RECUPERAÇÕES SIMPLES (SELECT)
-- =====================================================================

-- 1.1 Quais clientes estão cadastrados e como entrar em contato com eles?
SELECT nome, telefone, email
FROM CLIENTE;

-- 1.2 Quais são os mecânicos e suas especialidades?
SELECT codigo, nome, especialidade
FROM MECANICO;

-- 1.3 Quais serviços a oficina oferece e qual o valor de referência da mão de obra?
SELECT descricao_servico, valor_referencia
FROM TABELA_MAO_OBRA;

-- =====================================================================
-- 2. FILTROS (WHERE)
-- =====================================================================

-- 2.1 Quais ordens de serviço ainda estão em andamento (abertas ou em execução)?
SELECT numero, data_emissao, data_entrega, status
FROM ORDEM_SERVICO
WHERE status IN ('Aberta', 'Em Execução');

-- 2.2 Quais OS estão abertas e ainda aguardam autorização do cliente?
SELECT numero, data_emissao, valor_total
FROM ORDEM_SERVICO
WHERE status = 'Aberta'
  AND autorizado_cliente = 0;

-- 2.3 Quais peças estão com estoque baixo (menos de 10 unidades)?
SELECT descricao, quantidade_estoque
FROM PECA
WHERE quantidade_estoque < 10;

-- 2.4 Quais OS foram emitidas entre 11 e 14 de abril de 2026?
SELECT numero, data_emissao, status
FROM ORDEM_SERVICO
WHERE data_emissao BETWEEN '2026-04-11' AND '2026-04-14';

-- 2.5 Quais veículos da marca Toyota ou Honda foram fabricados a partir de 2018?
SELECT placa, marca_modelo, ano
FROM VEICULO
WHERE (marca_modelo LIKE 'Toyota%' OR marca_modelo LIKE 'Honda%')
  AND ano >= 2018;

-- =====================================================================
-- 3. ATRIBUTOS DERIVADOS (expressões)
-- =====================================================================

-- 3.1 Qual a idade de cada veículo?
SELECT placa, marca_modelo, ano,
       YEAR(CURDATE()) - ano AS idade_anos
FROM VEICULO;

-- 3.2 Quanto custa cada peça usada em cada serviço (quantidade x valor unitário)?
SELECT sp.id_servico, p.descricao AS peca,
       sp.quantidade_utilizada, p.valor_unitario,
       sp.quantidade_utilizada * p.valor_unitario AS valor_pecas
FROM SERVICO_PECA sp
JOIN PECA p ON p.id = sp.id_peca;

-- 3.3 Quantos dias levou cada OS concluída, da emissão até a conclusão?
SELECT numero, data_emissao, data_conclusao,
       DATEDIFF(data_conclusao, data_emissao) AS dias_execucao
FROM ORDEM_SERVICO
WHERE status = 'Concluída';

-- 3.4 Quanto cada OS custaria com 10% de desconto para pagamento à vista?
SELECT numero, valor_total,
       ROUND(valor_total * 0.90, 2) AS valor_a_vista,
       ROUND(valor_total * 0.10, 2) AS desconto
FROM ORDEM_SERVICO
WHERE status <> 'Cancelada';

-- 3.5 Quais OS não concluídas passaram da data de entrega e há quantos dias?
SELECT numero, status, data_entrega,
       DATEDIFF(CURDATE(), data_entrega) AS dias_de_atraso
FROM ORDEM_SERVICO
WHERE status IN ('Aberta', 'Em Execução')
  AND data_entrega < CURDATE();

-- =====================================================================
-- 4. ORDENAÇÃO (ORDER BY)
-- =====================================================================

-- 4.1 Quais são as peças mais caras? (da mais cara para a mais barata)
SELECT descricao, valor_unitario
FROM PECA
ORDER BY valor_unitario DESC;

-- 4.2 Quais são as OS de maior valor? (desempate pela data de emissão mais recente)
SELECT numero, status, valor_total, data_emissao
FROM ORDEM_SERVICO
ORDER BY valor_total DESC, data_emissao DESC;

-- 4.3 Como listar os clientes em ordem alfabética?
SELECT nome, telefone
FROM CLIENTE
ORDER BY nome ASC;

-- =====================================================================
-- 5. FILTROS SOBRE GRUPOS (HAVING)
-- =====================================================================

-- 5.1 Quais clientes têm mais de uma ordem de serviço?
SELECT c.nome, COUNT(os.numero) AS qtd_os
FROM CLIENTE c
JOIN VEICULO v        ON v.id_cliente = c.id
JOIN ORDEM_SERVICO os ON os.id_veiculo = v.id
GROUP BY c.id, c.nome
HAVING COUNT(os.numero) > 1
ORDER BY qtd_os DESC;

-- 5.2 Quais equipes têm mais de um mecânico?
SELECT e.nome_equipe, COUNT(em.codigo_mecanico) AS qtd_mecanicos
FROM EQUIPE e
JOIN EQUIPE_MECANICO em ON em.id_equipe = e.id
GROUP BY e.id, e.nome_equipe
HAVING COUNT(em.codigo_mecanico) > 1;

-- 5.3 Quais peças foram utilizadas em 4 unidades ou mais no total?
SELECT p.descricao, SUM(sp.quantidade_utilizada) AS total_utilizado
FROM PECA p
JOIN SERVICO_PECA sp ON sp.id_peca = p.id
GROUP BY p.id, p.descricao
HAVING SUM(sp.quantidade_utilizada) >= 4
ORDER BY total_utilizado DESC;

-- 5.4 Quais serviços foram realizados mais de uma vez na oficina?
SELECT t.descricao_servico, COUNT(s.id) AS vezes_realizado
FROM TABELA_MAO_OBRA t
JOIN SERVICO s ON s.id_mao_obra = t.id
GROUP BY t.id, t.descricao_servico
HAVING COUNT(s.id) > 1;

-- 5.5 Quais clientes já gastaram mais de R$ 700 em OS (sem contar as canceladas)?
SELECT c.nome, SUM(os.valor_total) AS total_gasto
FROM CLIENTE c
JOIN VEICULO v        ON v.id_cliente = c.id
JOIN ORDEM_SERVICO os ON os.id_veiculo = v.id
WHERE os.status <> 'Cancelada'
GROUP BY c.id, c.nome
HAVING SUM(os.valor_total) > 700
ORDER BY total_gasto DESC;

-- =====================================================================
-- 6. JUNÇÕES (JOIN)
-- =====================================================================

-- 6.1 Qual o panorama de cada OS (cliente, veículo, equipe responsável e status)?
SELECT os.numero, c.nome AS cliente, v.placa, v.marca_modelo,
       e.nome_equipe, os.status, os.valor_total
FROM ORDEM_SERVICO os
JOIN VEICULO v ON v.id = os.id_veiculo
JOIN CLIENTE c ON c.id = v.id_cliente
JOIN EQUIPE  e ON e.id = os.id_equipe
ORDER BY os.numero;

-- 6.2 Quais serviços compõem cada OS e quanto vale a mão de obra de cada um?
SELECT os.numero AS os, s.descricao AS servico, t.valor_referencia AS mao_de_obra
FROM ORDEM_SERVICO os
JOIN SERVICO s          ON s.numero_os = os.numero
JOIN TABELA_MAO_OBRA t  ON t.id = s.id_mao_obra
ORDER BY os.numero, s.id;

-- 6.3 Quais peças cada serviço utilizou? (LEFT JOIN: inclui serviços sem peças)
SELECT s.id AS servico, s.descricao, p.descricao AS peca, sp.quantidade_utilizada
FROM SERVICO s
LEFT JOIN SERVICO_PECA sp ON sp.id_servico = s.id
LEFT JOIN PECA p          ON p.id = sp.id_peca
ORDER BY s.id;

-- 6.4 Quais mecânicos compõem cada equipe?
SELECT e.nome_equipe, m.nome AS mecanico, m.especialidade
FROM EQUIPE e
JOIN EQUIPE_MECANICO em ON em.id_equipe = e.id
JOIN MECANICO m         ON m.codigo = em.codigo_mecanico
ORDER BY e.nome_equipe, m.nome;

-- 6.5 Quais peças do catálogo nunca foram utilizadas? (LEFT JOIN + IS NULL)
SELECT p.descricao, p.quantidade_estoque
FROM PECA p
LEFT JOIN SERVICO_PECA sp ON sp.id_peca = p.id
WHERE sp.id IS NULL;

-- 6.6 O valor_total gravado em cada OS confere com o cálculo (mão de obra + peças)?
SELECT os.numero, os.valor_total AS valor_gravado,
       COALESCE(mo.total, 0) AS mao_de_obra,
       COALESCE(pc.total, 0) AS pecas,
       COALESCE(mo.total, 0) + COALESCE(pc.total, 0) AS valor_calculado
FROM ORDEM_SERVICO os
LEFT JOIN (SELECT s.numero_os, SUM(t.valor_referencia) AS total
           FROM SERVICO s
           JOIN TABELA_MAO_OBRA t ON t.id = s.id_mao_obra
           GROUP BY s.numero_os) mo ON mo.numero_os = os.numero
LEFT JOIN (SELECT s.numero_os, SUM(sp.quantidade_utilizada * p.valor_unitario) AS total
           FROM SERVICO s
           JOIN SERVICO_PECA sp ON sp.id_servico = s.id
           JOIN PECA p          ON p.id = sp.id_peca
           GROUP BY s.numero_os) pc ON pc.numero_os = os.numero
ORDER BY os.numero;

-- 6.7 Qual a receita e o ticket médio de cada equipe nas OS concluídas?
SELECT e.nome_equipe,
       COUNT(os.numero)   AS total_os,
       SUM(os.valor_total) AS receita_total,
       ROUND(AVG(os.valor_total), 2) AS ticket_medio
FROM EQUIPE e
JOIN ORDEM_SERVICO os ON os.id_equipe = e.id
WHERE os.status = 'Concluída'
GROUP BY e.id, e.nome_equipe
ORDER BY receita_total DESC;
