-- ================================================
-- INSERÇÃO DE DADOS DE TESTE
-- ================================================

-- ================================================
-- INSERIR CLIENTES
-- ================================================
INSERT INTO CLIENTE (nome, telefone, email, endereco) VALUES
('João Silva', '11987654321', 'joao@email.com', 'Rua A, 123, Guarulhos'),
('Maria Santos', '11987654322', 'maria@email.com', 'Av. B, 456, São Paulo'),
('Carlos Oliveira', '11987654323', 'carlos@email.com', 'Rua C, 789, Guarulhos'),
('Ana Costa', '11987654324', 'ana@email.com', 'Rua D, 101, Taboão');

-- ================================================
-- INSERIR VEÍCULOS
-- ================================================
INSERT INTO VEICULO (placa, marca_modelo, ano, cor, id_cliente) VALUES
('ABC-1234', 'Toyota Corolla', 2018, 'Branco', 1),
('DEF-5678', 'Honda Civic', 2020, 'Preto', 2),
('GHI-9012', 'Volkswagen Gol', 2015, 'Vermelho', 3),
('JKL-3456', 'Chevrolet Onix', 2019, 'Prata', 4),
('MNO-7890', 'Ford Focus', 2017, 'Azul', 1);

-- ================================================
-- INSERIR TABELA DE REFERÊNCIA DE MÃO-DE-OBRA
-- ================================================
INSERT INTO TABELA_MAO_OBRA (descricao_servico, valor_referencia) VALUES
('Troca de Óleo', 80.00),
('Limpeza de Motor', 120.00),
('Verificação de Correia', 90.00),
('Troca de Pastilha de Freio', 150.00),
('Revisão de Disco de Freio', 100.00),
('Reparo de Cilindro de Motor', 350.00),
('Troca de Velas', 60.00),
('Reparo de Sistema Elétrico', 200.00),
('Recarga de Ar Condicionado', 180.00),
('Inspeção Completa de Freios', 120.00);

-- ================================================
-- INSERIR MECÂNICOS
-- ================================================
INSERT INTO MECANICO (nome, endereco, especialidade, telefone, email) VALUES
('Pedro Martins', 'Rua X, 111', 'Motor e Transmissão', '11988889999', 'pedro@oficina.com'),
('José Ferreira', 'Rua Y, 222', 'Freios e Suspensão', '11988881111', 'jose@oficina.com'),
('Ricardo Gomes', 'Rua Z, 333', 'Elétrica e Ar Condicionado', '11988882222', 'ricardo@oficina.com'),
('Felipe Costa', 'Rua W, 444', 'Lataria e Pintura', '11988883333', 'felipe@oficina.com'),
('Bruno Alves', 'Rua V, 555', 'Motor e Transmissão', '11988884444', 'bruno@oficina.com');

-- ================================================
-- INSERIR EQUIPES
-- ================================================
INSERT INTO EQUIPE (nome_equipe) VALUES
('Equipe A - Motor'),
('Equipe B - Freios'),
('Equipe C - Elétrica'),
('Equipe D - Geral');

-- ================================================
-- ASSOCIAR MECÂNICOS ÀS EQUIPES
-- ================================================
INSERT INTO EQUIPE_MECANICO (id_equipe, codigo_mecanico) VALUES
(1, 1),
(1, 5),
(2, 2),
(3, 3),
(4, 4),
(4, 1),
(4, 2);

-- ================================================
-- INSERIR PEÇAS
-- ================================================
INSERT INTO PECA (descricao, valor_unitario, quantidade_estoque) VALUES
('Filtro de Ar', 45.00, 20),
('Filtro de Óleo', 35.00, 25),
('Vela de Ignição', 28.00, 30),
('Pastilha de Freio', 85.00, 15),
('Disco de Freio', 150.00, 10),
('Óleo de Motor (1L)', 32.00, 50),
('Fluido de Freio (1L)', 55.00, 20),
('Corrente de Distribuição', 280.00, 5),
('Correia Serpentina', 65.00, 12),
('Bateria Automotiva', 320.00, 8),
('Amortecedor Dianteiro', 185.00, 6),
('Pneu Aro 15', 220.00, 10),
('Lâmpada H7', 25.00, 40),
('Ar Condicionado - Gás', 120.00, 15);

-- ================================================
-- INSERIR ORDENS DE SERVIÇO
-- ================================================
INSERT INTO ORDEM_SERVICO (data_emissao, data_entrega, status, autorizado_cliente, id_veiculo, id_equipe) VALUES
('2026-04-10', '2026-04-12', 'Concluída', 1, 1, 1),
('2026-04-11', '2026-04-13', 'Concluída', 1, 2, 2),
('2026-04-12', '2026-04-15', 'Em Execução', 1, 3, 1),
('2026-04-13', '2026-04-16', 'Aberta', 0, 4, 3),
('2026-04-14', '2026-04-17', 'Aberta', 1, 5, 2);

-- ================================================
-- INSERIR SERVIÇOS
-- ================================================

-- OS 1
INSERT INTO SERVICO (descricao, valor_mao_obra, id_mao_obra, numero_os) VALUES
('Troca de Óleo', 80.00, 1, 1),
('Limpeza de Motor', 120.00, 2, 1),
('Verificação de Correia', 90.00, 3, 1);

-- OS 2
INSERT INTO SERVICO (descricao, valor_mao_obra, id_mao_obra, numero_os) VALUES
('Troca de Pastilha de Freio', 150.00, 4, 2),
('Revisão de Disco de Freio', 100.00, 5, 2);

-- OS 3
INSERT INTO SERVICO (descricao, valor_mao_obra, id_mao_obra, numero_os) VALUES
('Reparo de Cilindro de Motor', 350.00, 6, 3),
('Troca de Velas', 60.00, 7, 3);

-- OS 4
INSERT INTO SERVICO (descricao, valor_mao_obra, id_mao_obra, numero_os) VALUES
('Reparo de Sistema Elétrico', 200.00, 8, 4),
('Recarga de Ar Condicionado', 180.00, 9, 4);

-- OS 5
INSERT INTO SERVICO (descricao, valor_mao_obra, id_mao_obra, numero_os) VALUES
('Inspeção Completa de Freios', 120.00, 10, 5);

-- ================================================
-- ASSOCIAR PEÇAS AOS SERVIÇOS
-- ================================================

-- Serviço 1 (Troca de Óleo)
INSERT INTO SERVICO_PECA (id_servico, id_peca, quantidade_utilizada) VALUES
(1, 2, 1),
(1, 6, 3);

-- Serviço 3 (Verificação de Correia)
INSERT INTO SERVICO_PECA (id_servico, id_peca, quantidade_utilizada) VALUES
(3, 9, 1);

-- Serviço 4 (Troca de Pastilha)
INSERT INTO SERVICO_PECA (id_servico, id_peca, quantidade_utilizada) VALUES
(4, 4, 2);

-- Serviço 5 (Revisão de Disco)
INSERT INTO SERVICO_PECA (id_servico, id_peca, quantidade_utilizada) VALUES
(5, 5, 2);

-- Serviço 6 (Reparo de Cilindro)
INSERT INTO SERVICO_PECA (id_servico, id_peca, quantidade_utilizada) VALUES
(6, 6, 2),
(6, 3, 4);

-- Serviço 7 (Troca de Velas)
INSERT INTO SERVICO_PECA (id_servico, id_peca, quantidade_utilizada) VALUES
(7, 3, 4);

-- Serviço 8 (Reparo Elétrico)
INSERT INTO SERVICO_PECA (id_servico, id_peca, quantidade_utilizada) VALUES
(8, 13, 2),
(8, 10, 1);

-- Serviço 9 (Recarga Ar)
INSERT INTO SERVICO_PECA (id_servico, id_peca, quantidade_utilizada) VALUES
(9, 14, 1);