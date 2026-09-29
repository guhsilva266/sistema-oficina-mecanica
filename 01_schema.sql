-- =====================================================================
-- OFICINA MECÂNICA - Esquema lógico (modelo relacional) em MySQL 8+
-- Baseado no diagrama ER do projeto anterior (ofiçina.mwb)
-- Ordem de execução: 01_schema -> 02_triggers -> 03_dados -> 04_queries
-- =====================================================================

DROP DATABASE IF EXISTS oficina_mecanica;
CREATE DATABASE oficina_mecanica CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE oficina_mecanica;

-- ---------------------------------------------------------------------
-- CLIENTE
-- ---------------------------------------------------------------------
CREATE TABLE CLIENTE (
    id        INT          PRIMARY KEY AUTO_INCREMENT,
    nome      VARCHAR(100) NOT NULL,
    telefone  VARCHAR(11),
    email     VARCHAR(100),
    endereco  VARCHAR(150),
    CONSTRAINT uk_cliente_email UNIQUE (email),
    INDEX idx_cliente_nome (nome)
);

-- ---------------------------------------------------------------------
-- VEICULO (1 cliente : N veículos)
-- ---------------------------------------------------------------------
CREATE TABLE VEICULO (
    id            INT          PRIMARY KEY AUTO_INCREMENT,
    placa         VARCHAR(10)  NOT NULL,
    marca_modelo  VARCHAR(100) NOT NULL,
    ano           INT,
    cor           VARCHAR(30),
    id_cliente    INT          NOT NULL,
    CONSTRAINT uk_veiculo_placa UNIQUE (placa),
    CONSTRAINT fk_veiculo_cliente FOREIGN KEY (id_cliente)
        REFERENCES CLIENTE (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ---------------------------------------------------------------------
-- TABELA_MAO_OBRA (tabela de referência de valores de mão de obra)
-- ---------------------------------------------------------------------
CREATE TABLE TABELA_MAO_OBRA (
    id                INT           PRIMARY KEY AUTO_INCREMENT,
    descricao_servico VARCHAR(200)  NOT NULL,
    valor_referencia  DECIMAL(10,2) NOT NULL,
    INDEX idx_mao_obra_descricao (descricao_servico)
);

-- ---------------------------------------------------------------------
-- MECANICO
-- ---------------------------------------------------------------------
CREATE TABLE MECANICO (
    codigo        INT          PRIMARY KEY AUTO_INCREMENT,
    nome          VARCHAR(100) NOT NULL,
    endereco      VARCHAR(150),
    especialidade VARCHAR(100) NOT NULL,
    telefone      VARCHAR(11),
    email         VARCHAR(100),
    CONSTRAINT uk_mecanico_email UNIQUE (email),
    INDEX idx_mecanico_especialidade (especialidade)
);

-- ---------------------------------------------------------------------
-- EQUIPE
-- ---------------------------------------------------------------------
CREATE TABLE EQUIPE (
    id          INT          PRIMARY KEY AUTO_INCREMENT,
    nome_equipe VARCHAR(100) NOT NULL
);

-- ---------------------------------------------------------------------
-- EQUIPE_MECANICO (associativa N:M entre equipe e mecânico)
-- ---------------------------------------------------------------------
CREATE TABLE EQUIPE_MECANICO (
    id              INT PRIMARY KEY AUTO_INCREMENT,
    id_equipe       INT NOT NULL,
    codigo_mecanico INT NOT NULL,
    CONSTRAINT uk_equipe_mecanico UNIQUE (id_equipe, codigo_mecanico),
    CONSTRAINT fk_em_equipe   FOREIGN KEY (id_equipe)
        REFERENCES EQUIPE (id)      ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_em_mecanico FOREIGN KEY (codigo_mecanico)
        REFERENCES MECANICO (codigo) ON DELETE CASCADE ON UPDATE CASCADE
);

-- ---------------------------------------------------------------------
-- ORDEM_SERVICO (valor_total é mantido pelos triggers de 02_triggers.sql)
-- ---------------------------------------------------------------------
CREATE TABLE ORDEM_SERVICO (
    numero             INT           PRIMARY KEY AUTO_INCREMENT,
    data_emissao       DATE          NOT NULL,
    data_entrega       DATE,
    data_conclusao     DATE,
    valor_total        DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    status             VARCHAR(30)   NOT NULL DEFAULT 'Aberta',
    autorizado_cliente TINYINT       NOT NULL DEFAULT 0,
    data_atualizacao   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    id_veiculo         INT           NOT NULL,
    id_equipe          INT           NOT NULL,
    CONSTRAINT ck_os_status CHECK (status IN ('Aberta','Em Execução','Concluída','Cancelada')),
    CONSTRAINT ck_os_autorizado CHECK (autorizado_cliente IN (0,1)),
    CONSTRAINT fk_os_veiculo FOREIGN KEY (id_veiculo)
        REFERENCES VEICULO (id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_os_equipe  FOREIGN KEY (id_equipe)
        REFERENCES EQUIPE (id)  ON DELETE RESTRICT ON UPDATE CASCADE,
    INDEX idx_os_status (status),
    INDEX idx_os_data_emissao (data_emissao)
);

-- ---------------------------------------------------------------------
-- SERVICO (serviço de uma OS; a mão de obra vem da tabela de referência)
-- ---------------------------------------------------------------------
CREATE TABLE SERVICO (
    id          INT          PRIMARY KEY AUTO_INCREMENT,
    descricao   VARCHAR(200) NOT NULL,
    numero_os   INT          NOT NULL,
    id_mao_obra INT          NOT NULL,
    CONSTRAINT fk_servico_os FOREIGN KEY (numero_os)
        REFERENCES ORDEM_SERVICO (numero) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_servico_mao_obra FOREIGN KEY (id_mao_obra)
        REFERENCES TABELA_MAO_OBRA (id) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- ---------------------------------------------------------------------
-- PECA
-- ---------------------------------------------------------------------
CREATE TABLE PECA (
    id                 INT           PRIMARY KEY AUTO_INCREMENT,
    descricao          VARCHAR(200)  NOT NULL,
    valor_unitario     DECIMAL(10,2) NOT NULL,
    quantidade_estoque INT           NOT NULL DEFAULT 0,
    INDEX idx_peca_descricao (descricao)
);

-- ---------------------------------------------------------------------
-- SERVICO_PECA (associativa N:M entre serviço e peça)
-- ---------------------------------------------------------------------
CREATE TABLE SERVICO_PECA (
    id                   INT PRIMARY KEY AUTO_INCREMENT,
    quantidade_utilizada INT NOT NULL DEFAULT 1,
    id_servico           INT NOT NULL,
    id_peca              INT NOT NULL,
    CONSTRAINT uk_servico_peca UNIQUE (id_servico, id_peca),
    CONSTRAINT fk_sp_servico FOREIGN KEY (id_servico)
        REFERENCES SERVICO (id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_sp_peca FOREIGN KEY (id_peca)
        REFERENCES PECA (id)    ON DELETE RESTRICT ON UPDATE CASCADE
);
