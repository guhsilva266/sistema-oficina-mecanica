-- =====================================================================
-- Persistência de dados para testes
-- Execute DEPOIS de 01_schema.sql e 02_triggers.sql
-- (valor_total das OS é calculado automaticamente pelos triggers)
-- =====================================================================
USE oficina_mecanica;

INSERT INTO CLIENTE (nome, telefone, email, endereco) VALUES
('João Silva',      '11987654321', 'joao@email.com',   'Rua A, 123, Guarulhos'),
('Maria Santos',    '11987654322', 'maria@email.com',  'Av. B, 456, São Paulo'),
('Carlos Oliveira', '11987654323', 'carlos@email.com', 'Rua C, 789, Guarulhos'),
('Ana Costa',       '11987654324', 'ana@email.com',    'Rua D, 101, Taboão');

INSERT INTO VEICULO (placa, marca_modelo, ano, cor, id_cliente) VALUES
('ABC-1234', 'Toyota Corolla',   2018, 'Branco',   1),
('DEF-5678', 'Honda Civic',      2020, 'Preto',    2),
('GHI-9012', 'Volkswagen Gol',   2015, 'Vermelho', 3),
('JKL-3456', 'Chevrolet Onix',   2019, 'Prata',    4),
('MNO-7890', 'Ford Focus',       2017, 'Azul',     1);

INSERT INTO TABELA_MAO_OBRA (descricao_servico, valor_referencia) VALUES
('Troca de Óleo',                80.00),   -- 1
('Limpeza de Motor',            120.00),   -- 2
('Verificação de Correia',       90.00),   -- 3
('Troca de Pastilha de Freio',  150.00),   -- 4
('Revisão de Disco de Freio',   100.00),   -- 5
('Reparo de Cilindro de Motor', 350.00),   -- 6
('Troca de Velas',               60.00),   -- 7
('Reparo de Sistema Elétrico',  200.00),   -- 8
('Recarga de Ar Condicionado',  180.00),   -- 9
('Inspeção Completa de Freios', 120.00);   -- 10

INSERT INTO MECANICO (nome, endereco, especialidade, telefone, email) VALUES
('Pedro Martins', 'Rua X, 111', 'Motor e Transmissão',        '11988889999', 'pedro@oficina.com'),
('José Ferreira', 'Rua Y, 222', 'Freios e Suspensão',        '11988881111', 'jose@oficina.com'),
('Ricardo Gomes', 'Rua Z, 333', 'Elétrica e Ar Condicionado','11988882222', 'ricardo@oficina.com'),
('Felipe Costa',  'Rua W, 444', 'Lataria e Pintura',         '11988883333', 'felipe@oficina.com'),
('Bruno Alves',   'Rua V, 555', 'Motor e Transmissão',        '11988884444', 'bruno@oficina.com');

INSERT INTO EQUIPE (nome_equipe) VALUES
('Equipe A - Motor'),      -- 1
('Equipe B - Freios'),     -- 2
('Equipe C - Elétrica'),   -- 3
('Equipe D - Geral');      -- 4

INSERT INTO EQUIPE_MECANICO (id_equipe, codigo_mecanico) VALUES
(1, 1), (1, 5),
(2, 2),
(3, 3),
(4, 4), (4, 1), (4, 2);

INSERT INTO PECA (descricao, valor_unitario, quantidade_estoque) VALUES
('Filtro de Ar',              45.00, 20),   -- 1
('Filtro de Óleo',            35.00, 25),   -- 2
('Vela de Ignição',           28.00, 30),   -- 3
('Pastilha de Freio',         85.00, 15),   -- 4
('Disco de Freio',           150.00, 10),   -- 5
('Óleo de Motor (1L)',        32.00, 50),   -- 6
('Fluido de Freio (1L)',      55.00, 20),   -- 7
('Corrente de Distribuição', 280.00,  5),   -- 8
('Correia Serpentina',        65.00, 12),   -- 9
('Bateria Automotiva',       320.00,  8),   -- 10
('Amortecedor Dianteiro',    185.00,  6),   -- 11
('Pneu Aro 15',              220.00, 10),   -- 12
('Lâmpada H7',                25.00, 40),   -- 13
('Gás de Ar Condicionado',   120.00, 15);   -- 14

INSERT INTO ORDEM_SERVICO
    (data_emissao, data_entrega, data_conclusao, status, autorizado_cliente, id_veiculo, id_equipe) VALUES
('2026-04-10', '2026-04-12', '2026-04-12', 'Concluída',   1, 1, 1),   -- OS 1
('2026-04-11', '2026-04-13', '2026-04-14', 'Concluída',   1, 2, 2),   -- OS 2
('2026-04-12', '2026-04-15', NULL,         'Em Execução', 1, 3, 1),   -- OS 3
('2026-04-13', '2026-04-16', NULL,         'Aberta',      0, 4, 3),   -- OS 4
('2026-04-14', '2026-04-17', NULL,         'Aberta',      1, 5, 2),   -- OS 5
('2026-04-15', '2026-04-16', '2026-04-16', 'Concluída',   1, 1, 4),   -- OS 6
('2026-04-16', '2026-04-18', NULL,         'Em Execução', 1, 2, 2),   -- OS 7
('2026-04-17', '2026-04-19', NULL,         'Cancelada',   0, 4, 3);   -- OS 8

INSERT INTO SERVICO (descricao, numero_os, id_mao_obra) VALUES
('Troca de Óleo',                1, 1),   -- 1
('Limpeza de Motor',             1, 2),   -- 2
('Verificação de Correia',       1, 3),   -- 3
('Troca de Pastilha de Freio',   2, 4),   -- 4
('Revisão de Disco de Freio',    2, 5),   -- 5
('Reparo de Cilindro de Motor',  3, 6),   -- 6
('Troca de Velas',               3, 7),   -- 7
('Reparo de Sistema Elétrico',   4, 8),   -- 8
('Recarga de Ar Condicionado',   4, 9),   -- 9
('Inspeção Completa de Freios',  5, 10),  -- 10
('Troca de Óleo',                6, 1),   -- 11
('Troca de Velas',               6, 7),   -- 12
('Inspeção Completa de Freios',  7, 10),  -- 13
('Troca de Pastilha de Freio',   7, 4),   -- 14
('Recarga de Ar Condicionado',   8, 9);   -- 15

INSERT INTO SERVICO_PECA (id_servico, id_peca, quantidade_utilizada) VALUES
(1, 2, 1), (1, 6, 3),     -- troca de óleo: filtro + óleo
(3, 9, 1),                -- correia serpentina
(4, 4, 2),                -- pastilhas
(5, 5, 2),                -- discos
(6, 6, 2), (6, 3, 4),     -- reparo de cilindro: óleo + velas
(7, 3, 4),                -- velas
(8, 13, 2), (8, 10, 1),   -- lâmpadas + bateria
(9, 14, 1),               -- gás do ar condicionado
(11, 2, 1), (11, 6, 3),   -- troca de óleo (OS 6)
(12, 3, 4),               -- velas (OS 6)
(14, 4, 2),               -- pastilhas (OS 7)
(15, 14, 1);              -- gás (OS 8)
