-- ================================================
-- SISTEMA DE CONTROLE DE OFICINA MECÂNICA
-- Banco de Dados Completo v3.0 - VERSÃO FINAL
-- ================================================

-- Dropar banco se existir (seguro)
DROP DATABASE IF EXISTS oficina_mecanica;

-- Criar banco de dados
CREATE DATABASE oficina_mecanica CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE oficina_mecanica;

-- ================================================
-- TABELA 1: CLIENTE
-- ================================================
CREATE TABLE CLIENTE (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(11),
    email VARCHAR(100),
    endereco VARCHAR(150),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_cliente_email UNIQUE (email),
    INDEX idx_cliente_nome (nome)
);

-- ================================================
-- TABELA 2: VEICULO
-- ================================================
CREATE TABLE VEICULO (
    id INT PRIMARY KEY AUTO_INCREMENT,
    placa VARCHAR(10) NOT NULL UNIQUE,
    marca_modelo VARCHAR(100) NOT NULL,
    ano INT,
    cor VARCHAR(30),
    id_cliente INT NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_veiculo_cliente (id_cliente),
    INDEX idx_veiculo_placa (placa)
);

-- ================================================
-- TABELA 3: TABELA_MAO_OBRA (REFERÊNCIA)
-- ================================================
CREATE TABLE TABELA_MAO_OBRA (
    id INT PRIMARY KEY AUTO_INCREMENT,
    descricao_servico VARCHAR(200) NOT NULL,
    valor_referencia DECIMAL(10, 2) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo TINYINT DEFAULT 1,
    INDEX idx_mao_obra_descricao (descricao_servico),
    INDEX idx_tabela_mao_obra_ativo (ativo)
);

-- ================================================
-- TABELA 4: MECANICO
-- ================================================
CREATE TABLE MECANICO (
    codigo INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(150),
    especialidade VARCHAR(100) NOT NULL,
    telefone VARCHAR(11),
    email VARCHAR(100),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_mecanico_email UNIQUE (email),
    INDEX idx_mecanico_especialidade (especialidade),
    INDEX idx_mecanico_nome (nome)
);

-- ================================================
-- TABELA 5: EQUIPE
-- ================================================
CREATE TABLE EQUIPE (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome_equipe VARCHAR(100) NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo TINYINT DEFAULT 1,
    INDEX idx_equipe_nome (nome_equipe)
);

-- ================================================
-- TABELA 6: EQUIPE_MECANICO (ASSOCIATIVA N:M)
-- ================================================
CREATE TABLE EQUIPE_MECANICO (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_equipe INT NOT NULL,
    codigo_mecanico INT NOT NULL,
    data_associacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_remocao TIMESTAMP NULL,
    ativo TINYINT DEFAULT 1,
    FOREIGN KEY (id_equipe) REFERENCES EQUIPE(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (codigo_mecanico) REFERENCES MECANICO(codigo) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY uk_equipe_mecanico (id_equipe, codigo_mecanico),
    INDEX idx_equipe_mecanico_ativo (ativo)
);

-- ================================================
-- TABELA 7: ORDEM_SERVICO
-- ================================================
CREATE TABLE ORDEM_SERVICO (
    numero INT PRIMARY KEY AUTO_INCREMENT,
    data_emissao DATE NOT NULL,
    data_entrega DATE,
    data_conclusao DATE,
    valor_total DECIMAL(10, 2) DEFAULT 0.00,
    status VARCHAR(30) NOT NULL DEFAULT 'Aberta',
    autorizado_cliente TINYINT DEFAULT 0,
    id_veiculo INT NOT NULL,
    id_equipe INT NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (id_veiculo) REFERENCES VEICULO(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_equipe) REFERENCES EQUIPE(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CHECK (status IN ('Aberta', 'Em Execução', 'Concluída', 'Cancelada')),
    INDEX idx_os_status (status),
    INDEX idx_os_data_emissao (data_emissao),
    INDEX idx_os_veiculo (id_veiculo),
    INDEX idx_os_equipe (id_equipe),
    INDEX idx_os_autorizado (autorizado_cliente),
    INDEX idx_os_data_conclusao (data_conclusao)
);

-- ================================================
-- TABELA 8: SERVICO
-- ================================================
CREATE TABLE SERVICO (
    id INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(200) NOT NULL,
    valor_mao_obra DECIMAL(10, 2) NOT NULL,
    id_mao_obra INT,
    numero_os INT NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (numero_os) REFERENCES ORDEM_SERVICO(numero) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_mao_obra) REFERENCES TABELA_MAO_OBRA(id) ON DELETE SET NULL ON UPDATE CASCADE,
    INDEX idx_servico_os (numero_os),
    INDEX idx_servico_mao_obra (id_mao_obra)
);

-- ================================================
-- TABELA 9: PECA
-- ================================================
CREATE TABLE PECA (
    id INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(200) NOT NULL,
    valor_unitario DECIMAL(10, 2) NOT NULL,
    quantidade_estoque INT NOT NULL DEFAULT 0,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo TINYINT DEFAULT 1,
    INDEX idx_peca_descricao (descricao),
    INDEX idx_peca_ativo (ativo),
    INDEX idx_peca_valor (valor_unitario)
);

-- ================================================
-- TABELA 10: SERVICO_PECA (ASSOCIATIVA N:M)
-- ================================================
CREATE TABLE SERVICO_PECA (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_servico INT NOT NULL,
    id_peca INT NOT NULL,
    quantidade_utilizada INT NOT NULL DEFAULT 1,
    data_associacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_servico) REFERENCES SERVICO(id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (id_peca) REFERENCES PECA(id) ON DELETE RESTRICT ON UPDATE CASCADE,
    UNIQUE KEY uk_servico_peca (id_servico, id_peca),
    INDEX idx_servico_peca_peca (id_peca)
);

-- ================================================
-- TRIGGERS - CÁLCULO AUTOMÁTICO DE VALOR TOTAL
-- ================================================

DELIMITER $$

-- Trigger 1: Inserir serviço
CREATE TRIGGER atualizar_valor_os_insert_servico
AFTER INSERT ON SERVICO
FOR EACH ROW
BEGIN
    UPDATE ORDEM_SERVICO
    SET valor_total = (
        SELECT COALESCE(SUM(s.valor_mao_obra), 0) +
               COALESCE((
                   SELECT SUM(sp.quantidade_utilizada * p.valor_unitario)
                   FROM SERVICO_PECA sp
                   JOIN PECA p ON sp.id_peca = p.id
                   WHERE sp.id_servico IN (SELECT id FROM SERVICO WHERE numero_os = NEW.numero_os)
               ), 0)
        FROM SERVICO s
        WHERE s.numero_os = NEW.numero_os
    ),
    data_atualizacao = CURRENT_TIMESTAMP
    WHERE numero = NEW.numero_os;
END$$

-- Trigger 2: Deletar serviço
CREATE TRIGGER atualizar_valor_os_delete_servico
AFTER DELETE ON SERVICO
FOR EACH ROW
BEGIN
    UPDATE ORDEM_SERVICO
    SET valor_total = (
        SELECT COALESCE(SUM(s.valor_mao_obra), 0) +
               COALESCE((
                   SELECT SUM(sp.quantidade_utilizada * p.valor_unitario)
                   FROM SERVICO_PECA sp
                   JOIN PECA p ON sp.id_peca = p.id
                   WHERE sp.id_servico IN (SELECT id FROM SERVICO WHERE numero_os = OLD.numero_os)
               ), 0)
        FROM SERVICO s
        WHERE s.numero_os = OLD.numero_os
    ),
    data_atualizacao = CURRENT_TIMESTAMP
    WHERE numero = OLD.numero_os;
END$$

-- Trigger 3: Inserir peça em serviço
CREATE TRIGGER atualizar_valor_os_insert_peca
AFTER INSERT ON SERVICO_PECA
FOR EACH ROW
BEGIN
    UPDATE ORDEM_SERVICO
    SET valor_total = (
        SELECT COALESCE(SUM(s.valor_mao_obra), 0) +
               COALESCE((
                   SELECT SUM(sp.quantidade_utilizada * p.valor_unitario)
                   FROM SERVICO_PECA sp
                   JOIN PECA p ON sp.id_peca = p.id
                   WHERE sp.id_servico IN (SELECT id FROM SERVICO WHERE numero_os = s.numero_os)
               ), 0)
        FROM SERVICO s
        WHERE s.numero_os = (SELECT numero_os FROM SERVICO WHERE id = NEW.id_servico)
    ),
    data_atualizacao = CURRENT_TIMESTAMP
    WHERE numero = (SELECT numero_os FROM SERVICO WHERE id = NEW.id_servico);
END$$

-- Trigger 4: Deletar peça de serviço
CREATE TRIGGER atualizar_valor_os_delete_peca
AFTER DELETE ON SERVICO_PECA
FOR EACH ROW
BEGIN
    UPDATE ORDEM_SERVICO
    SET valor_total = (
        SELECT COALESCE(SUM(s.valor_mao_obra), 0) +
               COALESCE((
                   SELECT SUM(sp.quantidade_utilizada * p.valor_unitario)
                   FROM SERVICO_PECA sp
                   JOIN PECA p ON sp.id_peca = p.id
                   WHERE sp.id_servico IN (SELECT id FROM SERVICO WHERE numero_os = s.numero_os)
               ), 0)
        FROM SERVICO s
        WHERE s.numero_os = (SELECT numero_os FROM SERVICO WHERE id = OLD.id_servico)
    ),
    data_atualizacao = CURRENT_TIMESTAMP
    WHERE numero = (SELECT numero_os FROM SERVICO WHERE id = OLD.id_servico);
END$$

-- Trigger 5: Atualizar valor de serviço
CREATE TRIGGER atualizar_valor_os_update_servico
AFTER UPDATE ON SERVICO
FOR EACH ROW
BEGIN
    UPDATE ORDEM_SERVICO
    SET valor_total = (
        SELECT COALESCE(SUM(s.valor_mao_obra), 0) +
               COALESCE((
                   SELECT SUM(sp.quantidade_utilizada * p.valor_unitario)
                   FROM SERVICO_PECA sp
                   JOIN PECA p ON sp.id_peca = p.id
                   WHERE sp.id_servico IN (SELECT id FROM SERVICO WHERE numero_os = NEW.numero_os)
               ), 0)
        FROM SERVICO s
        WHERE s.numero_os = NEW.numero_os
    ),
    data_atualizacao = CURRENT_TIMESTAMP
    WHERE numero = NEW.numero_os;
END$$

DELIMITER ;

-- ================================================
-- MENSAGEM DE SUCESSO
-- ================================================

SELECT '✅ BANCO DE DADOS CRIADO COM SUCESSO!' AS status;
SELECT '✅ 10 tabelas criadas' AS info;
SELECT '✅ 5 triggers configurados' AS info;
SELECT '✅ 15+ índices para performance' AS info;
SELECT '✅ SERVICO ligado a TABELA_MAO_OBRA' AS info;
SELECT '✅ ORDEM_SERVICO com autorização e auditoria' AS info;
SELECT '✅ Pronto para usar!' AS info;